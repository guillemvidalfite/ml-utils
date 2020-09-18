


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
------- DATASETS_INFO
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
drop table if exists datasets_info;
create table datasets_info(
     dataset_alias varchar(10),
     extensionid varchar(50),
     studid varchar(10),
     uniqueid varchar(50),
     filename varchar(100)
);

insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds1','620168_213_1_2_1_1_1_2','620168','h902-130tsb401-kf130.m050g9sub64sps4.1.1','050-213-Z1-UB64-130-400-401-1.1-620168_213_1_2_1_1_1_2.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds2','610836_213_1_2_1_2_1_1','610836','h902-170tsb101-kf130.m050g9sub64sps5.1.1','050-213-Z1-UB64-170-100-101-1.1-610836_213_1_2_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds3','620168_213_1_2_1_2_1_2','620168','h902-130tsb401-kf130.m050g9sub64sps4.1.1','050-213-Z1-UB64-130-400-401-1.1-620168_213_1_2_1_2_1_2.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds4','620625_213_1_1_1_1_1_1','620625','h902-110tsb201-kf130.m050g9sub64sps3.2.1','050-213-Z1-UB64-110-200-201-2.1-620625_213_1_1_1_1_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds5','610762_213_3_1_1_2_1_2','610762','h902-060tsb401-kf130.m050g9sub64sps2.2.1','050-213-Z1-UB64-060-400-401-2.1-610762_213_3_1_1_2_1_2.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds6','610445_213_3_2_1_2_1_1','610445','h902-040tsb201-kf130.m050g9sub64sps1.1.1','050-213-Z1-UB64-040-200-201-1.1-610445_213_3_2_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds7','610662_213_1_1_1_1_1_1','610662','h902-120tsb101-kf130.m050g9sub64sps3.1.1','050-213-Z1-UB64-120-100-101-1.1-610662_213_1_1_1_1_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds8','610456_213_3_1_1_1_1_1','610456','h902-110tsb101-kf130.m050g9sub64sps3.1.1','050-213-Z1-UB64-110-100-101-1.1-610456_213_3_1_1_1_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds9','620671_213_1_2_1_2_1_1','620671','h902-140tsb101-kf130.m050g9sub63sps3.1.1','050-213-Z1-UB63-140-100-101-1.1-620671_213_1_2_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds10','620671_213_1_2_1_1_1_1','620671','h902-140tsb101-kf130.m050g9sub63sps3.1.1','050-213-Z1-UB63-140-100-101-1.1-620671_213_1_2_1_1_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds11','620420_213_3_1_1_2_1_1','620420','h902-140tsb301-kf130.m050g9sub63sps3.1.1','050-213-Z1-UB63-140-300-301-1.1-620420_213_3_1_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds12','620558_213_1_2_1_2_1_1','620558','h902-130tsb101-kf130.m050g9sub63sps3.1.1','050-213-Z1-UB63-130-100-101-1.1-620558_213_1_2_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds13','620556_213_3_1_1_2_1_1','620556','h902-130tsb101-kf130.m050g9sub63sps3.1.1','050-213-Z1-UB63-130-100-101-1.1-620556_213_3_1_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds14','620548_213_1_2_1_2_1_1','620548','h902-130tsb101-kf130.m050g9sub63sps3.1.1','050-213-Z1-UB63-130-100-101-1.1-620548_213_1_2_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds15','610653_213_1_2_1_2_1_2','610653','h902-090tsb101-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-090-100-101-1.1-610653_213_1_2_1_2_1_2.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds16','620546_213_1_1_1_2_1_1','620546','h902-130tsb101-kf130.m050g9sub63sps3.1.1','050-213-Z1-UB63-130-100-101-1.1-620546_213_1_1_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds17','620556_213_1_1_1_2_1_1','620556','h902-130tsb101-kf130.m050g9sub63sps3.1.1','050-213-Z1-UB63-130-100-101-1.1-620556_213_1_1_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds18','610649_213_1_1_1_1_1_2','610649','h902-090tsb101-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-090-100-101-1.1-610649_213_1_1_1_1_1_2.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds19','610582_213_1_1_1_2_1_2','610582','h902-090tsb101-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-090-100-101-1.1-610582_213_1_1_1_2_1_2.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds20','610871_213_3_1_1_2_1_1','610871','h902-080tsb101-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-080-100-101-1.1-610871_213_3_1_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds21','620542_213_1_1_1_2_1_1','620542','h902-080tsb201-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-080-200-201-1.1-620542_213_1_1_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds22','610631_213_1_1_1_1_1_1','610631','h902-080tsb101-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-080-100-101-1.1-610631_213_1_1_1_1_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds23','610630_213_1_1_1_2_1_1','610630','h902-080tsb101-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-080-100-101-1.1-610630_213_1_1_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds24','620645_213_1_1_1_2_1_1','620645','h902-070tsb201-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-070-200-201-1.1-620645_213_1_1_1_2_1_1.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds25','610582_213_1_1_1_1_1_2','610582','h902-090tsb101-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-090-100-101-1.1-610582_213_1_1_1_1_1_2.csv');
insert into datasets_info (dataset_alias,extensionid,studid,uniqueid,filename)
values ('ds26','610653_213_1_1_1_2_1_1','610653','h902-080tsb101-kf130.m050g9sub63sps2.1.1','050-213-Z1-UB63-080-100-101-1.1-610653_213_1_1_1_2_1_1.csv');


create index inx_datasetsinfo_alias on datasets_info(dataset_alias);
create index inx_datasetsinfo_extension on datasets_info(extensionid);
create index inx_datasetsinfo_tool on datasets_info(uniqueid);


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
------- WELDS NEW FIELDS
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

-- CLEAN DATA
-- 1) Remove 2019 data
delete from welds_actuals a where extract(YEAR from a.weld_timestamp) <= 2019;

-- 2) Remove null welds
delete from welds_actuals a where WeldTimeActual = 0 and lmpenetrationactual is null;

