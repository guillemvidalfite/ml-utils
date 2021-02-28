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

from shapsplain.forest import ShapForest

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

###  CREATE TRAIN DATASET #############################################################
def create_joined_dataset(input_file, repairs_dataset_id, log, api):
        # create training source
        source = create_source(input_file, api, log)
       
        # create training dataset
        api.ok(source)
        dataset = api.create_dataset(source)
         
        # join datasets
        api.ok(dataset)
    
        ds_flags = api.create_dataset(
                             [{
                         
                                 "id": dataset["resource"],
                                 "name": "A"
                              },
                              {
                                 "id": repairs_dataset,
                                 "name": "B"
                              }
                             ],
                             {
                                 "sql_query": "SELECT `A`.*, `B`.`tse`, `B`.`score`, `B`.`body_repair`, `B`.`assembly_repair`, `B`.`repaired`, `B`.`alert` FROM `A` LEFT JOIN `B` ON `A`.`fingerprint` = `B`.`fingerprint`"
                             }
                         )

        log.info("Dataset ready %s" % ds_flags['resource'])

        return ds_flags

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

     # init api
     api = BigML(config_dict["bigml_username"],config_dict["bigml_apikey"],project=config_dict["bigml_project"],domain=config_dict["bigml_domain"])
     
     # create repairs flags source and dataset
     repairs_source = create_source(params_dict["repair_flags_file"], api, log)
     repairs_dataset = api.create_dataset(repairs_source)
     log.info("Repairs dataset created %s" % repairs_dataset)


     # LOOP over TSEs
     for tse in params_dict["tse-files-list"]:
        log.debug("Starting treatment for TSE dataset %s , file: %s" % (tse["name"], tse["train_file"]))

        # get train and test joined datasets:
        log.info("Train dataset treatment...")
        train_ds = create_joined_dataset(tse["train_file"], repairs_dataset["resource"], log, api)
        log.info("Test dataset treatment...")
        test_ds = create_joined_dataset(tse["test_file"], repairs_dataset["resource"], log, api)
        
        # get all features anomaly detector
        api.ok(train_ds)
        anomaly_all_features = api.create_anomaly(train_ds, {"input_fields": all_input_features})
        api.ok(anomaly_all_features)
        log.info("All features anomaly detector ready %s" % anomaly_all_features["resource"])

        # download train dataset as dataframe
        train_export_file_path = config_dict["tmp_datasets_directory"] + "/" + tse["name"] + "_train_dataset.csv"
        api.download_dataset(train_ds,train_export_file_path)
        log.info("Train dataset downloaded %s" % train_export_file_path)
        train_df = pd.read_csv(train_export_file_path)

        # init shap forest
        json_anomaly = api.get_anomaly(anomaly_all_features)
        forest = ShapForest(json_anomaly)
        
        scores = []
        predictions = []
        # loop over train dataframe and make/store explained predictions
        for index, row in train_df.iterrows(): 

            # build current predictions dictionnary looping over features list
            input_values = {} 
            for i in all_input_features: 
                # build input_values dynamically
                log.debug("Adding %s information to input_values, value: %s" % (input_values[i],row[i]) )
                input_values[i] = row[i]

            # append explained prediction
            log.debug("Making prediction for row: %s" % row["fingerprint"])
            predictions.append(forest.predict(input_values, explanation=True))

        
        # add predictions into dataframe as new columns
        # first we'll need to loop over the list and decompose it into a score list and an importances structure





api.create_dataset(
                    [{
                        "id": "dataset/6037efc079b77d73620019ed",
                        "name": "A"
                     },
                     {
                        "id": "dataset/6037ef7e79b77d7379004783",
                        "name": "B"
                     }
                    ],
                    {
                        "sql_query": "SELECT `A`.*, `B`.`tse`, `B`.`score`, `B`.`body_repair`, `B`.`assembly_repair`, `B`.`repaired`, `B`.`alert` FROM `A` LEFT JOIN `B` ON `A`.`fingerprint` = `B`.`fingerprint`"
                    }
                )



     

if __name__ == "__main__":
   main()