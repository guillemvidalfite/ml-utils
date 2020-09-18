import logging
import argparse
import sys
import json
import os
import pandas as pd 
import time
import numpy as np

from bigml.api import BigML
from datetime import datetime

# HTTPS WARNINGS workaround https://github.com/influxdata/influxdb-python/issues/240
import urllib3
urllib3.disable_warnings(urllib3.exceptions.InsecureRequestWarning)

####################################################################################
####### PROCEDURES
####################################################################################


#### INIT CONFIG ################################################################################
def init_config(json_file_path):
     """Initializes environment variables from given JSON file into a dictionnary"""
     with open(json_file_path, "r") as f:
      config_dict = json.load(f)

     return config_dict

#### INIT LOGGER ################################################################################
def init_logger(log_level):
     """Initializes log structure. """
     LOGGER = logging.getLogger()
     LOGGER.setLevel(log_level)

     ch = logging.StreamHandler(sys.stdout)
     # ch.setLevel('INFO')
     formatter = logging.Formatter(
        '%(asctime)s - %(name)s - %(levelname)s - %(message)s')
     ch.setFormatter(formatter)
     LOGGER.addHandler(ch)

     return LOGGER

#### INIT PARAMS ################################################################################
def init_params(json_file_path, log):
     """Initializes parameter variables from given JSON file into a dictionnary"""
     log.info("Initializing parameters from file %s" % json_file_path)
     with open(json_file_path, "r") as f:
      param_dict = json.load(f)

     return param_dict

#### VALIDATE SOURCES PARAM ################################################################################
def validate_sources_param(param_dict, log):
     """Validates and initializes sources ids list"""
     log.info("Validating sources list parameter")
     
     source_id_lists = param_dict["sources-list"]

     # check it's not empty
     if len(source_id_lists) == 0:
        log.error("Sources list is empty into the json params file, at least 1 source needs to be available")
        sys.exit()

     return source_id_lists

#### VALIDATE FEATURES PARAM ################################################################################
def validate_features_param(param_dict, log):
     """Validates and initializes input features lists param"""
     log.info("Validating input-features list parameter")
     
     features_list = param_dict["input-features-list"]

     # check it's not empty
     if len(features_list) == 0:
        log.error("Features list is empty into the json params file, at least 1 features-set needs to be available")
        sys.exit()

     # check no empty features
     for features_set in features_list:
        if len(features_set) == 0:
            log.error("One of the features set is empty within the features input parameter")
            sys.exit()

     return features_list

#### EXECUTE WHIZZML ################################################################################
def execute_whizzml(whizzml_script_id, script_inputs, api, log):
     """Executes whizzml script and returns results """
     log.info("Executing WhizzML script %s" % whizzml_script_id)
     log.info("Script inputs: %s" % script_inputs)
     
     # execute WhizzML script to generate ensemble and evaluation
     execution = api.create_execution(whizzml_script_id, script_inputs)
     if not api.ok(execution,wait_time=60):
        log.error("WhizzML execution error %s" % execution["resource"])
        sys.exit("WhizzML execution could not be performed")

     log.info("WhizzML execution ended %s" % execution["resource"])

     # if error found, raise and exit
     if execution["object"]["status"]["code"] == -1:
        log.error("WhizzML execution error: %s. Execution id: %s" % (execution["object"]["status"]["message"],execution["object"]["resource"]))
        sys.exit("Error found while executing WhizzML script")
     
     return execution["object"]["execution"]["result"]


