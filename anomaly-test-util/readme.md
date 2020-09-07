# Anomaly Classification test utility


## 1. Introduction

This utility has been built to simplify and automate anomaly detectors tests for classification purposes.
When datasets are extremely unbalanced anomaly detectors can be used as classifiers. In this case the biggest challenge is finding the right features to obtain wished results.
A good example could be in predictive maintenance. In this case the classification objective would be to predict whether or not a machine would fail in the recent future. This would allow fixing the problem before a machine needs to be stopped, potentially saving time and money. In general machines use function properly most of the time, which would make the dataset very unbalanced. If we had data measures every 10s interval, typically very few measures would correspond to a machine failure which is what we want to predict. In general under 1 in 1000 data instances would be related to a machine error. With such unbalanced datasets typical classification algorithms do not produce good results. Instead anomaly detectors could be used to find unusual instances corresponding to suspicious machine behaviors resulting in machine errors. That's how an anomaly detector can be used to face a classification problem.
Note the current version is prepared for binary classification, multiple classes are not supported.

Currently, anomaly detectors in BigML are not ready to provide binary classification evaluation functionality, however evaluation metrics can be extracted from a dataset with anomaly scores. In general this makes the evaluation and results comparison manual and complex. Such complexity combined with the fact it is not easy to find the right features makes testing a long and manual task.

To reduce testing efforts drastically by automating anomaly detection binary classification testing, the current anomaly detection test utility has been built.

## 2. Inputs

Inputs are provided via a JSON file.
The idea is providing a list of datasets and a list of feature sets as input to the script.
This way all provided datasets can be tested against all provided feature sets.

### 2.1. Datasets
Datasets are provided via a dictionnary list having elements with:
- **The dataset name**: For a better communication, datasets should be named with understandable names or numbers.
- **The source unique identifier**: Datasets need to be provided as BigML source urls. They should be uploaded to Big_ML so they can be tested with the tool.

### 2.2. Feature Sets
Feature sets are also provided as a dictionnary list containing two parts:
- *The feature set name:* For communication purposes, feature sets should be named with understandable names or numbers.
- *The features list:* As part of the dictionnary a feature list is included too.

### 2.3. Input JSON file example
Input parameters will be provided as a JSON file. Find an example below including 2 datasets and 2 feature sets.

`{
    "sources-list": [{"name": "ds25", "source": "source/5f27f8f2aca2055dbc005d8f"},
    	             {"name": "ds24", "source": "source/5f27f8f0aca2055dbc005d8c"}],
    "input-features-list": 
                            [ {"name": "18_f_baseline",
                               "features":["MeasurementData.MeasurementParameter.StudID.value",
                               "WeldCurrentActualPositive",
                               "WeldTimeActual",
                               "WeldVoltageActual",
                               "WeldEnergyActual",
                               "PilotVoltageActual",
                               "LMLiftHeightActual",
                               "LMPenetrationActual",
                               "DropTimeActual",
                               "StickoutActual",
                               "MeasurementData.MeasurementParameter.WeldProcess.value",
                               "MeasurementData.MeasurementParameter.PilotCurrentActual.value",
                               "MeasurementData.MeasurementParameter.PilotTimeActual.value",
                               "MeasurementData.MeasurementParameter.WeldCurrentActualNegative.value",
                               "MeasurementData.MeasurementParameter.LMPositionActual.value",
                               "MeasurementData.MeasurementParameter.LiftFinishedMode.value",
                               "MeasurementData.MeasurementParameter.ProtectiveGasPreFlowActive.value",
                               "MeasurementData.MeasurementParameter.ProtectiveGasFlowDuringWeldprocessActive.value",
                               "MeasurementData.MeasurementParameter.ProtectiveGasPostFlowActive.value",
                               "Error"]},
                              {"name": "18_f_reduced",
                               "features": ["MeasurementData.MeasurementParameter.StudID.value",
                               "WeldCurrentActualPositive",
                               "WeldTimeActual",
                               "WeldVoltageActual",
                               "WeldEnergyActual",
                               "PilotVoltageActual",
                               "LMLiftHeightActual",
                               "LMPenetrationActual",
                               "DropTimeActual",
                               "StickoutActual",
                               "Error"]}
                            ]
}`

## 3. Components

The utility is provided as a Python script developed on python 3.7.5. It also executes WhizzML scripts and has a configuration file.

### 3.1.  Python main script

Most of the code remains in the Python main script. 
It is structured in procedures and contains a main block for the overall logic.
It produces a log in the standard output and stops in case of error.

### 3.2. Configuration file

JSON file named config.json and located in the cfg directory. 
It Contains configuration variables and needs to be configured during the installation.

### 3.3. WhizzML script

A WhizzML script is provided to manage anomaly detectors creation in BigML. It contains a metedata file in json and a markdown readme together with the script code.


## 4. Outputs

The script will output 3 csv files into a pre-defined directory.

### 4.1. Datasets and Feature Sets results file

For each input dataset and result set combination stats will be gathered internally and returned into this csv file.
Each row represents a source and feature set combination including all corresponding stats.

**Location:** Configured directory in the config.json file `resulting_csv_directory` entry

**Name:** <date>_<time>_feature_set_stats.csv

