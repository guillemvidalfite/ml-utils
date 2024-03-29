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

#from shapsplain.forest import ShapForest

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

#### INIT PARAMS ################################################################################
def init_params(json_file_path, log):
     """Initializes parameter variables from given JSON file into a dictionnary"""
     log.info("Initializing parameters from file %s" % json_file_path)
     with open(json_file_path, "r") as f:
      param_dict = json.load(f)

     return param_dict

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

#### EXECUTE WHIZZML ################################################################################
def execute_whizzml(whizzml_script_id, script_inputs, api, log):
     """Executes whizzml script and returns results """
     log.info("Executing WhizzML script %s" % whizzml_script_id)
     log.debug("Script inputs: %s" % script_inputs)
     
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


#### CREATE SOURCE ################################################################################
def create_source(source_path, api, log, args=None):
    """Creates a source."""
    log.info("Creating source from file %s" % source_path)

    # check if file exists
    if not os.path.exists(source_path):
        log.error("Provided file does not exist %s" % source_path)
        sys.exit("Source file not found")

    if args is None:
        args = {}
    source = api.create_source(source_path, args)
    
    if not api.ok(source):
        log.error("Could not create source %s from file %s" % (source["resource"],source_path))
        sys.exit("Source couldn't be created or retrieved.")
    
    log.info("Source created successfuly %s" % source["resource"])

    return source

#### BUILD_IMPORTANCES_DATAFRAMES #################################################################
def build_importances_dataframes(repairs_importances_dataset, normal_importances_dataset, log):
    log.info("Starting to build importances dataframe...")

    # init empty arrays as temporary variables in further loop
    field_names=[]
    importances_means=[]
    importances_medians=[]
    importances_maxes=[]
    importances_mins=[]
    importances_mean_diffs=[]
    importances_median_diffs=[]
    
    
    # loop over fields, retrieve name and stats + build dictionnary for further dataframe
    for field_id in repairs_importances_dataset["object"]["fields"]:
        field_name = repairs_importances_dataset["object"]["fields"][field_id]["name"]
        # for importances fields only:
        if 'importance' in field_name:
            # if importance is greater than 0
            if repairs_importances_dataset["object"]["fields"][field_id]["summary"]["mean"] > 0:
                log.debug("Adding stats for %s ..." % field_name)

                field_names.append(field_name)
                # mean
                repair_imp_field_mean = repairs_importances_dataset["object"]["fields"][field_id]["summary"]["mean"]
                importances_means.append(repair_imp_field_mean)
                # median
                repair_imp_field_median = repairs_importances_dataset["object"]["fields"][field_id]["summary"]["median"]
                importances_medians.append(repair_imp_field_median)
                #max + min
                importances_maxes.append(repairs_importances_dataset["object"]["fields"][field_id]["summary"]["maximum"])
                importances_mins.append(repairs_importances_dataset["object"]["fields"][field_id]["summary"]["minimum"])
                # mean diff
                importances_mean_diffs.append(repair_imp_field_mean - normal_importances_dataset["object"]["fields"][field_id]["summary"]["mean"])
                # median diff
                importances_median_diffs.append(repair_imp_field_median - normal_importances_dataset["object"]["fields"][field_id]["summary"]["median"])
                
    
    log.info("Building dataframe...")

    data = {'field_names': [sub.replace(' importance','') for sub in field_names],  # removes importance string from current field name
            'imp_means': importances_means,
            'imp_medians': importances_medians,
            'imp_maxes': importances_maxes,
            'imp_mins': importances_mins,
            'imp_mean_diffs': importances_mean_diffs,
            'imp_median_diffs': importances_median_diffs}
    
    importances_df = pd.DataFrame(data, columns = ['field_names','imp_means','imp_medians','imp_maxes','imp_mins','imp_mean_diffs','imp_median_diffs'])
                
    return(importances_df)