#### GATHER SOURCE FEATURESET STATS ################################################################################
def gather_source_featureSet_stats(scored_df, src, src_ct, fs_count, scored_dataset, fs, log):
     """ Calculates and persists stat results at the source+featureSet level """
     log.info("Gathering stats for current dataset and featureSet...")

     # GATHER current dataset results
     num_errors = scored_df[scored_df.Error == 1].score_output.shape[0]
     log.info("Number of errors in current dataset: %s" % str(num_errors))

     # errors scores, init to null as missing values should exist
     max_error_score, min_error_score, avg_error_score = np.nan, np.nan, np.nan
     if num_errors > 0:
         max_error_score = scored_df[scored_df.Error == 1].score_output.max(0)
     if num_errors > 1:
         min_error_score = scored_df[scored_df.Error == 1].score_output.min(0)
         avg_error_score = (max_error_score + min_error_score)/2

     log.info("Error scores processed")

     # max score ratio, init to null as missing values should exist
     max_score_ratio, min_score_ratio, avg_score_ratio = np.nan, np.nan, np.nan
     if num_errors > 0:
         max_score_ratio = round(1/scored_df[scored_df.score_output >= max_error_score].score_output.count(), 4)
     if num_errors > 1:
         min_score_ratio = round(num_errors/scored_df[scored_df.score_output >= min_error_score].score_output.count(), 4)
         avg_score_ratio = round((scored_df[(scored_df.score_output >= avg_error_score) & (scored_df.Error == 1)].score_output.count())/scored_df[scored_df.score_output >= avg_error_score].score_output.count(), 4)

     log.info("Error ratios calculated")
      
     # decompose features
     features_items_string = "|".join(fs["features"])

     # gather results into a dictionnary to create a dataframe
     current_data_dict = {'src_num': [src_ct], 'dataset_name': [src["name"]], 'source': [src["source"]], 'dataset': [scored_dataset],
                  'fs_num': [fs_count],'features_set': [fs["name"]], 'num_errors': [num_errors], 'max_error_score': [max_error_score],
                  'avg_error_score': [avg_error_score], 'min_error_score': [min_error_score], 'max_thres_precision': [max_score_ratio], 
                  'avg_thres_precision': [avg_score_ratio], 'min_thres_precision': [min_score_ratio], 'feature_items': [features_items_string]}
     
     # create dataframe with current feature set results
     cur_results_df = pd.DataFrame(current_data_dict, columns = ['src_num','dataset_name','source','dataset','fs_num','features_set','num_errors','max_error_score','avg_error_score','min_error_score','max_thres_precision','avg_thres_precision','min_thres_precision','feature_items'])

     return cur_results_df


#### GATHER SOURCE STATS ################################################################################
def gather_source_stats(src, all_scores_plot_df, config_dict, api, log):
     """ Calculates and persists stat results at the source level """
     log.info("Gathering stats for current dataset...")
     
     # GET BigML plot ds link
     # export all_scores_plot dataframe into a CSV
     timestr = time.strftime("%Y%m%d_%H%M%S")
     export_file_path = config_dict["all_scores_datasets_directory"] + "/" + timestr + "_all_scores_plot_"+ src["name"] + ".csv"
     all_scores_plot_df.to_csv(export_file_path, index = False, header=True)
     # create BigML source and dataset
     all_scores_bigml_source = api.create_source(export_file_path,{'name': 'anomaly_scores_plot_dataset_'+src["name"]})
     all_scores_bigml_dataset = api.create_dataset(all_scores_bigml_source)
     
     # gather results into a dictionnary to create a dataframe
     current_data_dict = {'dataset_name': [src["name"]], 'source': [src["source"]], 'scores_plot_dataset': [config_dict["bigml_dashboard_base_url"] + all_scores_bigml_dataset['resource']]}
     # create dataframe with current feature set results
     cur_results_df = pd.DataFrame(current_data_dict, columns = ['dataset_name','source','scores_plot_dataset'])

     return cur_results_df

 
