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

     # read all_input_fields param from config
     all_input_features=params_dict["input-features"]

     # define and validate other configuration parameters
     importances_whizzml_script_id = config_dict["extract_importances_whizzml_id"]
     if importances_whizzml_script_id == "":
        log.error("The WhizzML script is not defined in the configuration please deploy the WhizzML code before carrying on")
        sys.exit("WhizzML script not configured")

     # init api
     api = BigML(config_dict["bigml_username"],config_dict["bigml_apikey"],project=config_dict["bigml_project"],domain=config_dict["bigml_domain"])
     
     # create repairs flags source
     repairs_source = create_source(params_dict["repair_flags_file"], api, log)

     # init total importances dataframe
     all_importances_df = pd.DataFrame()

     # init worse features list
     useless_features_list = all_input_features

     # LOOP over TSEs
     for tse in params_dict["tse-files-list"]:
        #log.info("Starting treatment for TSE dataset %s , file: %s" % (tse["name"], tse["file"]))

        # create training file source
        train_source = create_source(tse["file"], api, log)
    
        # WHIZZML train anomaly detector and extract importances
        log.info("Building WhizzML inputs")
        script_inputs = {
           "inputs": [
            ["source_repair_flags", repairs_source["resource"]],
            ["source_train", train_source["resource"]],
            ["all_input_features", all_input_features]
           ]
        }
     
        importances_execution_result = execute_whizzml(importances_whizzml_script_id, script_inputs, api, log)
     
        # get whizzml results
        repairs_importances_dataset_id = importances_execution_result["repairs-importances"]
        normal_importances_dataset_id = importances_execution_result["normal-importances"]
     
        # get structured datasets in JSON format
        log.info("Loading repairs importances dataset...")
        repairs_importances_dataset = api.get_dataset(repairs_importances_dataset_id)

        log.info("Loading normal importances dataset...")
        normal_importances_dataset = api.get_dataset(normal_importances_dataset_id)
     
        # build importances dataframes
        importances_df = build_importances_dataframes(repairs_importances_dataset, normal_importances_dataset, log)

        # UPDATE USELESS FEATURES LIST by removing current dataset useful features
        # loop over current dataframe
        for index, row in importances_df.iterrows():
            # if both diff median and mean are positives the feature is isolating well repairs this time
            if row["imp_mean_diffs"] > 0.01 and row["imp_median_diffs"] > 0.01:
                #check if current row parameter exists in the original list
                if row["field_names"] in useless_features_list:
                    log.info("Useful field found: %s" % row["field_names"])
                    useless_features_list.remove(row["field_names"])

        # export into CSV file
        export_file_path = config_dict["tmp_datasets_directory"] + "/" + tse["name"] + "_field_importances_stats.csv"
        importances_df.to_csv(export_file_path, index = False, header=True)
        log.info("Importances TSE detail file exported: %s" % export_file_path)
        
        # append within all importances df
        all_importances_df = all_importances_df.append(importances_df)

     # generate overall importances stats information
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

     # log useless features
     for f_name in useless_features_list:
        log.info("Useless Feature Detected: %s" % f_name)

if __name__ == "__main__":
   main()