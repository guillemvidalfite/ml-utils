---------------------------------------------------
---------------------------------------------------
-- ADD REPAIR FLAGS 
---------------------------------------------------
---------------------------------------------------
alter table welds_70_datasets add column bodyshop_repair integer;
alter table welds_70_datasets add column assembly_repair integer;
alter table welds_70_datasets add column error integer;

--update welds_70_datasets set bodyshop_repair = null;
--update welds_70_datasets set assembly_repair = null;
--update welds_70_datasets set error = null;

update welds_70_datasets a set bodyshop_repair = 1 where exists (select 1 from bodyshop_repairs b where b.carbodyid = substring(a."CarbodyID",1,7) and substring(b.studid,1,6) = a."StudID");
update welds_70_datasets a set bodyshop_repair = 0 where bodyshop_repair is null;

/*select count(1) 
from welds_70_datasets a, bodyshop_repairs b
where b.carbodyid = substring(a."CarbodyID",1,7) and
      substring(b.studid,1,6) = a."StudID";

select length(carbodyid), count(1) from bodyshop_repairs group by length(carbodyid);
select length(carbodyid), count(1) from assembly_repairs group by length(carbodyid);
select length("CarbodyID"), count(1) from welds_70_datasets group by length("CarbodyID");


select count(1) 
from welds_70_datasets a, assembly_repairs b
where b.carbodyid = substring(a."CarbodyID",1,7) and
      b.studid = a."StudID";


select length(studid), count(1) from bodyshop_repairs group by length(studid);
select length(carbodyid), count(1) from assembly_repairs group by length(carbodyid);
select length("CarbodyID"), count(1) from welds_70_datasets group by length("CarbodyID");
*/

update welds_70_datasets a set assembly_repair = 1 where exists (select 1 from assembly_repairs b where b.carbodyid = substring(a."CarbodyID",1,7) and b.studid = a."StudID");
update welds_70_datasets a set assembly_repair = 0 where assembly_repair is null;


update welds_70_datasets a set error = 1 where assembly_repair = 1 or bodyshop_repair = 1;
update welds_70_datasets a set error = 0 where error is null;

-- TEST
/*drop table if exists repair_flags;
create table repair_flags(
     fingerprint varchar(100),
     bodyshop_repair varchar(1),
     assemblyshop_repair varchar(1),
     repaired varchar(1)
);

copy repair_flags(
        fingerprint,
        bodyshop_repair,
        assemblyshop_repair,
        repaired
)FROM '/Users/guillem/Data/Customers/Daimler/70_datasets_alvaro_v2/repair_flags.csv' DELIMITER ',' CSV HEADER;

create index inx_repairflags_fingerpring on repair_flags(fingerprint);


--alter table welds_70_datasets add column error2 integer;
--update welds_70_datasets a set error2 = (select case b.repaired when 'f' then 0 when 't' then 1 end from repair_flags b where b.fingerprint = a.fingerprint);
--select error2, error, count(1) from welds_70_datasets group by error2, error order by 1,2;
alter table welds_70_datasets drop column error2;*/


---------------------------------------------------
---------------------------------------------------
------- WELDS NEW FIELDS
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
drop table if exists welds_70_current_stats;
create table welds_70_current_stats(
      fingerprint varchar(100),
      extensionid varchar(100),
      uniqueid varchar(100),
      penetration_avg_distance numeric,
      penetration_up_limit_distance numeric,
      penetration_low_limit_distance numeric,
      penetration_offsigma_distance numeric,
      energy_avg_distance numeric,
      energy_up_limit_distance numeric,
      energy_low_limit_distance numeric,
      energy_offsigma_distance numeric,
      drop_time_avg_distance numeric,
      drop_time_up_limit_distance numeric,
      drop_time_low_limit_distance numeric,
      drop_time_offsigma_distance numeric,
      stickout_avg_distance numeric,
      stickout_up_limit_distance numeric,
      stickout_low_limit_distance numeric,
      stickout_offsigma_distance numeric,
      lift_avg_distance numeric,
      lift_up_limit_distance numeric,
      lift_low_limit_distance numeric,
      lift_offsigma_distance numeric,
      time_avg_distance numeric,
      time_up_limit_distance numeric,
      time_low_limit_distance numeric,
      time_offsigma_distance numeric,
      current_avg_distance numeric,
      current_up_limit_distance numeric,
      current_low_limit_distance numeric,
      current_offsigma_distance numeric,
      voltage_avg_distance numeric,
      voltage_up_limit_distance numeric,
      voltage_low_limit_distance numeric,
      voltage_offsigma_distance numeric
);