#### GATHER FEATURE SET STATS ################################################################################
def gather_featureset_stats(fs, source_fs_results_df, log):
     """ Calculates and persists ALL stats results at the feature set level """
     log.info("Gathering feature set stats...")

     # group by feature set to provide stats
     fs_results_df = source_fs_results_df.groupby('features_set').agg({'max_error_score':'mean',
                                                                       'avg_error_score':'mean',
                                                                       'min_error_score':'mean',
                                                                       'max_thres_precision':'mean',
                                                                       'avg_thres_precision':'mean',
                                                                       'min_thres_precision':'mean',
                                                                       'avg_score_rank_pts':'mean',
                                                                       'max_t_precision_rank_pts':'mean',
                                                                       'avg_t_precision_rank_pts':'mean',
                                                                       'min_t_precision_rank_pts':'mean'}).reset_index()
     # add avg_ratio, overall_rank columns
     ratios_df = fs_results_df[['max_thres_precision','avg_thres_precision','min_thres_precision']]
     fs_results_df['avg_fs_precision'] = round(ratios_df.mean(axis=1),4)

     ratio_ranks_df = fs_results_df[['max_t_precision_rank_pts','avg_t_precision_rank_pts','min_t_precision_rank_pts']]
     fs_results_df['avg_fs_rank_pts'] = round(ratio_ranks_df.mean(axis=1),4)

     return fs_results_df