#### GATHER ANOMALY SCORES RANKS ########################################################################################
def train_anomaly_gather_ranks(tse, repairs_source, train_ds_id, test_source, new_input_fields, params_dict, config_dict, log, api):

        # WHIZZML train anomaly detector and extract BAS
        log.info("Building WhizzML inputs")
        script_inputs = {
           "inputs": [
            ["source_repair_flags", repairs_source["resource"]],
            ["dataset_train", train_ds_id],
            ["source_test", test_source["resource"]],
            ["optimal_input_features", new_input_fields],
            ["original_input_features", params_dict["original-input-features"]]
           ]
        }
        bas_execution_result = execute_whizzml(config_dict["anomaly_detector_whizzml_id"], script_inputs, api, log)
     
        # get whizzml results
        test_BAS_optimal_ds_id = bas_execution_result["ds_test_optimal_BAS"]
        test_BAS_original_ds_id = bas_execution_result["ds_test_original_BAS"]
        train_BAS_optimal_ds_id = bas_execution_result["ds_train_BAS"]

        # get BAS datasets into dataframes
        export_file_path_opti = config_dict["tmp_datasets_directory"] + "/" + tse["name"] + "_optimal_BAS.csv"
        export_file_path_orig = config_dict["tmp_datasets_directory"] + "/" + tse["name"] + "_original_BAS.csv"
        export_file_path_train = config_dict["tmp_datasets_directory"] + "/" + tse["name"] + "_train_BAS.csv"
        api.download_dataset(test_BAS_optimal_ds_id,export_file_path_opti)
        log.info("BAS optimal dataset downloaded: %s" % export_file_path_opti)
        api.download_dataset(test_BAS_original_ds_id,export_file_path_orig)
        log.info("BAS original dataset downloaded: %s" % export_file_path_orig)
        api.download_dataset(train_BAS_optimal_ds_id,export_file_path_train)
        log.info("BAS train dataset downloaded: %s" % export_file_path_train)
        optimal_bas_df = pd.read_csv(export_file_path_opti)
        original_bas_df = pd.read_csv(export_file_path_orig)
        train_bas_df = pd.read_csv(export_file_path_train)

        # count welds over standard threshold in each case
        optimal_alerts_count = optimal_bas_df[optimal_bas_df.std_anomaly_score > config_dict["standard_alert_score_threshold"]].shape[0]
        original_alerts_count = original_bas_df[original_bas_df.std_anomaly_score > config_dict["standard_alert_score_threshold"]].shape[0]
        
        # calculate ranks
        log.info("Gathering ranks information")
        optimal_bas_df['score_rank'] = optimal_bas_df['std_anomaly_score'].rank(method='max',ascending=False)
        optimal_bas_df['score_pct_rank'] = optimal_bas_df['std_anomaly_score'].rank(pct=True,ascending=False)
        optimal_bas_df['orig_score'] = original_bas_df['std_anomaly_score']
        optimal_bas_df['orig_score_rank'] = original_bas_df['std_anomaly_score'].rank(method='max',ascending=False)
        optimal_bas_df['orig_score_pct_rank'] = original_bas_df['std_anomaly_score'].rank(pct=True,ascending=False)
        train_bas_df['score_rank'] = train_bas_df['std_anomaly_score'].rank(method='max',ascending=False)


        # init empty dataframe:
        cur_ds_rank_stats_df = pd.DataFrame()
        # gather current DS REPAIRS stats into global stats dataframe
        for index, row in optimal_bas_df[optimal_bas_df.repaired=='t'].iterrows():
            current_data_dict = {'dataset_name': [tse["name"]],
                                 'TSE': [row["tse"]], 
                                 'fingerprint': [row["fingerprint"]],
                                 'timestamp': [row["timestamp"]],
                                 'original_score': [row["orig_score"]],
                                 'optimal_score': [row["std_anomaly_score"]],
                                 'original_rank': [row["orig_score_rank"]],
                                 'optimal_rank': [row["score_rank"]],
                                 'original_pct_rank': [row["orig_score_pct_rank"]],
                                 'optimal_pct_rank': [row["score_pct_rank"]],
                                 'assembly_repair': [row["assembly_repair"]],
                                 'optimal_BAS': [test_BAS_optimal_ds_id],
                                 'original_BAS': [test_BAS_original_ds_id],
                                 }
        
            current_data_df = pd.DataFrame(current_data_dict, columns = ['dataset_name','TSE','fingerprint','timestamp','original_score','optimal_score','original_rank','optimal_rank','original_pct_rank','optimal_pct_rank','assembly_repair','optimal_BAS','original_BAS'])
            cur_ds_rank_stats_df = cur_ds_rank_stats_df.append(current_data_df, ignore_index=True)

        # get training repairs rank information
        repair_ranks ={'max_train_repair_rank': train_bas_df[train_bas_df.repaired=='t']['score_rank'].max(),
                       'min_train_repair_rank': train_bas_df[train_bas_df.repaired=='t']['score_rank'].min(),
                       'avg_train_repair_rank': train_bas_df[train_bas_df.repaired=='t']['score_rank'].mean()}
        
        # build result dictionnary
        result_dict = {'original_alerts_count': original_alerts_count, 'optimal_alerts_count': optimal_alerts_count, 'rank_stats_df': cur_ds_rank_stats_df, 'repair_ranks': repair_ranks}

        return result_dict