-- initial insert
insert into welds_70_current_stats (fingerprint, extensionid, uniqueid)
select a.fingerprint, a.extensionid, a."uniqueID"
from welds_70_datasets a;

-- penetration avg distance update
update welds_70_current_stats a set penetration_avg_distance = 
	(select round((c."LMPenetrationActual" - b.penetration_avg)/abs(b.penetration_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period));

-- penetration up limit distance
update welds_70_current_stats a set penetration_up_limit_distance = 
	(select round((c."LMPenetrationActual" - b.penetration_up_2sig)/abs(b.penetration_up_2sig - b.penetration_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."LMPenetrationActual" > b.penetration_up_2sig and
	       b.penetration_up_2sig > b.penetration_avg);

-- penetration low limit distance
update welds_70_current_stats a set penetration_low_limit_distance = 
	(select round((b.penetration_low_2sig - c."LMPenetrationActual")/abs(b.penetration_avg - b.penetration_low_2sig),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."LMPenetrationActual" < b.penetration_low_2sig and
	       b.penetration_low_2sig < b.penetration_avg);

-- energy avg distance update
update welds_70_current_stats a set energy_avg_distance = 
	(select round((c."WeldEnergyActual" - b.enery_avg)/abs(b.enery_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period));

-- energy up limit distance
update welds_70_current_stats a set energy_up_limit_distance = 
	(select round((c."WeldEnergyActual" - b.energy_up_2sig)/abs(b.energy_up_2sig - b.enery_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."WeldEnergyActual" > b.energy_up_2sig and
	       b.energy_up_2sig > b.enery_avg);

-- energy low limit distance
update welds_70_current_stats a set energy_low_limit_distance = 
	(select round((b.energy_low_2sig - c."WeldEnergyActual")/abs(b.enery_avg - b.energy_low_2sig),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."WeldEnergyActual" < b.energy_low_2sig and
	       b.energy_low_2sig < b.enery_avg);


-- drop_time avg distance update
update welds_70_current_stats a set drop_time_avg_distance = 
	(select round((c."DropTimeActual" - b.drop_time_avg)/abs(b.drop_time_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period));

-- drop_time up limit distance
update welds_70_current_stats a set drop_time_up_limit_distance = 
	(select round((c."DropTimeActual" - b.drop_time_up_2sig)/abs(b.drop_time_up_2sig - b.drop_time_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."DropTimeActual" > b.drop_time_up_2sig and
	       b.drop_time_up_2sig > b.drop_time_avg);

-- drop_time low limit distance
update welds_70_current_stats a set drop_time_low_limit_distance = 
	(select round((b.drop_time_low_2sig - c."DropTimeActual")/abs(b.drop_time_avg - b.drop_time_low_2sig),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."DropTimeActual" < b.drop_time_low_2sig and
	       b.drop_time_low_2sig < b.drop_time_avg);

-- stickout avg distance update
update welds_70_current_stats a set stickout_avg_distance = 
	(select round((c."StickoutActual" - b.stickout_avg)/abs(b.stickout_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period));

-- stickout up limit distance
update welds_70_current_stats a set stickout_up_limit_distance = 
	(select round((c."StickoutActual" - b.stickout_up_2sig)/abs(b.stickout_up_2sig - b.stickout_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."StickoutActual" > b.stickout_up_2sig and
	       b.stickout_up_2sig > b.stickout_avg);

-- stickout low limit distance
update welds_70_current_stats a set stickout_low_limit_distance = 
	(select round((b.stickout_low_2sig - c."StickoutActual")/abs(b.stickout_avg - b.stickout_low_2sig),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."StickoutActual" < b.stickout_low_2sig and
	       b.stickout_low_2sig < b.stickout_avg);

-- lift avg distance update
update welds_70_current_stats a set lift_avg_distance = 
	(select round((c."LMLiftHeightActual" - b.lift_avg)/abs(b.lift_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period));

-- lift up limit distance
update welds_70_current_stats a set lift_up_limit_distance = 
	(select round((c."LMLiftHeightActual" - b.lift_up_2sig)/abs(b.lift_up_2sig - b.lift_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."LMLiftHeightActual" > b.lift_up_2sig and
	       b.lift_up_2sig > b.lift_avg);

-- lift low limit distance
update welds_70_current_stats a set lift_low_limit_distance = 
	(select round((b.lift_low_2sig - c."LMLiftHeightActual")/abs(b.lift_avg - b.lift_low_2sig),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."LMLiftHeightActual" < b.lift_low_2sig and
	       b.lift_low_2sig < b.lift_avg);

-- time avg distance update
update welds_70_current_stats a set time_avg_distance = 
	(select round((c."WeldTimeActual" - b.time_avg)/abs(b.time_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period));

-- time up limit distance
update welds_70_current_stats a set time_up_limit_distance = 
	(select round((c."WeldTimeActual" - b.time_up_2sig)/abs(b.time_up_2sig - b.time_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."WeldTimeActual" > b.time_up_2sig and
	       b.time_up_2sig > b.time_avg);

-- time low limit distance
update welds_70_current_stats a set time_low_limit_distance = 
	(select round((b.time_low_2sig - c."WeldTimeActual")/abs(b.time_avg - b.time_low_2sig),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."WeldTimeActual" < b.time_low_2sig and
	       b.time_low_2sig < b.time_avg);

-- current avg distance update
update welds_70_current_stats a set current_avg_distance = 
	(select round((c."WeldCurrentActualPositive" - b.current_avg)/abs(b.current_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period));

-- current up limit distance
update welds_70_current_stats a set current_up_limit_distance = 
	(select round((c."WeldCurrentActualPositive" - b.current_up_2sig)/abs(b.current_up_2sig - b.current_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."WeldCurrentActualPositive" > b.current_up_2sig and
	       b.current_up_2sig > b.current_avg);

-- current low limit distance
update welds_70_current_stats a set current_low_limit_distance = 
	(select round((b.current_low_2sig - c."WeldCurrentActualPositive")/abs(b.current_avg - b.current_low_2sig),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."WeldCurrentActualPositive" < b.current_low_2sig and
	       b.current_low_2sig < b.current_avg);

-- voltage avg distance update
update welds_70_current_stats a set voltage_avg_distance = 
	(select round((c."WeldVoltageActual" - b.voltage_avg)/abs(b.voltage_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period));

-- voltage up limit distance
update welds_70_current_stats a set voltage_up_limit_distance = 
	(select round((c."WeldVoltageActual" - b.voltage_up_2sig)/abs(b.voltage_up_2sig - b.voltage_avg),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."WeldVoltageActual" > b.voltage_up_2sig and
	       b.voltage_up_2sig > b.voltage_avg);

-- voltage low limit distance
update welds_70_current_stats a set voltage_low_limit_distance = 
	(select round((b.voltage_low_2sig - c."WeldVoltageActual")/abs(b.voltage_avg - b.voltage_low_2sig),6)
	 from weld_averages b, welds_70_datasets c
	 where a.fingerprint = c.fingerprint and
	       b.key_tool = c."uniqueID" and 
	       b.key_extension = c.extensionid and 
	       extract(YEAR from c.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from c.weld_timestamp) = extract(MONTH from b.key_period) and
	       c."WeldVoltageActual" < b.voltage_low_2sig and
	       b.voltage_low_2sig < b.voltage_avg);

-- update offsigma distances:
update welds_70_current_stats set penetration_offsigma_distance = coalesce(penetration_up_limit_distance,-penetration_low_limit_distance,0);
update welds_70_current_stats set energy_offsigma_distance = coalesce(energy_up_limit_distance,-energy_low_limit_distance,0);
update welds_70_current_stats set drop_time_offsigma_distance = coalesce(drop_time_up_limit_distance,-drop_time_low_limit_distance,0);
update welds_70_current_stats set stickout_offsigma_distance = coalesce(stickout_up_limit_distance,-stickout_low_limit_distance,0);
update welds_70_current_stats set lift_offsigma_distance = coalesce(lift_up_limit_distance,-lift_low_limit_distance,0);
update welds_70_current_stats set time_offsigma_distance = coalesce(time_up_limit_distance,-time_low_limit_distance,0);
update welds_70_current_stats set current_offsigma_distance = coalesce(current_up_limit_distance,-current_low_limit_distance,0);
update welds_70_current_stats set voltage_offsigma_distance = coalesce(voltage_up_limit_distance,-voltage_low_limit_distance,0);