-- ADD average and limit fields for each measure
alter table welds_actuals add column penetration_avg_distance numeric;
alter table welds_actuals add column penetration_up_limit_distance numeric;
alter table welds_actuals add column penetration_low_limit_distance numeric;
alter table welds_actuals add column energy_avg_distance numeric;
alter table welds_actuals add column energy_up_limit_distance numeric;
alter table welds_actuals add column energy_low_limit_distance numeric;
alter table welds_actuals add column drop_time_avg_distance numeric;
alter table welds_actuals add column drop_time_up_limit_distance numeric;
alter table welds_actuals add column drop_time_low_limit_distance numeric;
alter table welds_actuals add column stickout_avg_distance numeric;
alter table welds_actuals add column stickout_up_limit_distance numeric;
alter table welds_actuals add column stickout_low_limit_distance numeric;
alter table welds_actuals add column lift_avg_distance numeric;
alter table welds_actuals add column lift_up_limit_distance numeric;
alter table welds_actuals add column lift_low_limit_distance numeric;
alter table welds_actuals add column time_avg_distance numeric;
alter table welds_actuals add column time_up_limit_distance numeric;
alter table welds_actuals add column time_low_limit_distance numeric;
alter table welds_actuals add column current_avg_distance numeric;
alter table welds_actuals add column current_up_limit_distance numeric;
alter table welds_actuals add column current_low_limit_distance numeric;
alter table welds_actuals add column voltage_avg_distance numeric;
alter table welds_actuals add column voltage_up_limit_distance numeric;
alter table welds_actuals add column voltage_low_limit_distance numeric;

