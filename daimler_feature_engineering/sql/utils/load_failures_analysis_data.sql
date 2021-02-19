

drop table if exists tmp_test_data_tse3;

create table tmp_test_data_tse3(
      StudID                                          varchar(100),
      CarbodyID                                       varchar(100),
      uniqueID                                        varchar(100),
      fingerprint                                     varchar(100),
      FaultCode                                       varchar(10),
      WIP                                             varchar(10),
      WeldVoltageActual                               numeric,
      WeldEnergyActual                                numeric,
      LMLiftHeightActual                              numeric,
      LMPenetrationActual                             numeric,
      StickoutActual                                  numeric,
      LMPositionActual                                numeric,
      WeldToolSlideBackwardMoveTime                   numeric,
      WeldToolMoveTimeLoadingPinBackward              numeric,
      Current_DTW_Distance                            numeric,
      Voltage_DTW_Distance                            numeric,
      LiftPosition_DTW_Distance                       numeric,
      LMCurrent_DTW_Distance                          numeric,
      DropTimeActual                                  numeric,
      LiftFinishedMode                                numeric,
      PilotVoltageActual                              numeric,
      WeldCurrentActualPositive                       numeric,
      WeldTimeActual                                  numeric,
      tse                                             varchar(100),
      score                                           numeric,
      body_repair                                     varchar(1),
      assembly_repair                                 varchar(1),
      repaired                                        varchar(1),
      alert                                           varchar(1),
      classification                                  varchar(1),
      class_confidence                                numeric,
      error_type                                      varchar(10),
      std_anomaly_score                               numeric,
      WeldVoltageActual_importance                    numeric,
      WeldEnergyActual_importance                     numeric,
      LMLiftHeightActual_importance                   numeric,
      LMPenetrationActual_importance                  numeric,
      StickoutActual_importance                       numeric,
      LMPositionActual_importance                     numeric,
      WeldToolSlideBackwardMoveTime_importance        numeric,
      WeldToolMoveTimeLoadingPinBackward_importance   numeric,
      Current_DTW_Distance_importance                 numeric,
      Voltage_DTW_Distance_importance                 numeric,
      LiftPosition_DTW_Distance_importance            numeric,
      LMCurrent_DTW_Distance_importance               numeric);


copy tmp_test_data_tse3(
      StudID,
      CarbodyID,
      uniqueID,
      fingerprint,
      FaultCode,
      WIP,
      WeldVoltageActual,
      WeldEnergyActual,
      LMLiftHeightActual,
      LMPenetrationActual,
      StickoutActual,
      LMPositionActual,
      WeldToolSlideBackwardMoveTime,
      WeldToolMoveTimeLoadingPinBackward,
      Current_DTW_Distance,
      Voltage_DTW_Distance,
      LiftPosition_DTW_Distance,
      LMCurrent_DTW_Distance,
      DropTimeActual,
      LiftFinishedMode,
      PilotVoltageActual,
      WeldCurrentActualPositive,
      WeldTimeActual,
      tse,
      score,
      body_repair,
      assembly_repair,
      repaired,
      alert,
      classification,
      class_confidence,
      error_type,
      std_anomaly_score,
      WeldVoltageActual_importance,
      WeldEnergyActual_importance,
      LMLiftHeightActual_importance,
      LMPenetrationActual_importance,
      StickoutActual_importance,
      LMPositionActual_importance,
      WeldToolSlideBackwardMoveTime_importance,
      WeldToolMoveTimeLoadingPinBackward_importance,
      Current_DTW_Distance_importance,
      Voltage_DTW_Distance_importance,
      LiftPosition_DTW_Distance_importance,
      LMCurrent_DTW_Distance_importance
)
FROM '/Users/guillem/Data/Customers/Daimler/anomalies-analysis/failures_datasets_GL/TSE#3_test_flags_importance.csv' DELIMITER ',' CSV HEADER;

create index inx_tmptstts3_fingerprint on tmp_test_data_tse3(fingerprint);


drop table if exists tse3_ranked_test_data;
create table tse3_ranked_test_data as
select score, 
       std_anomaly_score, 
       repaired,
       body_repair,
       assembly_repair,
       fingerprint,
       FaultCode,
       WIP,
       alert,
       classification,
       class_confidence,
       error_type,
       WeldVoltageActual,
       WeldEnergyActual,
       LMLiftHeightActual,
       LMPenetrationActual,
       StickoutActual,
       LMPositionActual,
       WeldToolSlideBackwardMoveTime,
       WeldToolMoveTimeLoadingPinBackward,
       Current_DTW_Distance,
       Voltage_DTW_Distance,
       LiftPosition_DTW_Distance,
       LMCurrent_DTW_Distance,
       DropTimeActual,
       LiftFinishedMode,
       PilotVoltageActual,
       WeldCurrentActualPositive,
       WeldTimeActual,
       WeldVoltageActual_importance,
       WeldEnergyActual_importance,
       LMLiftHeightActual_importance,
       LMPenetrationActual_importance,
       StickoutActual_importance,
       LMPositionActual_importance,
       WeldToolSlideBackwardMoveTime_importance,
       WeldToolMoveTimeLoadingPinBackward_importance,
       Current_DTW_Distance_importance,
       Voltage_DTW_Distance_importance,
       LiftPosition_DTW_Distance_importance,
       LMCurrent_DTW_Distance_importance,
       rank() over (order by score desc) score_rank,
       rank() over (order by std_anomaly_score desc) std_score_rank
from tmp_test_data_tse3;

drop table if exists tse3_ranked_test_data_repairs;
create table tse3_ranked_test_data_repairs as select * from tse3_ranked_test_data where repaired = 't';


COPY 
(SELECT score, std_anomaly_score, score_rank, std_score_rank, body_repair, assembly_repair, alert, error_type, WIP
 FROM tse3_ranked_test_data where repaired = 't' order by score_rank) TO '/Users/guillem/Data/Customers/Daimler/anomalies-analysis/failures_datasets_GL/tse3_repairs_rank.csv' DELIMITER ',' CSV HEADER;






