---- ASSEMBLY REPAIRS
drop table if exists assembly_repairs;
create table assembly_repairs(
     repairDate varchar(100),
     CarType varchar(100),
     ProductionNumber varchar(100),
     ProductionNumber_Ext varchar(100),
     Repaired_Yes_No varchar(100),
     StudID varchar(100),
     StudType varchar(100),
     Bad_Weld varchar(100),
     Stud_bended varchar(100),
     Stud_Missing varchar(100),
     Stud_shifted varchar(100),
     Plant_Station_in_Bodyshop varchar(100),
     Production_in_Bodyshop varchar(100)
);

copy assembly_repairs(
       repairDate,
       CarType,
       ProductionNumber,
       ProductionNumber_Ext,
       Repaired_Yes_No,
       StudID,
       StudType,
       Bad_Weld,
       Stud_bended,
       Stud_Missing,
       Stud_shifted,
       Plant_Station_in_Bodyshop,
       Production_in_Bodyshop
)FROM '/Users/guillem/Data/Customers/Daimler/repair_flags/Repaired_In_AssemblyShop_2020-09-09.csv' DELIMITER ',' CSV HEADER;

create index inx_assemblyrepair_prodnum on assembly_repairs(ProductionNumber);

---- ASSEMBLY MAPPING
drop table if exists assembly_mapping;
create table assembly_mapping(
     Production varchar(100),
     Carbody varchar(100)
);

copy assembly_mapping(
       Production,
       Carbody
)FROM '/Users/guillem/Data/Customers/Daimler/repair_flags/AssemblyShop_BodyShop_Mapping_2020-09-09.csv' DELIMITER ',' CSV HEADER;

---- update mapping carbodyid
alter table assembly_repairs add carbodyid varchar(100);
update assembly_repairs ar set carbodyid = (select am.Carbody from assembly_mapping am where am.Production = ar.ProductionNumber);
create index inx_assemblyrepair_carbody on assembly_repairs(carbodyid);
create index inx_assemblyrepair_studid on assembly_repairs(studid);

---- BODYSHOP REPAIRS
drop table if exists bodyshop_repairs;
create table bodyshop_repairs(
     CarType varchar(100),
     StudID varchar(100),
     CarbodyID varchar(100),
     Documentationtime varchar(100),
     StudType varchar(100),
     FailureinStation varchar(100),
     ErrorCode varchar(100),
     DetectedasWOP varchar(100)
);

copy bodyshop_repairs(
       CarType,
       StudID,
       CarbodyID,
       Documentationtime,
       StudType,
       FailureinStation,
       ErrorCode,
       DetectedasWOP
)FROM '/Users/guillem/Data/Customers/Daimler/repair_flags/Repaired_In_Bodyshop_Sep-Aug_2020-09-09.csv' DELIMITER ',' CSV HEADER;

create index inx_bodyshoprepair_carbodyid on bodyshop_repairs(CarbodyID);
create index inx_bodyshoprepair_studid on bodyshop_repairs(studid);

-- remove false positives
delete from bodyshop_repairs where ErrorCode = '1000';

-- flags updates




