

drop table if exists dups_golden_large;
create table dups_golden_large(
      TSE              varchar(100),
      CarbodyID        varchar(30),
      StudID           varchar(30),
      fingerprint      varchar(100),
      datestamp        varchar(50),
      WIP              varchar(5),
      score            numeric,
      body_repair      varchar(5),
      assembly_repair  varchar(5),
      repaired         varchar(5),
      threshold        numeric,
      alert            varchar(5),
      training         varchar(5),
      class            varchar(5)
);

copy dups_golden_large(
     TSE,
     CarbodyID,
     StudID,
     fingerprint,
     datestamp,
     WIP,
     score,
     body_repair,
     assembly_repair,
     repaired,
     threshold,
     alert,
     training,
     class)
FROM '/Users/guillem/Data/Customers/Daimler/repeated_welds/dups_golden_large.csv' DELIMITER ',' CSV HEADER;

drop table if exists shops_large;
create table shops_large(
	StudID             varchar(100),
    CarbodyID          varchar(100),
    ErrorCode          numeric,
    OOL                varchar(5),
    assembly_error     varchar(10),
    BodyShopRepair     varchar(5),
    AssemblyShopRepair varchar(5),
    error_type         varchar(20),
    repaired           varchar(5)
);

copy shops_large
(    StudID,
     CarbodyID,
     ErrorCode,
     OOL,
     assembly_error,
     BodyShopRepair,
     AssemblyShopRepair,
     error_type,
     repaired)
FROM '/Users/guillem/Data/Customers/Daimler/repeated_welds/shops_large.csv' DELIMITER ',' CSV HEADER;



drop table if exists dups_golden_large_extended;
create table dups_golden_large_extended as 
select
       a.fingerprint,
       a.TSE,
       a.CarbodyID,
       a.StudID,
       to_timestamp(a.datestamp,'YYYY-MM-DD HH24:MI:SS') as datestamp,
       rank() over (partition by a.CarbodyID, a.StudID order by a.datestamp asc) as rank,
       case when a.WIP = 'true' then 1 else 0 end as WIP,
       a.score,
       case when a.body_repair = 'True' then 1 else 0 end as body_repair,
       case when a.assembly_repair = 'True' then 1 else 0 end as assembly_repair,
       case when a.repaired = 'True' then 1 else 0 end as repaired,
       a.threshold,
       case when a.alert = 'True' then 1 else 0 end as alert,
       case when a.training = 'True' then 1 else 0 end as training,
       a.class,
       b.ErrorCode,
       b.OOL,
       b.assembly_error,
       case when b.BodyShopRepair = 'True' then 1 else 0 end as BodyShopRepair,
       case when b.AssemblyShopRepair = 'True' then 1 else 0 end as AssemblyShopRepair,
       b.error_type,
       case when b.repaired = 'True' then 1 else 0 end as repaired2
from dups_golden_large a, shops_large b
where a.StudID = b.StudID and
      a.CarbodyID = b.CarbodyID
order by a.CarbodyID, a.StudID, a.datestamp;


# merge duplicated fields
select fingerprint, repaired, repaired2 from dups_golden_large_extended where repaired != repaired2;
select repaired, count(1) from dups_golden_large_extended group by repaired;
update dups_golden_large_extended set repaired = repaired2 where repaired != repaired2;
alter table dups_golden_large_extended drop column repaired2;

select count(1) from dups_golden_large_extended where body_repair != BodyShopRepair;
select fingerprint, body_repair, BodyShopRepair from dups_golden_large_extended where body_repair != BodyShopRepair;
update dups_golden_large_extended set body_repair = BodyShopRepair where body_repair != BodyShopRepair;
alter table dups_golden_large_extended drop column BodyShopRepair;

select count(1) from dups_golden_large_extended where assembly_repair != AssemblyShopRepair;
alter table dups_golden_large_extended drop column AssemblyShopRepair;



# RANK 1 vs RANK 2
select rank, avg(score), max(score), min(score), sum(score) from dups_golden_large_extended group by rank;


select repaired from dups_golden_large_extended where rank=1;











       
       
       
       
       
       
       
       
       
       
       
       
       
       
       



