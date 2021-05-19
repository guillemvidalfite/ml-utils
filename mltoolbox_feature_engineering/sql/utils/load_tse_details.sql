

drop table if exists tse_stats_215;
create table tse_stats_215(
   tool_id           varchar(100),
   TSE               varchar(100),
   total_welds       numeric,
   train_welds       numeric,
   test_welds        numeric,
   total_repairs     numeric,
   train_repairs     numeric,
   test_repairs      numeric,
   total_body        numeric,
   body_train        numeric,
   e2000_train        numeric,
   e3000_train        numeric,
   body_test         numeric,
   e2000_test         numeric,
   e3000_test         numeric,
   test_assembly     numeric,
   assembly_train    numeric,
   assembly_test     numeric
);

-- read csv file
copy tse_stats_215(
      tool_id,
      TSE,
      total_welds,
      train_welds,
      test_welds,
      total_repairs,
      train_repairs,
      test_repairs,
      total_body,
      body_train,
      e2000_train,
      e3000_train,
      body_test,
      e2000_test,
      e3000_test,
      test_assembly,
      assembly_train,
      assembly_test
)
FROM '/Users/guillem/Data/Customers/Daimler/anomalies-analysis/215_tests/TSE_stats_215.csv' DELIMITER ',' CSV HEADER;

create index inx_tse215_TSE on tse_stats_215(TSE);
create index inx_tse215_toolid on tse_stats_215(tool_id);


---------- TOOL WELDS
drop table if exists all_tool_welds;
create table all_tool_welds(
      uniqueid           varchar(100),
      studid             varchar(100),
      location           varchar(20),
      series             varchar(20),
      line_              varchar(20),
      plant              varchar(20),
      station            varchar(20),
      robot              varchar(20),
      controller         varchar(20),
      tool               varchar(20),
      toolType           varchar(20),
      studType           varchar(20),
      studSize           varchar(20),
      deviceGeneration   varchar(20),
      deviceType         varchar(20)
);

-- read csv file
copy all_tool_welds(
      studid,
      studType,
      controller,
      line_,
      toolType,
      tool,
      deviceGeneration,
      robot,
      deviceType,
      series,
      plant,
      studSize,
      station,
      location,
      uniqueid)
FROM '/Users/guillem/Data/Customers/Daimler/anomalies-analysis/215_tests/all_tool_welds.csv' DELIMITER ',' CSV HEADER;

create index inx_alltoolwelds_uniqueid on all_tool_welds(uniqueid);

drop table if exists tse_stats;
create table tse_stats as
   select location||'-'||series||'-'||line_||'-'||plant||'-'||station||'-'||robot||'-'||controller||'-'||tool||'-'||studid as tse, uniqueid, toolType, studSize, studType, deviceGeneration, deviceType
   from all_tool_welds
   group by 1,2,3,4,5,6,7;

create index inx_tsestats_tse on tse_stats(tse);

drop table if exists tse_stats_215_ext;
create table tse_stats_215_ext as
select
      a.tool_id,
      a.TSE,
      a.total_welds,
      a.train_welds,
      a.test_welds,
      a.total_repairs,
      a.train_repairs,
      a.test_repairs,
      a.total_body,
      a.body_train,
      a.e2000_train,
      a.e3000_train,
      a.body_test,
      a.e2000_test,
      a.e3000_test,
      a.test_assembly,
      a.assembly_train,
      a.assembly_test,
      b.toolType,
      b.studSize,
      b.studType,
      b.deviceGeneration,
      b.deviceType
from tse_stats_215 a left join tse_stats b on (a.tse = b.tse);

select tse from tse_stats limit 1;
select tse from tse_stats_215 limit 1;
select count(1) from tse_stats_215 a, tse_stats b where a.tse = b.tse;

drop table all_tool_welds;