-- PENETRATION update
update welds_actuals a set penetration_avg_distance = 
	(select round((a.lmpenetrationactual - b.penetration_avg)/abs(b.penetration_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period));

update welds_actuals a set penetration_up_limit_distance = 
	(select round((a.lmpenetrationactual - b.penetration_up_2sig)/abs(b.penetration_up_2sig - b.penetration_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.lmpenetrationactual > b.penetration_up_2sig and
	       b.penetration_up_2sig > b.penetration_avg);

update welds_actuals a set penetration_low_limit_distance = 
	(select round((b.penetration_low_2sig - a.lmpenetrationactual)/abs(b.penetration_avg - b.penetration_low_2sig),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.lmpenetrationactual < b.penetration_low_2sig and
	       b.penetration_low_2sig < b.penetration_avg);

-- ENERGY update
update welds_actuals a set energy_avg_distance = 
	(select round((a.weldenergyactual - b.enery_avg)/abs(b.enery_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period));

update welds_actuals a set energy_up_limit_distance = 
	(select round((a.weldenergyactual - b.energy_up_2sig)/abs(b.energy_up_2sig - b.enery_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.weldenergyactual > b.energy_up_2sig and
	       b.energy_up_2sig > b.enery_avg);

update welds_actuals a set energy_low_limit_distance = 
	(select round((b.energy_low_2sig - a.weldenergyactual)/abs(b.enery_avg - b.energy_low_2sig),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.weldenergyactual < b.energy_low_2sig and
	       b.energy_low_2sig < b.enery_avg);


-- DROP_TIME update
update welds_actuals a set drop_time_avg_distance = 
	(select round((a.droptimeactual - b.drop_time_avg)/abs(b.drop_time_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period));

update welds_actuals a set drop_time_up_limit_distance = 
	(select round((a.droptimeactual - b.drop_time_up_2sig)/abs(b.drop_time_up_2sig - b.drop_time_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.droptimeactual > b.drop_time_up_2sig and
	       b.drop_time_up_2sig > b.drop_time_avg);

update welds_actuals a set drop_time_low_limit_distance = 
	(select round((b.drop_time_low_2sig - a.droptimeactual)/abs(b.drop_time_avg - b.drop_time_low_2sig),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.droptimeactual < b.drop_time_low_2sig and
	       b.drop_time_low_2sig < b.drop_time_avg);

-- STICKOUT update
update welds_actuals a set stickout_avg_distance = 
	(select round((a.stickoutactual - b.stickout_avg)/abs(b.stickout_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period));

update welds_actuals a set stickout_up_limit_distance = 
	(select round((a.stickoutactual - b.stickout_up_2sig)/abs(b.stickout_up_2sig - b.stickout_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.stickoutactual > b.stickout_up_2sig and
	       b.stickout_up_2sig > b.stickout_avg);

update welds_actuals a set stickout_low_limit_distance = 
	(select round((b.stickout_low_2sig - a.stickoutactual)/abs(b.stickout_avg - b.stickout_low_2sig),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.stickoutactual < b.stickout_low_2sig and
	       b.stickout_low_2sig < b.stickout_avg);

-- LIFT update
update welds_actuals a set lift_avg_distance = 
	(select round((a.lmliftheightactual - b.lift_avg)/abs(b.lift_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period));

update welds_actuals a set lift_up_limit_distance = 
	(select round((a.lmliftheightactual - b.lift_up_2sig)/abs(b.lift_up_2sig - b.lift_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.lmliftheightactual > b.lift_up_2sig and
	       b.lift_up_2sig > b.lift_avg);

update welds_actuals a set lift_low_limit_distance = 
	(select round((b.lift_low_2sig - a.lmliftheightactual)/abs(b.lift_avg - b.lift_low_2sig),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.lmliftheightactual < b.lift_low_2sig and
	       b.lift_low_2sig < b.lift_avg);

-- TIME update
update welds_actuals a set time_avg_distance = 
	(select round((a.weldtimeactual - b.time_avg)/abs(b.time_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period));

update welds_actuals a set time_up_limit_distance = 
	(select round((a.weldtimeactual - b.time_up_2sig)/abs(b.time_up_2sig - b.time_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.weldtimeactual > b.time_up_2sig and
	       b.time_up_2sig > b.time_avg);

update welds_actuals a set time_low_limit_distance = 
	(select round((b.time_low_2sig - a.weldtimeactual)/abs(b.time_avg - b.time_low_2sig),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.weldtimeactual < b.time_low_2sig and
	       b.time_low_2sig < b.time_avg);

-- CURRENT update
update welds_actuals a set current_avg_distance = 
	(select round((a.weldcurrentactualpositive - b.current_avg)/abs(b.current_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period));

update welds_actuals a set current_up_limit_distance = 
	(select round((a.weldcurrentactualpositive - b.current_up_2sig)/abs(b.current_up_2sig - b.current_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.weldcurrentactualpositive > b.current_up_2sig and
	       b.current_up_2sig > b.current_avg);

update welds_actuals a set current_low_limit_distance = 
	(select round((b.current_low_2sig - a.weldcurrentactualpositive)/abs(b.current_avg - b.current_low_2sig),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.weldcurrentactualpositive < b.current_low_2sig and
	       b.current_low_2sig < b.current_avg);

-- voltage update
update welds_actuals a set voltage_avg_distance = 
	(select round((a.weldvoltageactual - b.voltage_avg)/abs(b.voltage_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period));

update welds_actuals a set voltage_up_limit_distance = 
	(select round((a.weldvoltageactual - b.voltage_up_2sig)/abs(b.voltage_up_2sig - b.voltage_avg),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.weldvoltageactual > b.voltage_up_2sig and
	       b.voltage_up_2sig > b.voltage_avg);

update welds_actuals a set voltage_low_limit_distance = 
	(select round((b.voltage_low_2sig - a.weldvoltageactual)/abs(b.voltage_avg - b.voltage_low_2sig),6)
	 from weld_averages b 
	 where b.key_tool = a.uniqueid and 
	       b.key_extension = a.extensionid and 
	       extract(YEAR from a.weld_timestamp) = extract(YEAR from b.key_period) and
	       extract(MONTH from a.weld_timestamp) = extract(MONTH from b.key_period) and
	       a.weldvoltageactual < b.voltage_low_2sig and
	       b.voltage_low_2sig < b.voltage_avg);

---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
------- CREATE TABLE WITH CURRENT WELD FEATURES
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
drop table if exists welds_25_datasets_cur_weld_features;
create table welds_25_datasets_cur_weld_features as
select 
      c."uniqueID",
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
      b.penetration_avg_distance,
      b.penetration_up_limit_distance,
      b.penetration_low_limit_distance,
      coalesce(b.penetration_up_limit_distance,-b.penetration_low_limit_distance,0) as penetration_offsigma_distance,
      case when b.penetration_up_limit_distance is not null then 1
           when b.penetration_low_limit_distance is not null then -1
           else 0 end as penetration_is_offsigma,
      b.energy_avg_distance,
      b.energy_up_limit_distance,
      b.energy_low_limit_distance,
      coalesce(b.energy_up_limit_distance,-b.energy_low_limit_distance,0) as energy_offsigma_distance,
      case when b.energy_up_limit_distance is not null then 1
           when b.energy_low_limit_distance is not null then -1
           else 0 end as energy_is_offsigma,
      b.drop_time_avg_distance,
      b.drop_time_up_limit_distance,
      b.drop_time_low_limit_distance,
      coalesce(b.drop_time_up_limit_distance,-b.drop_time_low_limit_distance,0) as drop_time_offsigma_distance,
      case when b.drop_time_up_limit_distance is not null then 1
           when b.drop_time_low_limit_distance is not null then -1
           else 0 end as drop_time_is_offsigma,
      b.stickout_avg_distance,
      b.stickout_up_limit_distance,
      b.stickout_low_limit_distance,
      coalesce(b.stickout_up_limit_distance,-b.stickout_low_limit_distance,0) as stickout_offsigma_distance,
      case when b.stickout_up_limit_distance is not null then 1
           when b.stickout_low_limit_distance is not null then -1
           else 0 end as stickout_is_offsigma,
      b.lift_avg_distance,
      b.lift_up_limit_distance,
      b.lift_low_limit_distance,
      coalesce(b.lift_up_limit_distance,-b.lift_low_limit_distance,0) as lift_offsigma_distance,
      case when b.lift_up_limit_distance is not null then 1
           when b.lift_low_limit_distance is not null then -1
           else 0 end as lift_is_offsigma,
      b.time_avg_distance,
      b.time_up_limit_distance,
      b.time_low_limit_distance,
      coalesce(b.time_up_limit_distance,-b.time_low_limit_distance,0) as time_offsigma_distance,
      case when b.time_up_limit_distance is not null then 1
           when b.time_low_limit_distance is not null then -1
           else 0 end as time_is_offsigma,
      b.current_avg_distance,
      b.current_up_limit_distance,
      b.current_low_limit_distance,
      coalesce(b.current_up_limit_distance,-b.current_low_limit_distance,0) as current_offsigma_distance,
      case when b.current_up_limit_distance is not null then 1
           when b.current_low_limit_distance is not null then -1
           else 0 end as current_is_offsigma,
      b.voltage_avg_distance,
      b.voltage_up_limit_distance,
      b.voltage_low_limit_distance,
      coalesce(b.voltage_up_limit_distance,-b.voltage_low_limit_distance,0) as voltage_offsigma_distance,
      case when b.voltage_up_limit_distance is not null then 1
           when b.voltage_low_limit_distance is not null then -1
           else 0 end as voltage_is_offsigma
from welds_actuals b, welds_25_datasets c
where b.extensionid = c.extensionid and
      b.uniqueid = c."uniqueID" and
      b.weld_timestamp = c.weld_timestamp;


 create unique index inx_w25dcurf_fingerprint on welds_25_datasets_cur_weld_features(fingerprint);
 create index inx_w25dcurf_key on welds_25_datasets_cur_weld_features(uniqueid,extensionid,weld_timestamp);


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
------- FEATURES
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------

-- average distance for 1 minute
drop table if exists welds_25_datasets_avg_features_1m;
create table welds_25_datasets_avg_features_1m(
	 uniqueid varchar(100),
	 extensionid varchar(100),
	 weld_timestamp timestamp,
	 fingerprint varchar(100),
     penetration_avg_diff_1m numeric,
     energy_avg_diff_1m numeric,
     droptime_avg_diff_1m numeric,
     stickout_avg_diff_1m numeric,
     lift_avg_diff_1m numeric,
     time_avg_diff_1m numeric,
     current_avg_diff_1m numeric,
     voltage_avg_diff_1m numeric);


insert into welds_25_datasets_avg_features_1m(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_avg_diff_1m,
     energy_avg_diff_1m,
     droptime_avg_diff_1m,
     stickout_avg_diff_1m,
     lift_avg_diff_1m,
     time_avg_diff_1m,
     current_avg_diff_1m,
     voltage_avg_diff_1m)
select
      c."uniqueID",
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  round(avg(b.penetration_avg_distance),6) penetration_avg,
 	  round(avg(b.energy_avg_distance),6) energy_avg,
 	  round(avg(b.drop_time_avg_distance),6) drop_t_avg,
 	  round(avg(b.stickout_avg_distance),6) stickout_avg,
 	  round(avg(b.lift_avg_distance),6) lift_avg,
 	  round(avg(b.time_avg_distance),6) t_avg,
 	  round(avg(b.current_avg_distance),6) current_avg,
      round(avg(b.voltage_avg_distance),6) voltage_avg
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '1 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint;


 create unique index inx_w25dsavg1_fingerprint on welds_25_datasets_avg_features_1m(fingerprint);
 create index inx_w25dsavg1_key on welds_25_datasets_avg_features_1m(uniqueid,extensionid,weld_timestamp);


drop table if exists welds_25_datasets_avg_features_5m;
create table welds_25_datasets_avg_features_5m(
     uniqueid varchar(100),
	 extensionid varchar(100),
	 weld_timestamp timestamp,
	 fingerprint varchar(100),
     penetration_avg_diff_5m numeric,
     energy_avg_diff_5m numeric,
     droptime_avg_diff_5m numeric,
     stickout_avg_diff_5m numeric,
     lift_avg_diff_5m numeric,
     time_avg_diff_5m numeric,
     current_avg_diff_5m numeric,
     voltage_avg_diff_5m numeric);

insert into welds_25_datasets_avg_features_5m(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_avg_diff_5m,
     energy_avg_diff_5m,
     droptime_avg_diff_5m,
     stickout_avg_diff_5m,
     lift_avg_diff_5m,
     time_avg_diff_5m,
     current_avg_diff_5m,
     voltage_avg_diff_5m)
select
      c."uniqueID",
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  round(avg(b.penetration_avg_distance),6) penetration_avg,
 	  round(avg(b.energy_avg_distance),6) energy_avg,
 	  round(avg(b.drop_time_avg_distance),6) drop_t_avg,
 	  round(avg(b.stickout_avg_distance),6) stickout_avg,
 	  round(avg(b.lift_avg_distance),6) lift_avg,
 	  round(avg(b.time_avg_distance),6) t_avg,
 	  round(avg(b.current_avg_distance),6) current_avg,
      round(avg(b.voltage_avg_distance),6) voltage_avg
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '5 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint;

create unique index inx_w25dsavg5_fingerprint on welds_25_datasets_avg_features_5m(fingerprint);
create index inx_w25dsavg5_key on welds_25_datasets_avg_features_5m(uniqueid,extensionid,weld_timestamp);

drop table if exists welds_25_datasets_avg_features_15m;
create table welds_25_datasets_avg_features_15m(
     uniqueid varchar(100),
	 extensionid varchar(100),
	 weld_timestamp timestamp,
	 fingerprint varchar(100),
     penetration_avg_diff_15m numeric,
     energy_avg_diff_15m numeric,
     droptime_avg_diff_15m numeric,
     stickout_avg_diff_15m numeric,
     lift_avg_diff_15m numeric,
     time_avg_diff_15m numeric,
     current_avg_diff_15m numeric,
     voltage_avg_diff_15m numeric);

insert into welds_25_datasets_avg_features_15m(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_avg_diff_15m,
     energy_avg_diff_15m,
     droptime_avg_diff_15m,
     stickout_avg_diff_15m,
     lift_avg_diff_15m,
     time_avg_diff_15m,
     current_avg_diff_15m,
     voltage_avg_diff_15m)
select
      c."uniqueID",
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  round(avg(b.penetration_avg_distance),6) penetration_avg,
 	  round(avg(b.energy_avg_distance),6) energy_avg,
 	  round(avg(b.drop_time_avg_distance),6) drop_t_avg,
 	  round(avg(b.stickout_avg_distance),6) stickout_avg,
 	  round(avg(b.lift_avg_distance),6) lift_avg,
 	  round(avg(b.time_avg_distance),6) t_avg,
 	  round(avg(b.current_avg_distance),6) current_avg,
      round(avg(b.voltage_avg_distance),6) voltage_avg
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '15 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint;

create unique index inx_w25dsavg15_fingerprint on welds_25_datasets_avg_features_15m(fingerprint);
create index inx_w25dsavg15_key on welds_25_datasets_avg_features_15m(uniqueid,extensionid,weld_timestamp);

drop table if exists welds_25_datasets_avg_features_60m;
create table welds_25_datasets_avg_features_60m(
     uniqueid varchar(100),
	 extensionid varchar(100),
	 weld_timestamp timestamp,
	 fingerprint varchar(100),
     penetration_avg_diff_60m numeric,
     energy_avg_diff_60m numeric,
     droptime_avg_diff_60m numeric,
     stickout_avg_diff_60m numeric,
     lift_avg_diff_60m numeric,
     time_avg_diff_60m numeric,
     current_avg_diff_60m numeric,
     voltage_avg_diff_60m numeric);

insert into welds_25_datasets_avg_features_60m(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_avg_diff_60m,
     energy_avg_diff_60m,
     droptime_avg_diff_60m,
     stickout_avg_diff_60m,
     lift_avg_diff_60m,
     time_avg_diff_60m,
     current_avg_diff_60m,
     voltage_avg_diff_60m)
select
      c."uniqueID",
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  round(avg(b.penetration_avg_distance),6) penetration_avg,
 	  round(avg(b.energy_avg_distance),6) energy_avg,
 	  round(avg(b.drop_time_avg_distance),6) drop_t_avg,
 	  round(avg(b.stickout_avg_distance),6) stickout_avg,
 	  round(avg(b.lift_avg_distance),6) lift_avg,
 	  round(avg(b.time_avg_distance),6) t_avg,
 	  round(avg(b.current_avg_distance),6) current_avg,
      round(avg(b.voltage_avg_distance),6) voltage_avg
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '60 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint;


create unique index inx_w25dsavg60_fingerprint on welds_25_datasets_avg_features_60m(fingerprint);
create index inx_w25dsavg60_key on welds_25_datasets_avg_features_60m(uniqueid,extensionid,weld_timestamp);


-- 1 minute update
/*
update welds_25_datasets a set
    penetration_avg_diff_1m = x.penetration_avg , 
    energy_avg_diff_1m      = x.energy_avg      , 
    droptime_avg_diff_1m    = x.drop_t_avg      , 
    stickout_avg_diff_1m    = x.stickout_avg    , 
    lift_avg_diff_1m        = x.lift_avg        , 
    time_avg_diff_1m        = x.t_avg           , 
    current_avg_diff_1m     = x.current_avg     , 
    voltage_avg_diff_1m     = x.voltage_avg
from
 (select
      c."uniqueID",
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  round(avg(b.penetration_avg_distance),6) penetration_avg,
 	  round(avg(b.energy_avg_distance),6) energy_avg,
 	  round(avg(b.drop_time_avg_distance),6) drop_t_avg,
 	  round(avg(b.stickout_avg_distance),6) stickout_avg,
 	  round(avg(b.lift_avg_distance),6) lift_avg,
 	  round(avg(b.time_avg_distance),6) t_avg,
 	  round(avg(b.current_avg_distance),6) current_avg,
      round(avg(b.voltage_avg_distance),6) voltage_avg
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '1 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint) x
 where a."uniqueID" = x."uniqueID" and
       a.extensionid = x.extensionid and
       a.weld_timestamp = x.weld_timestamp and
       a.fingerprint = x.fingerprint;
*/



/*
-- TEST
-- extension: 610456_213_3_1_1_1_1_1, uniqueID: h902-110tsb101-kf130.m050g9sub64sps3.1.1
-- time
select a.weld_timestamp, a.fingerprint, a."WeldTimeActual", a.time_avg_diff_1m
from welds_25_datasets a
where a."uniqueID" = 'h902-110tsb101-kf130.m050g9sub64sps3.1.1' and
      a.extensionid = '610456_213_3_1_1_1_1_1'
order by a.weld_timestamp;

select weld_timestamp from welds_actuals where uniqueid = 'h902-110tsb101-kf130.m050g9sub64sps3.1.1' and extensionid = '610456_213_3_1_1_1_1_1' order by 1;

-- first row check
select b.weld_timestamp, b.weldtimeactual, b.time_avg_distance, b.time_up_limit_distance, b.time_low_limit_distance
from welds_actuals b
where b.uniqueid = 'h902-110tsb101-kf130.m050g9sub64sps3.1.1' and
      b.weld_timestamp between to_timestamp('2020-03-02 00:05:55','YYYY-MM-DD HH24:MI:SS') and to_timestamp('2020-03-02 00:06:57','YYYY-MM-DD HH24:MI:SS')
order by b.weld_timestamp;

-- second row check
select b.weld_timestamp, b.weldtimeactual, b.time_avg_distance, b.time_up_limit_distance, b.time_low_limit_distance
from welds_actuals b
where b.uniqueid = 'h902-110tsb101-kf130.m050g9sub64sps3.1.1' and
      b.extensionid = '610456_213_3_1_1_1_1_1' and
      b.weld_timestamp between to_timestamp('2020-03-02 01:38:17','YYYY-MM-DD HH24:MI:SS') and to_timestamp('2020-03-02 01:39:19','YYYY-MM-DD HH24:MI:SS')
order by b.weld_timestamp;
*/


-- off_2sigma fields
drop table if exists welds_25_datasets_sigma_features_1m;
create table welds_25_datasets_sigma_features_1m(
	  uniqueid varchar(100),
	  extensionid varchar(100),
	  weld_timestamp timestamp,
	  fingerprint varchar(100),
      penetration_offsigma_1m numeric,
      energy_offsigma_1m numeric,
      droptime_offsigma_1m numeric,
      stickout_offsigma_1m numeric,
      lift_offsigma_1m numeric,
      time_offsigma_1m numeric,
      current_offsigma_1m numeric,
      voltage_offsigma_1m numeric);

insert into welds_25_datasets_sigma_features_1m(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_offsigma_1m,
     energy_offsigma_1m,
     droptime_offsigma_1m,
     stickout_offsigma_1m,
     lift_offsigma_1m,
     time_offsigma_1m,
     current_offsigma_1m,
     voltage_offsigma_1m)
select 
   x.uniqueid, 
   x.extensionid, 
   x.weld_timestamp, 
   x.fingerprint, 
   round(x.pen_ct_off_limit/x.total_count,6) as pen_off_limit_ratio,
   round(x.energy_ct_off_limit/x.total_count,6) as energy_off_limit_ratio,
   round(x.drop_time_ct_off_limit/x.total_count,6) as droptime_off_limit_ratio,
   round(x.stickout_ct_off_limit/x.total_count,6) as stickout_off_limit_ratio,
   round(x.lift_ct_off_limit/x.total_count,6) as lift_off_limit_ratio,
   round(x.t_ct_off_limit/x.total_count,6) as time_off_limit_ratio,
   round(x.current_ct_off_limit/x.total_count,6) as current_off_limit_ratio,
   round(x.voltage_ct_off_limit/x.total_count,6) as voltage_off_limit_ratio
from
  (select
      c."uniqueID" as uniqueid,
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  count(b.energy_up_limit_distance > 0 or b.energy_low_limit_distance < 0) energy_ct_off_limit,
 	  count(b.drop_time_up_limit_distance > 0 or b.drop_time_low_limit_distance < 0) drop_time_ct_off_limit,
 	  count(b.stickout_up_limit_distance > 0 or b.stickout_low_limit_distance < 0) stickout_ct_off_limit,
 	  count(b.lift_up_limit_distance > 0 or b.lift_low_limit_distance < 0) lift_ct_off_limit,
 	  count(b.time_up_limit_distance > 0 or b.time_low_limit_distance < 0) t_ct_off_limit,
 	  count(b.current_up_limit_distance > 0 or b.current_low_limit_distance < 0) current_ct_off_limit,
 	  count(b.voltage_up_limit_distance > 0 or b.voltage_low_limit_distance < 0) voltage_ct_off_limit,
 	  count(b.penetration_up_limit_distance > 0 or b.penetration_low_limit_distance < 0) pen_ct_off_limit,
 	  count(1) total_count
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '1 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint) x;

create unique index inx_w25ds_sigma1_fingerprint on welds_25_datasets_sigma_features_1m(fingerprint);
create index inx_w25ds_sigma1_key on welds_25_datasets_sigma_features_1m(uniqueid,extensionid,weld_timestamp);

drop table if exists welds_25_datasets_sigma_features_5m;
create table welds_25_datasets_sigma_features_5m(
	  uniqueid varchar(100),
	  extensionid varchar(100),
	  weld_timestamp timestamp,
	  fingerprint varchar(100),
      penetration_offsigma_5m numeric,
      energy_offsigma_5m numeric,
      droptime_offsigma_5m numeric,
      stickout_offsigma_5m numeric,
      lift_offsigma_5m numeric,
      time_offsigma_5m numeric,
      current_offsigma_5m numeric,
      voltage_offsigma_5m numeric);

insert into welds_25_datasets_sigma_features_5m(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_offsigma_5m,
     energy_offsigma_5m,
     droptime_offsigma_5m,
     stickout_offsigma_5m,
     lift_offsigma_5m,
     time_offsigma_5m,
     current_offsigma_5m,
     voltage_offsigma_5m)
select 
   x.uniqueid, 
   x.extensionid, 
   x.weld_timestamp, 
   x.fingerprint, 
   round(x.pen_ct_off_limit/x.total_count,6) as pen_off_limit_ratio,
   round(x.energy_ct_off_limit/x.total_count,6) as energy_off_limit_ratio,
   round(x.drop_time_ct_off_limit/x.total_count,6) as droptime_off_limit_ratio,
   round(x.stickout_ct_off_limit/x.total_count,6) as stickout_off_limit_ratio,
   round(x.lift_ct_off_limit/x.total_count,6) as lift_off_limit_ratio,
   round(x.t_ct_off_limit/x.total_count,6) as time_off_limit_ratio,
   round(x.current_ct_off_limit/x.total_count,6) as current_off_limit_ratio,
   round(x.voltage_ct_off_limit/x.total_count,6) as voltage_off_limit_ratio
from
  (select
      c."uniqueID" as uniqueid,
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  count(b.energy_up_limit_distance > 0 or b.energy_low_limit_distance < 0) energy_ct_off_limit,
 	  count(b.drop_time_up_limit_distance > 0 or b.drop_time_low_limit_distance < 0) drop_time_ct_off_limit,
 	  count(b.stickout_up_limit_distance > 0 or b.stickout_low_limit_distance < 0) stickout_ct_off_limit,
 	  count(b.lift_up_limit_distance > 0 or b.lift_low_limit_distance < 0) lift_ct_off_limit,
 	  count(b.time_up_limit_distance > 0 or b.time_low_limit_distance < 0) t_ct_off_limit,
 	  count(b.current_up_limit_distance > 0 or b.current_low_limit_distance < 0) current_ct_off_limit,
 	  count(b.voltage_up_limit_distance > 0 or b.voltage_low_limit_distance < 0) voltage_ct_off_limit,
 	  count(b.penetration_up_limit_distance > 0 or b.penetration_low_limit_distance < 0) pen_ct_off_limit,
 	  count(1) total_count
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '5 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint) x;

create unique index inx_w25ds_sigma5_fingerprint on welds_25_datasets_sigma_features_5m(fingerprint);
create index inx_w25ds_sigma5_key on welds_25_datasets_sigma_features_5m(uniqueid,extensionid,weld_timestamp);

drop table if exists welds_25_datasets_sigma_features_15m;
create table welds_25_datasets_sigma_features_15m(
	  uniqueid varchar(100),
	  extensionid varchar(100),
	  weld_timestamp timestamp,
	  fingerprint varchar(100),
      penetration_offsigma_15m numeric,
      energy_offsigma_15m numeric,
      droptime_offsigma_15m numeric,
      stickout_offsigma_15m numeric,
      lift_offsigma_15m numeric,
      time_offsigma_15m numeric,
      current_offsigma_15m numeric,
      voltage_offsigma_15m numeric);

insert into welds_25_datasets_sigma_features_15m(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_offsigma_15m,
     energy_offsigma_15m,
     droptime_offsigma_15m,
     stickout_offsigma_15m,
     lift_offsigma_15m,
     time_offsigma_15m,
     current_offsigma_15m,
     voltage_offsigma_15m)
select 
   x.uniqueid, 
   x.extensionid, 
   x.weld_timestamp, 
   x.fingerprint, 
   round(x.pen_ct_off_limit/x.total_count,6) as pen_off_limit_ratio,
   round(x.energy_ct_off_limit/x.total_count,6) as energy_off_limit_ratio,
   round(x.drop_time_ct_off_limit/x.total_count,6) as droptime_off_limit_ratio,
   round(x.stickout_ct_off_limit/x.total_count,6) as stickout_off_limit_ratio,
   round(x.lift_ct_off_limit/x.total_count,6) as lift_off_limit_ratio,
   round(x.t_ct_off_limit/x.total_count,6) as time_off_limit_ratio,
   round(x.current_ct_off_limit/x.total_count,6) as current_off_limit_ratio,
   round(x.voltage_ct_off_limit/x.total_count,6) as voltage_off_limit_ratio
from
  (select
      c."uniqueID" as uniqueid,
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  count(b.energy_up_limit_distance > 0 or b.energy_low_limit_distance < 0) energy_ct_off_limit,
 	  count(b.drop_time_up_limit_distance > 0 or b.drop_time_low_limit_distance < 0) drop_time_ct_off_limit,
 	  count(b.stickout_up_limit_distance > 0 or b.stickout_low_limit_distance < 0) stickout_ct_off_limit,
 	  count(b.lift_up_limit_distance > 0 or b.lift_low_limit_distance < 0) lift_ct_off_limit,
 	  count(b.time_up_limit_distance > 0 or b.time_low_limit_distance < 0) t_ct_off_limit,
 	  count(b.current_up_limit_distance > 0 or b.current_low_limit_distance < 0) current_ct_off_limit,
 	  count(b.voltage_up_limit_distance > 0 or b.voltage_low_limit_distance < 0) voltage_ct_off_limit,
 	  count(b.penetration_up_limit_distance > 0 or b.penetration_low_limit_distance < 0) pen_ct_off_limit,
 	  count(1) total_count
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '15 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint) x;

create unique index inx_w25ds_sigma15_fingerprint on welds_25_datasets_sigma_features_15m(fingerprint);
create index inx_w25ds_sigma15_key on welds_25_datasets_sigma_features_15m(uniqueid,extensionid,weld_timestamp);

drop table if exists welds_25_datasets_sigma_features_60m;
create table welds_25_datasets_sigma_features_60m(
	  uniqueid varchar(100),
	  extensionid varchar(100),
	  weld_timestamp timestamp,
	  fingerprint varchar(100),
      penetration_offsigma_60m numeric,
      energy_offsigma_60m numeric,
      droptime_offsigma_60m numeric,
      stickout_offsigma_60m numeric,
      lift_offsigma_60m numeric,
      time_offsigma_60m numeric,
      current_offsigma_60m numeric,
      voltage_offsigma_60m numeric);

insert into welds_25_datasets_sigma_features_60m(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_offsigma_60m,
     energy_offsigma_60m,
     droptime_offsigma_60m,
     stickout_offsigma_60m,
     lift_offsigma_60m,
     time_offsigma_60m,
     current_offsigma_60m,
     voltage_offsigma_60m)
select 
   x.uniqueid, 
   x.extensionid, 
   x.weld_timestamp, 
   x.fingerprint, 
   round(x.pen_ct_off_limit/x.total_count,6) as pen_off_limit_ratio,
   round(x.energy_ct_off_limit/x.total_count,6) as energy_off_limit_ratio,
   round(x.drop_time_ct_off_limit/x.total_count,6) as droptime_off_limit_ratio,
   round(x.stickout_ct_off_limit/x.total_count,6) as stickout_off_limit_ratio,
   round(x.lift_ct_off_limit/x.total_count,6) as lift_off_limit_ratio,
   round(x.t_ct_off_limit/x.total_count,6) as time_off_limit_ratio,
   round(x.current_ct_off_limit/x.total_count,6) as current_off_limit_ratio,
   round(x.voltage_ct_off_limit/x.total_count,6) as voltage_off_limit_ratio
from
  (select
      c."uniqueID" as uniqueid,
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  count(b.energy_up_limit_distance > 0 or b.energy_low_limit_distance < 0) energy_ct_off_limit,
 	  count(b.drop_time_up_limit_distance > 0 or b.drop_time_low_limit_distance < 0) drop_time_ct_off_limit,
 	  count(b.stickout_up_limit_distance > 0 or b.stickout_low_limit_distance < 0) stickout_ct_off_limit,
 	  count(b.lift_up_limit_distance > 0 or b.lift_low_limit_distance < 0) lift_ct_off_limit,
 	  count(b.time_up_limit_distance > 0 or b.time_low_limit_distance < 0) t_ct_off_limit,
 	  count(b.current_up_limit_distance > 0 or b.current_low_limit_distance < 0) current_ct_off_limit,
 	  count(b.voltage_up_limit_distance > 0 or b.voltage_low_limit_distance < 0) voltage_ct_off_limit,
 	  count(b.penetration_up_limit_distance > 0 or b.penetration_low_limit_distance < 0) pen_ct_off_limit,
 	  count(1) total_count
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '60 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint) x;

create unique index inx_w25ds_sigma60_fingerprint on welds_25_datasets_sigma_features_60m(fingerprint);
create index inx_w25ds_sigma60_key on welds_25_datasets_sigma_features_60m(uniqueid,extensionid,weld_timestamp);

------------------------------------------------------
------------------------------------------------------
--- ADDITIONAL OFF SIGMA FEATURES 3h, 6h, 12h
------------------------------------------------------
------------------------------------------------------
drop table if exists welds_25_datasets_sigma_features_3h;
create table welds_25_datasets_sigma_features_3h(
	  uniqueid varchar(100),
	  extensionid varchar(100),
	  weld_timestamp timestamp,
	  fingerprint varchar(100),
      penetration_offsigma_3h numeric,
      energy_offsigma_3h numeric,
      droptime_offsigma_3h numeric,
      stickout_offsigma_3h numeric,
      lift_offsigma_3h numeric,
      time_offsigma_3h numeric,
      current_offsigma_3h numeric,
      voltage_offsigma_3h numeric);

insert into welds_25_datasets_sigma_features_3h(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_offsigma_3h,
     energy_offsigma_3h,
     droptime_offsigma_3h,
     stickout_offsigma_3h,
     lift_offsigma_3h,
     time_offsigma_3h,
     current_offsigma_3h,
     voltage_offsigma_3h)
select 
   x.uniqueid, 
   x.extensionid, 
   x.weld_timestamp, 
   x.fingerprint, 
   round(x.pen_ct_off_limit/x.total_count,6) as pen_off_limit_ratio,
   round(x.energy_ct_off_limit/x.total_count,6) as energy_off_limit_ratio,
   round(x.drop_time_ct_off_limit/x.total_count,6) as droptime_off_limit_ratio,
   round(x.stickout_ct_off_limit/x.total_count,6) as stickout_off_limit_ratio,
   round(x.lift_ct_off_limit/x.total_count,6) as lift_off_limit_ratio,
   round(x.t_ct_off_limit/x.total_count,6) as time_off_limit_ratio,
   round(x.current_ct_off_limit/x.total_count,6) as current_off_limit_ratio,
   round(x.voltage_ct_off_limit/x.total_count,6) as voltage_off_limit_ratio
from
  (select
      c."uniqueID" as uniqueid,
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  count(b.energy_up_limit_distance > 0 or b.energy_low_limit_distance < 0) energy_ct_off_limit,
 	  count(b.drop_time_up_limit_distance > 0 or b.drop_time_low_limit_distance < 0) drop_time_ct_off_limit,
 	  count(b.stickout_up_limit_distance > 0 or b.stickout_low_limit_distance < 0) stickout_ct_off_limit,
 	  count(b.lift_up_limit_distance > 0 or b.lift_low_limit_distance < 0) lift_ct_off_limit,
 	  count(b.time_up_limit_distance > 0 or b.time_low_limit_distance < 0) t_ct_off_limit,
 	  count(b.current_up_limit_distance > 0 or b.current_low_limit_distance < 0) current_ct_off_limit,
 	  count(b.voltage_up_limit_distance > 0 or b.voltage_low_limit_distance < 0) voltage_ct_off_limit,
 	  count(b.penetration_up_limit_distance > 0 or b.penetration_low_limit_distance < 0) pen_ct_off_limit,
 	  count(1) total_count
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '180 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint) x;

create unique index inx_w25ds_sigma3h_fingerprint on welds_25_datasets_sigma_features_3hm(fingerprint);
create index inx_w25ds_sigma3h_key on welds_25_datasets_sigma_features_3hm(uniqueid,extensionid,weld_timestamp);


drop table if exists welds_25_datasets_sigma_features_6h;
create table welds_25_datasets_sigma_features_6h(
	  uniqueid varchar(100),
	  extensionid varchar(100),
	  weld_timestamp timestamp,
	  fingerprint varchar(100),
      penetration_offsigma_6h numeric,
      energy_offsigma_6h numeric,
      droptime_offsigma_6h numeric,
      stickout_offsigma_6h numeric,
      lift_offsigma_6h numeric,
      time_offsigma_6h numeric,
      current_offsigma_6h numeric,
      voltage_offsigma_6h numeric);

insert into welds_25_datasets_sigma_features_6h(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_offsigma_6h,
     energy_offsigma_6h,
     droptime_offsigma_6h,
     stickout_offsigma_6h,
     lift_offsigma_6h,
     time_offsigma_6h,
     current_offsigma_6h,
     voltage_offsigma_6h)
select 
   x.uniqueid, 
   x.extensionid, 
   x.weld_timestamp, 
   x.fingerprint, 
   round(x.pen_ct_off_limit/x.total_count,6) as pen_off_limit_ratio,
   round(x.energy_ct_off_limit/x.total_count,6) as energy_off_limit_ratio,
   round(x.drop_time_ct_off_limit/x.total_count,6) as droptime_off_limit_ratio,
   round(x.stickout_ct_off_limit/x.total_count,6) as stickout_off_limit_ratio,
   round(x.lift_ct_off_limit/x.total_count,6) as lift_off_limit_ratio,
   round(x.t_ct_off_limit/x.total_count,6) as time_off_limit_ratio,
   round(x.current_ct_off_limit/x.total_count,6) as current_off_limit_ratio,
   round(x.voltage_ct_off_limit/x.total_count,6) as voltage_off_limit_ratio
from
  (select
      c."uniqueID" as uniqueid,
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  count(b.energy_up_limit_distance > 0 or b.energy_low_limit_distance < 0) energy_ct_off_limit,
 	  count(b.drop_time_up_limit_distance > 0 or b.drop_time_low_limit_distance < 0) drop_time_ct_off_limit,
 	  count(b.stickout_up_limit_distance > 0 or b.stickout_low_limit_distance < 0) stickout_ct_off_limit,
 	  count(b.lift_up_limit_distance > 0 or b.lift_low_limit_distance < 0) lift_ct_off_limit,
 	  count(b.time_up_limit_distance > 0 or b.time_low_limit_distance < 0) t_ct_off_limit,
 	  count(b.current_up_limit_distance > 0 or b.current_low_limit_distance < 0) current_ct_off_limit,
 	  count(b.voltage_up_limit_distance > 0 or b.voltage_low_limit_distance < 0) voltage_ct_off_limit,
 	  count(b.penetration_up_limit_distance > 0 or b.penetration_low_limit_distance < 0) pen_ct_off_limit,
 	  count(1) total_count
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '360 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint) x;

create unique index inx_w25ds_sigma6h_fingerprint on welds_25_datasets_sigma_features_6hm(fingerprint);
create index inx_w25ds_sigma6h_key on welds_25_datasets_sigma_features_6hm(uniqueid,extensionid,weld_timestamp);


drop table if exists welds_25_datasets_sigma_features_12h;
create table welds_25_datasets_sigma_features_12h(
	  uniqueid varchar(100),
	  extensionid varchar(100),
	  weld_timestamp timestamp,
	  fingerprint varchar(100),
      penetration_offsigma_12h numeric,
      energy_offsigma_12h numeric,
      droptime_offsigma_12h numeric,
      stickout_offsigma_12h numeric,
      lift_offsigma_12h numeric,
      time_offsigma_12h numeric,
      current_offsigma_12h numeric,
      voltage_offsigma_12h numeric);

insert into welds_25_datasets_sigma_features_12h(
     uniqueid,
     extensionid,
     weld_timestamp,
     fingerprint,
     penetration_offsigma_12h,
     energy_offsigma_12h,
     droptime_offsigma_12h,
     stickout_offsigma_12h,
     lift_offsigma_12h,
     time_offsigma_12h,
     current_offsigma_12h,
     voltage_offsigma_12h)
select 
   x.uniqueid, 
   x.extensionid, 
   x.weld_timestamp, 
   x.fingerprint, 
   round(x.pen_ct_off_limit/x.total_count,6) as pen_off_limit_ratio,
   round(x.energy_ct_off_limit/x.total_count,6) as energy_off_limit_ratio,
   round(x.drop_time_ct_off_limit/x.total_count,6) as droptime_off_limit_ratio,
   round(x.stickout_ct_off_limit/x.total_count,6) as stickout_off_limit_ratio,
   round(x.lift_ct_off_limit/x.total_count,6) as lift_off_limit_ratio,
   round(x.t_ct_off_limit/x.total_count,6) as time_off_limit_ratio,
   round(x.current_ct_off_limit/x.total_count,6) as current_off_limit_ratio,
   round(x.voltage_ct_off_limit/x.total_count,6) as voltage_off_limit_ratio
from
  (select
      c."uniqueID" as uniqueid,
      c.extensionid,
      c.weld_timestamp,
      c.fingerprint,
 	  count(b.energy_up_limit_distance > 0 or b.energy_low_limit_distance < 0) energy_ct_off_limit,
 	  count(b.drop_time_up_limit_distance > 0 or b.drop_time_low_limit_distance < 0) drop_time_ct_off_limit,
 	  count(b.stickout_up_limit_distance > 0 or b.stickout_low_limit_distance < 0) stickout_ct_off_limit,
 	  count(b.lift_up_limit_distance > 0 or b.lift_low_limit_distance < 0) lift_ct_off_limit,
 	  count(b.time_up_limit_distance > 0 or b.time_low_limit_distance < 0) t_ct_off_limit,
 	  count(b.current_up_limit_distance > 0 or b.current_low_limit_distance < 0) current_ct_off_limit,
 	  count(b.voltage_up_limit_distance > 0 or b.voltage_low_limit_distance < 0) voltage_ct_off_limit,
 	  count(b.penetration_up_limit_distance > 0 or b.penetration_low_limit_distance < 0) pen_ct_off_limit,
 	  count(1) total_count
  from welds_actuals b, welds_25_datasets c 
  where b.uniqueid = c."uniqueID" and 
        b.weld_timestamp between c.weld_timestamp - interval '360 min' and c.weld_timestamp - interval '1 second'
  group by c."uniqueID", c.extensionid, c.weld_timestamp, c.fingerprint) x;

create unique index inx_w25ds_sigma12h_fingerprint on welds_25_datasets_sigma_features_12hm(fingerprint);
create index inx_w25ds_sigma12h_key on welds_25_datasets_sigma_features_12hm(uniqueid,extensionid,weld_timestamp);


/*
daimler=# \d welds_actuals
                             Table "public.welds_actuals"
          Column           |           Type           | Collation | Nullable | Default 
---------------------------+--------------------------+-----------+----------+---------
 uniqueid                  | character varying(50)    |           |          | 
 extensionid               | character varying(50)    |           |          | 
 weld_timestamp            | timestamp with time zone |           |          | 
 faultcode                 | numeric                  |           |          | 
 weldenergyactual          | numeric                  |           |          | 
 droptimeactual            | numeric                  |           |          | 
 lmpenetrationactual       | numeric                  |           |          | 
 stickoutactual            | numeric                  |           |          | 
 lmliftheightactual        | numeric                  |           |          | 
 weldtimeactual            | numeric                  |           |          | 
 weldcurrentactualpositive | numeric                  |           |          | 
 weldvoltageactual         | numeric                  |           |          | 


desc weld_averages

key_tool             | character varying(100) |           |          | 
 key_extension        | character varying(100) |           |          | 
 key_period           | date                   |           |          | 
 num_elements         | numeric                |           |          | 
 penetration_avg      | numeric                |           |          | 
 penetration_up_2sig  | numeric                |           |          | 
 penetration_low_2sig | numeric                |           |          | 
 drop_time_avg        | numeric                |           |          | 
 drop_time_up_2sig    | numeric                |           |          | 
 drop_time_low_2sig   | numeric                |           |          | 
 voltage_avg          | numeric                |           |          | 
 voltage_up_2sig      | numeric                |           |          | 
 voltage_low_2sig     | numeric                |           |          | 
 time_avg             | numeric                |           |          | 
 time_up_2sig         | numeric                |           |          | 
 time_low_2sig        | numeric                |           |          | 
 lift_avg             | numeric                |           |          | 
 lift_up_2sig         | numeric                |           |          | 
 lift_low_2sig        | numeric                |           |          | 
 current_avg          | numeric                |           |          | 
 current_up_2sig      | numeric                |           |          | 
 current_low_2sig     | numeric                |           |          | 
 enery_avg            | numeric                |           |          | 
 energy_up_2sig       | numeric                |           |          | 
 energy_low_2sig      | numeric                |           |          | 
 stickout_avg         | numeric                |           |          | 
 stickout_up_2sig     | numeric                |           |          | 
 stickout_low_2sig    | numeric                |           |          | 

daimler=# \d welds_25_datasets
                                            Table "public.welds_25_datasets"
                           Column                            |           Type           | Collation | Nullable | Default 
-------------------------------------------------------------+--------------------------+-----------+----------+---------
 CarbodyID                                                   | character varying(50)    |           |          | 
 weld_timestamp                                              | timestamp with time zone |           |          | 
 extensionid                                                 | character varying(100)   |           |          | 
 StudID                                                      | character varying(10)    |           |          | 
 uniqueID                                                    | character varying(100)   |           |          | 
*/