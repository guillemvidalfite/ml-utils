#!/usr/bin/env python
# coding: utf-8

from elastic import get_elastic_client, bulk_store


REQUEST_TIMEOUT = 100.  # Timeout for the elastic queries

# connect to dev
ES = get_elastic_client("dev")

# execute query to get referential welds data
ref_welds_query = {
  "size" : 1000,
  "query" : {
    "bool" : {
      "must" : [
        {
          "terms" : {
            "uniqueID.keyword" : [
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
              "h902-080tsb101-kf130.m050g9sub63sps2.1.1",
              "h902-070tsb201-kf130.m050g9sub63sps2.1.1"
            ],
            "boost" : 1.0
          }
        },
        {
          "term" : {
            "FaultCode.keyword" : {
              "value" : "0",
              "boost" : 1.0
            }
          }
        }
      ],
      "adjust_pure_negative" : true,
      "boost" : 1.0
    }
  },
  "_source" : false,
  "stored_fields" : "_none_",
  "aggregations" : {
    "groupby" : {
      "composite" : {
        "size" : 10,
        "sources" : [
          {
            "unique_id_b" : {
              "terms" : {
                "field" : "uniqueID.keyword",
                "missing_bucket" : true,
                "order" : "asc"
              }
            }
          },
          {
            "extension_b" : {
              "terms" : {
                "field" : "MeasurementData.MeasurementParameter.StudID.value.keyword",
                "missing_bucket" : true,
                "order" : "asc"
              }
            }
          },
          {
            "year_b" : {
              "date_histogram" : {
                "field" : "timestamp",
                "missing_bucket" : true,
                "value_type" : "date",
                "order" : "asc",
                "fixed_interval" : "31536000000ms",
                "time_zone" : "Z"
              }
            }
          },
          {
            "month_b" : {
              "terms" : {
                "script" : {
                  "source" : "InternalSqlScriptUtils.dateTimeChrono(InternalSqlScriptUtils.docValue(doc,params.v0), params.v1, params.v2)",
                  "lang" : "painless",
                  "params" : {
                    "v0" : "timestamp",
                    "v1" : "Z",
                    "v2" : "MONTH_OF_YEAR"
                  }
                },
                "missing_bucket" : true,
                "value_type" : "long",
                "order" : "asc"
              }
            }
          }
        ]
      },
      "aggregations" : {
        "voltage_b" : {
          "extended_stats" : {
            "field" : "WeldVoltageActual",
            "sigma" : 2
          }
        },
        "time_b" : {
          "extended_stats" : {
            "field" : "WeldTimeActual",
            "sigma" : 2
          }
        },
        "current_b" : {
          "extended_stats" : {
            "field" : "WeldCurrentActualPositive",
            "sigma" : 2
          }
        },
        "penetration_b" : {
          "extended_stats" : {
            "field" : "LMPenetrationActual",
            "sigma" : 2
          }
        },
        "stickout_b" : {
          "extended_stats" : {
            "field" : "StickoutActual",
            "sigma" : 2
          }
        },
        "drop_time_b" : {
          "extended_stats" : {
            "field" : "DropTimeActual",
            "sigma" : 2
          }
        },
        "lift_b" : {
          "extended_stats" : {
            "field" : "LMLiftHeightActual",
            "sigma" : 2
          }
        },
        "energy_b" : {
          "extended_stats" : {
            "field" : "WeldEnergyActual",
            "sigma" : 2
          }
        }
      }
    }
  }
}


elastic_response = ES.search(index=ml_toolbox_raw_data,
                           body=ref_welds_query,
                           request_timeout=REQUEST_TIMEOUT)