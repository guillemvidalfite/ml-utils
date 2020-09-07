import logging
import ssl
import urllib3

from elasticsearch import Elasticsearch, JSONSerializer
from elasticsearch.connection import create_ssl_context
from elasticsearch.helpers import parallel_bulk
import numpy as np
import pandas as pd
from elasticsearch.helpers import scan

urllib3.disable_warnings() # This is insecure
logger = logging.getLogger(__name__)



def get_elastic_client(server="local", write=False):
    if server == "local":
        if write:
            serializer = NpJSONSerializer()
        else:
            serializer = JSONSerializer()
        return Elasticsearch(host="localhost",
                             port=9200,
                             serializer=serializer)
    elif server in {"dev", "horizon", "prod"}:
        if server == "prod":
            host = "daimler-elastic.vpc.bigml.com"
        elif server == "horizon":
            host = "daimler-elastic.horizon.bigml.com"
        else:
            host = "daimler-elastic.dev.bigml.com"

        if write:
            serializer = NpJSONSerializer()
        else:
            serializer = JSONSerializer()
        # Set up ssl context to disable cert verification
        ssl_context = create_ssl_context()
        ssl_context.check_hostname = False
        ssl_context.verify_mode = ssl.CERT_NONE
        return Elasticsearch(host=host, port=443, http_auth=("dev", "paroafCa"), serializer=serializer, ssl_context=ssl_context, use_ssl=True, timeout=120)
    else:
        logger.warning("unknown server '%s'", server)
        return None

ES = get_elastic_client("dev")


REQUEST_TIMEOUT = 200. 

all_welds_list_query = {
  "size" : 1000,
  "query" : {
    "terms" : {
      "uniqueID.keyword" : [
        "h902-070tsb201-kf130.m050g9sub63sps2.1.1",
        "h902-130tsb401-kf130.m050g9sub64sps4.1.1",
        "h902-170tsb101-kf130.m050g9sub64sps5.1.1",
        "h902-110tsb201-kf130.m050g9sub64sps3.2.1",
        "h902-060tsb401-kf130.m050g9sub64sps2.2.1",
        "h902-040tsb201-kf130.m050g9sub64sps1.1.1",
        "h902-110tsb101-kf130.m050g9sub64sps3.1.1",
        "h902-140tsb101-kf130.m050g9sub63sps3.1.1",
        "h902-140tsb301-kf130.m050g9sub63sps3.1.1",
        "h902-130tsb101-kf130.m050g9sub63sps3.1.1",
        "h902-090tsb101-kf130.m050g9sub63sps2.1.1",
        "h902-080tsb201-kf130.m050g9sub63sps2.1.1",
        "h902-080tsb101-kf130.m050g9sub63sps2.1.1"
      ],
      "boost" : 1.0
    }
  },
  "_source" : {
    "includes" : [
      "uniqueID",
      "MeasurementData.MeasurementParameter.StudID.value",
      "timestamp",
      "WeldVoltageActual",
      "WeldTimeActual",
      "WeldCurrentActualPositive",
      "LMPenetrationActual",
      "StickoutActual",
      "DropTimeActual",
      "LMLiftHeightActual",
      "WeldEnergyActual",
      "FaultCode"
    ],
    "excludes" : [ ]
  },
  "sort" : [
    {
      "_doc" : {
        "order" : "asc"
      }
    }
  ]
}

all_welds_df = pd.DataFrame()

num_batch = 1
welds = []

for current_weld in scan(ES, index="ml_toolbox_raw_data", 
                                  query=all_welds_list_query, 
                                  scroll='15m',
                                  raise_on_error=True,
                                  size=5000,
                                  request_timeout=REQUEST_TIMEOUT):

    if num_batch % 10000 == 0:
      print("Current batch %s" % num_batch)
    
    num_batch = num_batch + 1

    # gather current bucket key information
    welds.append(current_weld["_source"])


## build dataframe from welds list
print("Loop finished, building dataframe ")
print(len(welds))

all_welds_df = pd.DataFrame.from_records(welds)

# create csv
all_welds_df.to_csv('/home/bigml/guillem/anomaly-test-util/tmp/my_tools_all_welds.csv', index = False, header=True)

# tool = current_weld["_source"]["uniqueID"]
#  extension = current_weld["_source"]["MeasurementData.MeasurementParameter.StudID.value"]
#  timestamp = current_weld["_source"]["timestamp"]
  
#  # gather current bucket stats information
#  penetration = current_weld["_source"]["LMPenetrationActual"]
#  drop_time = current_weld["_source"]["DropTimeActual"] 
#  voltage = current_weld["_source"]["WeldVoltageActual"]
#  time = current_weld["_source"]["WeldTimeActual"]
#  lift = current_weld["_source"]["LMLiftHeightActual"]
#  current = current_weld["_source"]["WeldCurrentActualPositive"]
#  energy = current_weld["_source"]["WeldEnergyActual"]
#  stickout = current_weld["_source"]["StickoutActual"]
#  faultcode = current_weld["_source"]["FaultCode"]
#  # gather results into a dictionnary to create a dataframe
#  current_data_dict = {'tool': [tool], 'extension': [extension], 'timestamp': [timestamp], 
#                       'penetration': [penetration], 'drop_time': [drop_time],
#                       'voltage': [voltage], 'time': [time], 'lift': [lift], 'current': [current], 
#                       'energy': [energy], 'stickout': [stickout], 'faultcode': [faultcode]}
   
#  # create dataframe with current feature set results
#  cur_iteration_df = pd.DataFrame(current_data_dict, columns = ['tool', 'extension', 'timestamp', 
#                      'penetration', 'drop_time', 'voltage', 'time', 'lift', 'current', 
#                      'energy', 'stickout', 'faultcode'])
  
# all_welds_df = all_welds_df.append(cur_iteration_df, ignore_index=True)