#### GATHER ANOMALY SCORES RANKS ########################################################################################
def gather_ds_stats(tse, current_data_df, original_alerts_count, optimal_alerts_count, repair_ranks, log):
        log.info("Gathering dataset stats")

        if current_data_df.shape[0] > 0:
            # REPAIRS FOUND IN TEST: gather ds rank stats
            cur_ds_stats_dict = {'dataset_name': tse["name"],
                                 'TSE': [current_data_df['TSE'].loc[0]],
                                 'median_rank_diff': [current_data_df['original_rank'].median() - current_data_df['optimal_rank'].median()],
                                 'avg_rank_diff': [current_data_df['original_rank'].mean() - current_data_df['optimal_rank'].mean()],
                                 'max_rank_diff': [current_data_df['original_rank'].max() - current_data_df['optimal_rank'].max()],
                                 'min_rank_diff': [current_data_df['original_rank'].min() - current_data_df['optimal_rank'].min()],
                                 'median_pct_rank_diff': [current_data_df['original_pct_rank'].median() - current_data_df['optimal_pct_rank'].median()],
                                 'avg_pct_rank_diff': [current_data_df['original_pct_rank'].mean() - current_data_df['optimal_pct_rank'].mean()],
                                 'max_pct_rank_diff': [current_data_df['original_pct_rank'].max() - current_data_df['optimal_pct_rank'].max()],
                                 'min_pct_rank_diff':  [current_data_df['original_pct_rank'].min()-current_data_df['optimal_pct_rank'].min()],
                                 'median_optimal_rank': [current_data_df['optimal_rank'].median()],
                                 'median_original_rank': [current_data_df['original_rank'].median()],
                                 'median_optimal_score': [current_data_df['optimal_score'].median()],
                                 'median_original_score': [current_data_df['original_score'].median()],
                                 'optimal_alerts_count': [optimal_alerts_count],
                                 'original_alerts_count': [original_alerts_count],
                                 'max_train_repair_rank': [repair_ranks['max_train_repair_rank']],
                                 'min_train_repair_rank': [repair_ranks['min_train_repair_rank']],
                                 'avg_train_repair_rank': [repair_ranks['avg_train_repair_rank']],
                                 'total_repaired': [current_data_df.shape[0]],
                                 'total_assembly': [current_data_df[current_data_df.assembly_repair == 't'].shape[0]],
                                 'optimal_BAS': [current_data_df['optimal_BAS'].loc[0]],
                                 'original_BAS': [current_data_df['original_BAS'].loc[0]]}
        else:
            # REPAIRS NOT FOUND: empty rank stats
            cur_ds_stats_dict = {'dataset_name': tse["name"],
                                 'TSE': None,
                                 'median_rank_diff': None,
                                 'avg_rank_diff': None,
                                 'max_rank_diff': None,
                                 'min_rank_diff': None,
                                 'median_pct_rank_diff': None,
                                 'avg_pct_rank_diff': None,
                                 'max_pct_rank_diff': None,
                                 'min_pct_rank_diff':  None,
                                 'median_optimal_rank': None,
                                 'median_original_rank': None,
                                 'median_optimal_score': None,
                                 'median_original_score': None,
                                 'optimal_alerts_count': [optimal_alerts_count],
                                 'original_alerts_count': [original_alerts_count],
                                 'max_train_repair_rank': [repair_ranks['max_train_repair_rank']],
                                 'min_train_repair_rank': [repair_ranks['min_train_repair_rank']],
                                 'avg_train_repair_rank': [repair_ranks['avg_train_repair_rank']],
                                 'total_repaired': 0,
                                 'total_assembly': 0,
                                 'optimal_BAS': None,
                                 'original_BAS': None}
        
        current_ds_stats_df = pd.DataFrame(cur_ds_stats_dict)

        return current_ds_stats_df


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
         help="Full path for the JSON config file")

     # config param
     parser.add_argument('--params',
         required=True,
         action='store',
         dest='params',
         default=None,
         help="Full path for the JSON params file")

     args = parser.parse_args(args)

     # get params
     json_config_file = args.config 
     json_params_file = args.params
     
     # initialize json configuration variables into a dictionnary
     config_dict = init_config(json_config_file)
     
     # initialize logger
     log = init_logger(config_dict["log_level"])
     log.info("Starting anomaly test util with config %s" % json_config_file)

     # initialize json parameters file into a dictionnary
     params_dict = init_params(json_params_file, log)

     # init api
     api = BigML(config_dict["bigml_username"],config_dict["bigml_apikey"],project=config_dict["bigml_project"],domain=config_dict["bigml_domain"])
     
     # create repairs flags source
     repairs_source = create_source(params_dict["repair_flags_file"], api, log)

     # init global dataframes
     all_importances_df = pd.DataFrame()
     rank_stats_df = pd.DataFrame()
     ds_rank_stats_df = pd.DataFrame()

     # init worse features list
     useless_features_list = params_dict["input-features"][:]

     # LOOP over TSEs
     for tse in params_dict["tse-files-list"]:
        log.info("Starting treatment for TSE %s " % tse["name"])

        # create training file source
        train_source = create_source(tse["train_file"], api, log)
        test_source = create_source(tse["test_file"], api, log)
    
        # WHIZZML train anomaly detector and extract importances
        log.info("Building WhizzML inputs")
        script_inputs = {
           "inputs": [
            ["source_repair_flags", repairs_source["resource"]],
            ["source_train", train_source["resource"]],
            ["all_input_features", params_dict["input-features"]]
           ]
        }
     
        importances_execution_result = execute_whizzml(config_dict["extract_importances_whizzml_id"], script_inputs, api, log)
     
        # get whizzml results
        repairs_importances_dataset_id = importances_execution_result["repairs-importances"]
        normal_importances_dataset_id = importances_execution_result["normal-importances"]
        train_ds_id = importances_execution_result["train-ds-id"]
     
        # get structured datasets in JSON format
        log.info("Loading repairs importances dataset...")
        repairs_importances_dataset = api.get_dataset(repairs_importances_dataset_id)
        log.info("Loading normal importances dataset...")
        normal_importances_dataset = api.get_dataset(normal_importances_dataset_id)
     
        # build importances dataframes
        importances_df = build_importances_dataframes(repairs_importances_dataset, normal_importances_dataset, log)

        # append within all importances df
        all_importances_df = all_importances_df.append(importances_df, ignore_index=True)

        # UPDATE USELESS FEATURES LIST by removing current dataset useful features
        # loop over current dataframe
        for index, row in importances_df.iterrows():
            # if both diff median and mean are positives the feature is isolating well repairs this time
            if row["imp_mean_diffs"] > config_dict["useless_importance_limit"] and row["imp_median_diffs"] > config_dict["useless_importance_limit"]:
                #check if current row parameter exists in the original list
                if row["field_names"] in useless_features_list:
                    log.debug("Useful field found: %s" % row["field_names"])
                    useless_features_list.remove(row["field_names"])

        # export importances into CSV file
        export_file_path = config_dict["tmp_datasets_directory"] + "/" + tse["name"] + "_field_importances_stats.csv"
        importances_df.to_csv(export_file_path, index = False, header=True)
        log.info("Importances TSE detail file exported: %s" % export_file_path)

        # Retrieve new input fields: by ordering top importance diff median
        new_input_fields = []
        # loop over first N optimal features and store feature names
        for index, row in importances_df.sort_values('imp_median_diffs', ascending=False).reset_index(drop=True).iterrows():
            if index == config_dict["optimal_field_num"]:
                break  # exit loop
            # check median importance difference is greater than the minumum configured value before keeping the feature
            if row["imp_median_diffs"] > config_dict["minimum_imp_median_diff"]:
                log.debug("Top feature found: %s ,importance diff median: %s" % (row["field_names"],row["imp_median_diffs"]) )
                new_input_fields.append(row["field_names"])
            else:
                log.debug("Stop searching for features, median diff values too low: %s" % row["imp_median_diffs"])
                break #exit loop

        # BASELINE FEATURES MODE
        if config_dict["baseline_features_mode"] == 1:
            log.info("Merging baseline features")
            # merge new features to baseline features and remove duplicates
            final_input_fields = list(dict.fromkeys(params_dict["baseline-input-features"] + new_input_fields))
        else:
            final_input_fields = new_input_fields


        if len(final_input_fields) >= config_dict["minimum_field_num"]:
            # Train anomaly detector, perform BAS and gather ranks stats
            log.info("%s input fields selected: %s" % (len(final_input_fields),final_input_fields))
            result_dict = train_anomaly_gather_ranks(tse, repairs_source, train_ds_id, test_source, final_input_fields, params_dict, config_dict, log, api)
            # obtain results from dictionnary:
            original_alerts_count = result_dict['original_alerts_count']
            optimal_alerts_count = result_dict['optimal_alerts_count']
            current_data_df = result_dict['rank_stats_df']
            repair_ranks = result_dict['repair_ranks']

            rank_stats_df = rank_stats_df.append(current_data_df, ignore_index=True)

            # gather ds rank stats
            current_ds_stats_df = gather_ds_stats(tse, current_data_df, original_alerts_count, optimal_alerts_count, repair_ranks, log)
            log.debug("Appending dataset stats ds_rank_stats_df shape")
            ds_rank_stats_df = ds_rank_stats_df.append(current_ds_stats_df, ignore_index=True)     
            
        else:
            log.warning("Not enough input fields found: %s" % final_input_fields)

        log.info("TSE treatment ended")
        log.info("##################################")
        log.info("##################################")
        log.info("##################################")
        log.info("##################################")



     # generate overall importances report information
     overall_importances_stats_df = all_importances_df.groupby('field_names').agg({'imp_means': 'mean',
                                                                                   'imp_medians': 'mean',
                                                                                   'imp_maxes': 'mean',
                                                                                   'imp_mins': 'mean',
                                                                                   'imp_mean_diffs': 'mean',
                                                                                   'imp_median_diffs': 'mean'}).reset_index()

     overall_importances_stats_df = overall_importances_stats_df.sort_values(by='imp_means')

     export_file_path = config_dict["tmp_datasets_directory"] + "/" + params_dict["test_name"] + "_overall_importances_stats.csv"
     overall_importances_stats_df.to_csv(export_file_path, index = False, header=True)
     log.info("Importances overall file exported: %s" % export_file_path)

     # gather overall stats
     log.info("##################################")
     log.info("##################################")
     log.info("OVERALL RANK STATISTICS (means):")
     log.info("##################################")
     log.info("##################################")
     log.info("Median Rank Difference: %s" % ds_rank_stats_df['median_rank_diff'].mean())
     log.info("Median Percentile Rank Difference: %s" % ds_rank_stats_df['median_pct_rank_diff'].mean())
     log.info("Average Rank Difference: %s" % ds_rank_stats_df['avg_rank_diff'].mean())
     log.info("Max Rank Difference: %s" % ds_rank_stats_df['max_rank_diff'].mean())
     log.info("Min Rank Difference: %s" % ds_rank_stats_df['min_rank_diff'].mean())
     log.info("Optimal Rank: %s" % ds_rank_stats_df['median_optimal_rank'].mean())
     log.info("Original Rank: %s" % ds_rank_stats_df['median_original_rank'].mean())
     log.info("Optimal Score: %s" % ds_rank_stats_df['median_optimal_score'].mean())
     log.info("Original Score: %s" % ds_rank_stats_df['median_original_score'].mean())
     log.info("Optimal Alerts Count: %s" % ds_rank_stats_df['optimal_alerts_count'].mean())
     log.info("Original Alerts Count: %s" % ds_rank_stats_df['original_alerts_count'].mean())
     log.info("Total Repairs: %s" % ds_rank_stats_df['total_repaired'].sum())
     log.info("Total Assembly Repairs: %s" % ds_rank_stats_df['total_assembly'].sum())
     

     # generate & log stats reports
     # DS level stats
     export_file_path = config_dict["tmp_datasets_directory"] + "/" + params_dict["test_name"] + "_ds_rank_stats.csv"
     ds_rank_stats_df.to_csv(export_file_path, index = False, header=True)
     log.info("Dataset level rank stats file exported: %s" % export_file_path)

     # Repair level stats
     export_file_path = config_dict["tmp_datasets_directory"] + "/" + params_dict["test_name"] + "_repair_rank_stats.csv"
     rank_stats_df.to_csv(export_file_path, index = False, header=True)
     log.info("Repairs level rank stats file exported: %s" % export_file_path)

     # log useless features
     for f_name in useless_features_list:
        log.info("Useless Feature Detected: %s" % f_name)

if __name__ == "__main__":
   main()