import logging
import argparse
import sys
import json
import os
import pandas as pd 
import time
import numpy as np

from datetime import datetime

from scipy.stats import ttest_ind
import psycopg2



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

#### DB CONNECT ################################################################################
def db_connect(host, port, user, password, database, log):
# Postgres connection to baseline database
     log.info("Connecting to Postgres database %s ..." % database)
     conn = psycopg2.connect(
         user= user,
         password= password,
         host= host,
         port= port,
         database= database
     )

     return conn

#### GET SCORES LIST ############################################################################
def get_scores_list(conn, log):
     log.info("Getting scores list...")

     cursor = conn.cursor()
     cursor.execute("""SELECT score, fingerprint FROM predictions ORDER BY fingerprint""")
     rows = cursor.fetchall()
     current_scores = []
     current_fingerprints = []

     log.debug("Fetching results...")
     for row in rows:
        current_scores.append(row[0])
        current_fingerprints.append(row[1])

     log.debug("Closing connection...")
     cursor.close()
     conn.close()

     return {"scores": current_scores, "fingerprints": current_fingerprints}

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
     log.info("Starting T Test Util with config %s" % json_config_file)

     # initialize json parameters file into a dictionnary
     params_dict = init_params(json_params_file, log)

     # Postgres connection to baseline database
     conn = db_connect(config_dict["postgres_host"], 
                       config_dict["postgres_port"], 
                       config_dict["postgres_user"], 
                       config_dict["postgres_password"], 
                       params_dict["baseline-database"], 
                       log)

     # Get scores list
     log.info("Getting baselines scores from db %s" % params_dict["baseline-database"])
     baseline_scores_dict = get_scores_list(conn, log)
     
     # results dataframe
     results_df = pd.DataFrame()

     # LOOP over parameter candidates to be tested
     for test in params_dict["t-tests-list"]:
        log.info("Processing T Test for %s feature set" % test["name"])

        # connect to current database
        conn = db_connect(config_dict["postgres_host"], 
                       config_dict["postgres_port"], 
                       config_dict["postgres_user"], 
                       config_dict["postgres_password"], 
                       test["db"], 
                       log)

        # get current scores
        current_scores_dict = get_scores_list(conn, log)

        # copy baseline scores into a new list (in case it needs to be manipulated)
        baseline_scores = baseline_scores_dict["scores"][:]

        # cardinality check and workaround when failed
        if len(baseline_scores) != len(current_scores_dict["scores"]):
            log.warning("Baseline scores list length: %s" % len(baseline_scores))
            log.warning("Current scores list length: %s" % len(current_scores_dict["scores"]))
            log.warning("Scores lists lengths found do not match, getting fingerprints...")

            # TODO to be tested deeply
            # find missing fingerprints:
##            missing_fingerprints = np.setdiff1d(baseline_scores_dict["fingerprints"],current_scores_dict["fingerprints"]).tolist()
##            # get indexes of scores to be removed:
##            missing_scores_indexes = []
##            # for all missing fingerprints append corresponding index
##            log.info("Building missing scores index")
##            for i in range(len(missing_fingerprints)):
##                log.info("Processing fingerprint: %s" % missing_fingerprints[i])
##                missing_scores_indexes.append(baseline_scores_dict["fingerprints"].index(missing_fingerprints[i]))
##            # sort missing scores indexes descending so we can start deleting elements from the back
##            missing_scores_indexes.sort(reverse=True)
##            # delete corresponding indexes scores starting from the end of the list
##            log.info("Deleting missing scores from list")
##            for i in missing_scores_indexes:
##                del baseline_scores[i]
##            # final cardinality check
##            if len(baseline_scores) != len(current_scores_dict["scores"]):
##                log.error("Baseline scores list length: %s" % len(baseline_scores))
##                log.error("Current scores list length: %s" % len(current_scores_dict["scores"]))
##                sys.exit("Scores lists lengths found do not match after data treatment, exiting...")
        else:
            # T Test calculation
            log.info("Calculating T Stats...")
            t_stat, p = ttest_ind(baseline_scores, current_scores_dict["scores"])
            log.info("Results: t_stat=%s, P_value=%s" % (t_stat,p))
    
            # Log results
            if p < config_dict["alpha"]:
                log.info("TEST SUCCESSFUL! Scores variation likely to be caused by features")
                test_result = 'SUCCESS'
            else:
                log.info("TEST FAILED! Scores variation likely to be caused by data variations")
                test_result = 'FAIL'
    
            # Report results
            current_results_dict = {'feature_set_name': [test["name"]],
                                    'p_value': [p],
                                    't_stat': [t_stat],
                                    'test_result': [test_result]}

            current_results_df = pd.DataFrame(current_results_dict)
            results_df = results_df.append(current_results_df, ignore_index=True)

     # Print report
     log.info("Final results: %s " % results_df)
     
     # export csv
     export_file_path = config_dict["resulting_reports_directory"] + "/" + params_dict["test_name"] + "_t_stats_report.csv"
     results_df.to_csv(export_file_path, index = False, header=True)
     log.info("T Test Stats report file exported: %s" % export_file_path)

if __name__ == "__main__":
   main()