**Fields:**
- **src_num:** Source number assigned by the program based on the execution order (identifying the current dataset)
- **dataset_name:** Dataset name input parameter (identifying the current dataset)
- **source:** Source BigML identifier string parameter (identifying the current dataset)
- **dataset:** Dataset BigML identifier for the dataset created internally in each execution
- **fs_num:** Feature set number assigned by the program based on the execution order (identifying the current feature set)
- **features_set:** Feature set name input parameter (identifying the current feature set)
- **num_errors:** Number actual errors in the current dataset
- **max_error_score:** Maximum anomaly score observed amongst errors
- **avg_error_score:** Average anomaly score calculated based on all errors anomaly scores
- **min_error_score:** Minimum anomaly score observed amongst errors 
- **max_error_ratio:** Maximum error threshold (>=) precision ratio (percent of true positives over the threshold)
- **avg_error_ratio:** Average error threshold (>=) precision ratio (percent of true positives over the threshold)
- **min_error_ratio:** Minimum error threshold (>=) precision ratio (percent of true positives over the threshold)
- **feature_items:** String of items including all features. Could be useful for association discovery
- **avg_score_rank_pts:** Rank points (inversed rank) of the average score based on all feature sets with the same dataset
- **max_ratio_rank_pts:** Rank points (inversed rank) for the max threshold precision ration based on all feature sets with the same dataset
- **avg_ratio_rank_pts:** Rank points (inversed rank) for the avg threshold precision ration based on all feature sets with the same dataset
- **min_ratio_rank_pts:** Rank points (inversed rank) for the min threshold precision ration based on all feature sets with the same dataset

### 4.2. Datasets results file

For each input dataset stats are also gathered and displayed in a resulting csv file.
Currently all feature sets scores for the whole dataset instances are grouped into a BigML dataset which is very useful to *plot*. The dataset url is the only stat presented at the moment in this csv file.
Each row represents a dataset.

**Location:** Configured directory in the config.json file `resulting_csv_directory` entry

**Name:** `<date>_<time>_src_stats.csv`

**Fields:**
- **dataset_name:** Dataset name input parameter (identifying the current dataset)
- **source:** Source BigML identifier string parameter (identifying the current dataset)
- **scores_plot_dataset:** Resulting plot dataset BigML URL

### 4.3. Feature Sets results file

For each input feature set stats are gathered as a matter of final results. The overall goal of each execution is comparing feature sets performances, therefore results by feature set are potentially the final result from each execution.
Each row represents a feature set.

**Location:** Configured directory in the config.json file **resulting_csv_directory** entry

**Name:** <date>_<time>_feature_set_stats.csv

**Fields:**
- **max_error_score:** Maximum error anomaly score obtained amongst all datasets
- **avg_error_score:** Average error anomaly score obtained amongst all datasets
- **min_error_score:** Minimum error anomaly score obtained amongst all datasets
- **max_error_ratio:** Maximum error threshold average precision ratio obtained amongst all datasets
- **avg_error_ratio:** Average error threshold average precision ratio obtained amongst all datasets
- **min_error_ratio:** Minimum error threshold average precision ratio obtained amongst all datasets
- **avg_score_rank_pts:** Average score rank points obtained amongst all dataset
- **max_ratio_rank_pts:** Rank points (inversed rank) for the max threshold precision ratio based on all feature sets in each dataset: average value
- **avg_ratio_rank_pts:** Rank points (inversed rank) for the average threshold precision ratio based on all feature sets in each dataset: average value
- **min_ratio_rank_pts:** Rank points (inversed rank) for the min threshold precision ratio based on all feature sets in each dataset: average value
- **avg_fs_ratio:** Overall average precision ratio combining all 3 threshold precision ratios above
- **avg_fs_rank_pts:** Overall rank points average combining ratio rank points above


## 5. Installation

Requirements:
- Python 3.7.x
- BigML api python bindings
- BigMLer
- Pandas
- Access to a BigML cloud


### 5.1. BigML authentication

Obtain desired BigML user and project authentication information from the BigML interface by clicking on the key hole icon on top.

### 5.2. WhizzML script installation

- After making sure bigmler is installed (https://bigmler.readthedocs.io/en/latest) open a terminal session and run the bigml authentication configuration variables exports.
- Set the current directory to the whizzml directory of the installed package
- Execute the following command:  `bigmler whizzml --package-dir . --output-dir ~/tmp --org-project <your-project-id-here>`
- Validation: Inspect the BigML interface to see if your script appears as expected
- Validation: Execute the script manually from the interface to make sure executions work well

### 5.3. Python script installation

To install the Python script we only need to configure the configuration variables within the cfg/config.json file

- **bigml_apikey:** Your api authentication secret key
- **bigml_domain:** The domain of the BigML cloud you wish to connect examlple: "mycloud.dev.bigml.com/io",
- **bigml_project:** The BigML project id
- **bigml_username:** The BigML username
- **log_level:** The logging level wished, INFO or ERROR
- **anomaly_test_whizzml_id:** The WhizzML script id for the script created in the previous step
- **tmp_datasets_directory:** The directory where we wish to store the temporary csv files
- **all_scores_datasets_directory:** The directory where we wish to store the plot datasets csv files
- **resulting_csv_directory:** The directory where we wish to store the resulting output files from each execution
- **bigml_dashboard_base_url:** Our BigML dashboard base url


## 6. Execution

Executing is as simple as calling the unique python file with the corresponding parameters. 
Note that depending on parameters, executions could last for hours. Remember with N datasets and M feature sets N*M anomaly detectors are trained.

**Parameters:**
- **Configuration file (option --config):** Complete or relative path to the configuration file.
- **Parameters file (option --params):** Complete or relative patg to the parameters file.

**Example:**
`python anomaly-test-util.py --config ../cfg/config.json --jsonparam ../cfg/params.json`