####################################################################################
####### MAIN
####################################################################################
def main(args=sys.argv[1:]):
     """Parses command-line parameters and calls the actual main function."""
     
     # Process arguments
     parser = argparse.ArgumentParser(
         description="Anomalies test utility",
         epilog="BigML, Inc")
     
     # config param
     parser.add_argument('--config',
         required=True,
         action='store',
         dest='config',
         default=None,
         help="Full path for the JSON parameter file")

     # json param
     parser.add_argument('--jsonparam',
         required=True,
         action='store',
         dest='jsonparam',
         default=None,
         help="Full path for the JSON parameter file")

     args = parser.parse_args(args)

     # get params
     json_config_file = args.config 
     json_param_file = args.jsonparam
     
     # initialize json configuration variables into a dictionnary
     config_dict = init_config(json_config_file)
     
     # initialize logger
     log = init_logger(config_dict["log_level"])
     log.info("Starting anomaly test util with config %s" % json_config_file)

     # init and validate params format and assign variables
     param_dict = init_params(json_param_file, log)
     source_ids = validate_sources_param(param_dict, log)
     feature_sets = validate_features_param(param_dict, log)

     # define and validate other configuration parameters
     whizzml_script_id = config_dict["anomaly_test_whizzml_id"]
     if whizzml_script_id == "":
        log.error("The predict WhizzML script is not defined in the configuration please deploy the WhizzML code before carrying on")
        sys.exit("WhizzML predict script not configured")

     # init api
     api = BigML(config_dict["bigml_username"],config_dict["bigml_apikey"],project=config_dict["bigml_project"],domain=config_dict["bigml_domain"])
     
     # initialize empty dataframe to append results for each source and featureSet
     source_fs_results_df = pd.DataFrame()
     # initialize empty dataframe to append results for each source
     source_results_df = pd.DataFrame()

     src_ct = 0
     # loop over sources
     for src in source_ids:
        log.info("Starting analysis for dataset (source): %s" % src["name"])
        src_ct = src_ct + 1

        # init all-scores-plot dataframe to group all scores
        all_scores_plot_df = pd.DataFrame()
        
        #loop over feature-sets
        fs_count = 0
        for fs in feature_sets:
            fs_count = fs_count + 1
            log.info("Starting analysis for feature set %s" % fs["name"])
            
            # call whizzml script to test anomaly detector for current source and feature-set
            script_inputs = {
               "inputs": [
                ["source-id", src["source"]],
                ["anomaly-input-fields", fs["features"]]
               ]
            }

            scored_dataset = execute_whizzml(whizzml_script_id, script_inputs, api, log)
            log.info("Execution successful, resulting scored dataset: %s" % scored_dataset)

            # export scored dataset into csv file
            scored_dataset_file_name = config_dict["tmp_datasets_directory"] + "/" + scored_dataset[8:] +"_src_" + str(src_ct) +  "_fs" + str(fs_count) + ".csv"
            api.download_dataset(scored_dataset,scored_dataset_file_name)
            log.info("Resulting scored dataset downloaded: %s" % scored_dataset_file_name)
            
            # load scored data into a dataframe
            scored_df = pd.read_csv(scored_dataset_file_name)

            # a parallel dataframe is kept to store the original data with all scores for plot reasons...
            # assign current scores to all scores dataframe (initiate dataframe if empty)
            if fs_count == 1:
                # init dataframe if empty, current scored dataframe is used
                all_scores_plot_df = scored_df.rename(columns={"score_output": "score_fs1"})
            else:
                # add new score column to existing dataframe
                all_scores_plot_df['score_fs_'+str(fs_count)] = scored_df['score_output']

            # GATHER current dataset results stats
            cur_results_df = gather_source_featureSet_stats(scored_df, src, src_ct, fs_count, scored_dataset, fs, log)

            # append current dataframe to the overall source-fs dataframe
            source_fs_results_df = source_fs_results_df.append(cur_results_df, ignore_index=True)
            log.info("Dataframe current results appended")

        # GATHER current stats at the source level
        #source_fs_results_df.loc[(source_fs_results_df['source'] == src),'bigml_scores_plot_dataset'] = config_dict["bigml_dashboard_base_url"] + all_scores_bigml_dataset['resource']
        cur_src_results_df = gather_source_stats(src, all_scores_plot_df, config_dict, api, log)
        # append current dataframe to the overall source-fs dataframe
        source_results_df = source_results_df.append(cur_src_results_df, ignore_index=True)
     
     # add Feeature Set rank points (inverted rank) to the source-fs dataframe
     print(source_fs_results_df.to_string())

     #source_fs_results_df["max_score_rank_pts"] = source_fs_results_df.groupby("features_set")["max_error_score"].rank("dense", ascending=True)
     source_fs_results_df["avg_score_rank_pts"] = source_fs_results_df.groupby("source")["avg_error_score"].rank("dense", ascending=True)
     #source_fs_results_df["min_score_rank_pts"] = source_fs_results_df.groupby("features_set")["min_error_score"].rank("dense", ascending=True)
     source_fs_results_df["max_t_precision_rank_pts"] = source_fs_results_df.groupby("source")["max_thres_precision"].rank("dense", ascending=True)
     source_fs_results_df["avg_t_precision_rank_pts"] = source_fs_results_df.groupby("source")["avg_thres_precision"].rank("dense", ascending=True)
     source_fs_results_df["min_t_precision_rank_pts"] = source_fs_results_df.groupby("source")["min_thres_precision"].rank("dense", ascending=True)

     # GATHER feature-set stats
     fs_results_df = gather_featureset_stats(fs, source_fs_results_df, log)

     # PREPARE RETURNS
     #print(source_fs_results_df.to_string())

     # export source-fs csv
     # TODO add linter anaconda python
     timestr = time.strftime("%Y%m%d_%H%M%S")
     export_file_name = f"{timestr}_src_fs_stats.csv"
     export_file_path = os.path.join(config_dict["resulting_csv_directory"],export_file_name)
     log.info("source-featureSet results ready, exporting csv file: %s" % export_file_path)
     source_fs_results_df.to_csv(export_file_path, index = False, header=True)
     
     # export src csv
     export_file_name = f"{timestr}_src_stats.csv"
     export_file_path = os.path.join(config_dict["resulting_csv_directory"],export_file_name)
     log.info("source results ready, exporting csv file: %s" % export_file_path)
     source_results_df.to_csv(export_file_path, index = False, header=True)
     #print(source_results_df.to_string())
     
     # export fs csv
     export_file_name = f"{timestr}_feature_set_stats.csv"
     export_file_path = os.path.join(config_dict["resulting_csv_directory"],export_file_name)
     log.info("feature set results ready, exporting csv file: %s" % export_file_path)
     fs_results_df.to_csv(export_file_path, index = False, header=True)
     
     #print(fs_results_df.to_string())


if __name__ == "__main__":
   main()