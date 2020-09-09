

drop table if exists imp_welds;
create table imp_welds(
      FaultCode numeric,
      WeldEnergyActual numeric,
      "MeasurementData.MeasurementParameter.StudID.value" varchar(50),
      DropTimeActual numeric,
      LMPenetrationActual numeric,
      StickoutActual numeric,
      LMLiftHeightActual numeric,
      WeldTimeActual numeric,
      uniqueID varchar(50),
      WeldCurrentActualPositive numeric,
      "timestamp" varchar(50),
      WeldVoltageActual numeric);

copy imp_welds(
      FaultCode,
      WeldEnergyActual,
      "MeasurementData.MeasurementParameter.StudID.value",
      DropTimeActual,
      LMPenetrationActual,
      StickoutActual,
      LMLiftHeightActual,
      WeldTimeActual,
      uniqueID,
      WeldCurrentActualPositive,
      "timestamp",
      WeldVoltageActual
)
FROM '/Users/guillem/Data/Customers/Daimler/anomalies-analysis/resulting_csvs/beckett/my_tools_all_welds.csv' DELIMITER ',' CSV HEADER;

create table welds_actuals as select
      uniqueID,
      "MeasurementData.MeasurementParameter.StudID.value" as extensionid,
      to_timestamp(replace(replace(timestamp,'T',' '),'.000000+0200',''),'YYYY-MM-DD HH24:MI:SS') as weld_timestamp,
      faultCode,
      WeldEnergyActual,
      DropTimeActual,
      LMPenetrationActual,
      StickoutActual,
      LMLiftHeightActual,
      WeldTimeActual,
      WeldCurrentActualPositive,
      WeldVoltageActual
from imp_welds;

create index inx_weldactuals_uniqueid on welds_actuals(uniqueid);
create index inx_weldactuals_extensionid on welds_actuals(extensionid);
create index inx_weldactuals_timestamp on welds_actuals(weld_timestamp);