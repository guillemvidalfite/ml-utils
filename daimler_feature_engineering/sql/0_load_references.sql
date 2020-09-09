
drop table if exists imp_weld_references;
create table imp_weld_references(
      key_tool               varchar(100),
      key_extension          varchar(100),
      key_period             varchar(100),
      num_elements           numeric,
      penetration_ref        numeric,
      penetration_up_limit   numeric,
      penetration_low_2sig  numeric,
      drop_time_ref          numeric,
      drop_time_up_limit     numeric,
      drop_time_low_2sig    numeric,
      voltage_ref            numeric,
      voltage_up_limit       numeric,
      voltage_low_2sig      numeric,
      time_ref               numeric,
      time_up_limit          numeric,
      time_low_2sig         numeric,
      lift_ref               numeric,
      lift_up_limit          numeric,
      lift_low_2sig         numeric,
      current_ref            numeric,
      current_up_limit       numeric,
      current_low_2sig      numeric,
      enery_ref              numeric,
      energy_up_limit        numeric,
      energy_low_2sig       numeric,
      stickout_ref           numeric,
      stickout_up_limit      numeric,
      stickout_low_2sig     numeric
);

-- load data
copy imp_weld_references(
      key_tool,
      key_extension,
      key_period,
      num_elements,
      penetration_ref,
      penetration_up_limit,
      penetration_low_2sig,
      drop_time_ref,
      drop_time_up_limit,
      drop_time_low_2sig,
      voltage_ref,
      voltage_up_limit,
      voltage_low_2sig,
      time_ref,
      time_up_limit,
      time_low_2sig,
      lift_ref,
      lift_up_limit,
      lift_low_2sig,
      current_ref,
      current_up_limit,
      current_low_2sig,
      enery_ref,
      energy_up_limit,
      energy_low_2sig,
      stickout_ref,
      stickout_up_limit,
      stickout_low_2sig
)
FROM '/Users/guillem/Data/Customers/Daimler/references/tool_reference_stats_jul.csv' DELIMITER ',' CSV HEADER;


--- create online table with proper types
drop table if exists weld_averages;
create table weld_averages(
      key_tool               varchar(100),
      key_extension          varchar(100),
      key_period             date,
      num_elements           numeric,
      penetration_avg        numeric,
      penetration_up_2sig   numeric,
      penetration_low_2sig  numeric,
      drop_time_avg          numeric,
      drop_time_up_2sig     numeric,
      drop_time_low_2sig    numeric,
      voltage_avg            numeric,
      voltage_up_2sig       numeric,
      voltage_low_2sig      numeric,
      time_avg               numeric,
      time_up_2sig          numeric,
      time_low_2sig         numeric,
      lift_avg               numeric,
      lift_up_2sig          numeric,
      lift_low_2sig         numeric,
      current_avg            numeric,
      current_up_2sig       numeric,
      current_low_2sig      numeric,
      enery_avg              numeric,
      energy_up_2sig        numeric,
      energy_low_2sig       numeric,
      stickout_avg           numeric,
      stickout_up_2sig      numeric,
      stickout_low_2sig     numeric
);

insert into weld_averages(
       key_tool,
       key_extension,
       key_period,
       num_elements,
       penetration_avg,
       penetration_up_2sig,
       penetration_low_2sig,
       drop_time_avg,
       drop_time_up_2sig,
       drop_time_low_2sig,
       voltage_avg,
       voltage_up_2sig,
       voltage_low_2sig,
       time_avg,
       time_up_2sig,
       time_low_2sig,
       lift_avg,
       lift_up_2sig,
       lift_low_2sig,
       current_avg,
       current_up_2sig,
       current_low_2sig,
       enery_avg,
       energy_up_2sig,
       energy_low_2sig,
       stickout_avg,
       stickout_up_2sig,
       stickout_low_2sig)
select 
       a.key_tool,
       a.key_extension,
       to_date(a.key_period,'YYYY-MM'),
       a.num_elements,
       a.penetration_ref,
       a.penetration_up_limit,
       a.penetration_low_2sig,
       a.drop_time_ref,
       a.drop_time_up_limit,
       a.drop_time_low_2sig,
       a.voltage_ref,
       a.voltage_up_limit,
       a.voltage_low_2sig,
       a.time_ref,
       a.time_up_limit,
       a.time_low_2sig,
       a.lift_ref,
       a.lift_up_limit,
       a.lift_low_2sig,
       a.current_ref,
       a.current_up_limit,
       a.current_low_2sig,
       a.enery_ref,
       a.energy_up_limit,
       a.energy_low_2sig,
       a.stickout_ref,
       a.stickout_up_limit,
       a.stickout_low_2sig
from imp_weld_references a;

create index inx_toolextperiod_weldref on weld_averages(key_tool, key_extension, key_period);
create index inx_period_weldref on weld_averages(key_period);


-- penetration: variations spotted over months
--select key_tool, key_extension, key_period, num_elements, penetration_avg, penetration_up_2sig, penetration_low_2sig from weld_references order by 1,2,3;
--select key_tool, key_extension, key_period, num_elements, round(penetration_avg,4) from weld_avgerences order by 1,2,3;
---- drop time: more stable
--select key_tool, key_extension, key_period, num_elements, drop_time_avg, drop_time_up_2sig, drop_time_low_2sig from weld_references order by 1,2,3;
---- voltage: 
--select key_tool, key_extension, key_period, num_elements, voltage_avg, voltage_up_2sig, voltage_low_2sig from weld_references order by 1,2,3;
---- time: stable
--select key_tool, key_extension, key_period, num_elements, time_avg, time_up_2sig, time_low_2sig from weld_references order by 1,2,3;
---- lift: stable
--select key_tool, key_extension, key_period, num_elements, lift_avg, lift_up_2sig, lift_low_2sig from weld_references order by 1,2,3;
---- current: most of time 720, why?
--select key_tool, key_extension, key_period, num_elements, current_avg, current_up_2sig, current_low_2sig from weld_references order by 1,2,3;
---- energy
--select key_tool, key_extension, key_period, num_elements, enery_avg, energy_up_2sig, energy_low_2sig from weld_references order by 1,2,3;
---- stickout
--select key_tool, key_extension, key_period, num_elements, stickout_avg, stickout_up_2sig, stickout_low_2sig from weld_references order by 1,2,3;










