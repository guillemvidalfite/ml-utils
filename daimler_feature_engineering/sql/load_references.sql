
drop table if exists imp_weld_references;
create table imp_weld_references(
      key_tool               varchar(100),
      key_extension          varchar(100),
      key_period             varchar(100),
      num_elements           numeric,
      penetration_ref        numeric,
      penetration_up_limit   numeric,
      penetration_low_limit  numeric,
      drop_time_ref          numeric,
      drop_time_up_limit     numeric,
      drop_time_low_limit    numeric,
      voltage_ref            numeric,
      voltage_up_limit       numeric,
      voltage_low_limit      numeric,
      time_ref               numeric,
      time_up_limit          numeric,
      time_low_limit         numeric,
      lift_ref               numeric,
      lift_up_limit          numeric,
      lift_low_limit         numeric,
      current_ref            numeric,
      current_up_limit       numeric,
      current_low_limit      numeric,
      enery_ref              numeric,
      energy_up_limit        numeric,
      energy_low_limit       numeric,
      stickout_ref           numeric,
      stickout_up_limit      numeric,
      stickout_low_limit     numeric
);

-- load data
copy imp_weld_references(
      key_tool,
      key_extension,
      key_period,
      num_elements,
      penetration_ref,
      penetration_up_limit,
      penetration_low_limit,
      drop_time_ref,
      drop_time_up_limit,
      drop_time_low_limit,
      voltage_ref,
      voltage_up_limit,
      voltage_low_limit,
      time_ref,
      time_up_limit,
      time_low_limit,
      lift_ref,
      lift_up_limit,
      lift_low_limit,
      current_ref,
      current_up_limit,
      current_low_limit,
      enery_ref,
      energy_up_limit,
      energy_low_limit,
      stickout_ref,
      stickout_up_limit,
      stickout_low_limit
)
FROM '/Users/guillem/Data/Customers/Daimler/references/tool_reference_stats.csv' DELIMITER ',' CSV HEADER;


--- create online table with proper types
drop table if exists weld_references;
create table weld_references(
      key_tool               varchar(100),
      key_extension          varchar(100),
      key_period             date,
      num_elements           numeric,
      penetration_ref        numeric,
      penetration_up_limit   numeric,
      penetration_low_limit  numeric,
      drop_time_ref          numeric,
      drop_time_up_limit     numeric,
      drop_time_low_limit    numeric,
      voltage_ref            numeric,
      voltage_up_limit       numeric,
      voltage_low_limit      numeric,
      time_ref               numeric,
      time_up_limit          numeric,
      time_low_limit         numeric,
      lift_ref               numeric,
      lift_up_limit          numeric,
      lift_low_limit         numeric,
      current_ref            numeric,
      current_up_limit       numeric,
      current_low_limit      numeric,
      enery_ref              numeric,
      energy_up_limit        numeric,
      energy_low_limit       numeric,
      stickout_ref           numeric,
      stickout_up_limit      numeric,
      stickout_low_limit     numeric
);

insert into weld_references(
       key_tool,
       key_extension,
       key_period,
       num_elements,
       penetration_ref,
       penetration_up_limit,
       penetration_low_limit,
       drop_time_ref,
       drop_time_up_limit,
       drop_time_low_limit,
       voltage_ref,
       voltage_up_limit,
       voltage_low_limit,
       time_ref,
       time_up_limit,
       time_low_limit,
       lift_ref,
       lift_up_limit,
       lift_low_limit,
       current_ref,
       current_up_limit,
       current_low_limit,
       enery_ref,
       energy_up_limit,
       energy_low_limit,
       stickout_ref,
       stickout_up_limit,
       stickout_low_limit)
select 
       a.key_tool,
       a.key_extension,
       to_date(a.key_period,'YYYY-MM'),
       a.num_elements,
       a.penetration_ref,
       a.penetration_up_limit,
       a.penetration_low_limit,
       a.drop_time_ref,
       a.drop_time_up_limit,
       a.drop_time_low_limit,
       a.voltage_ref,
       a.voltage_up_limit,
       a.voltage_low_limit,
       a.time_ref,
       a.time_up_limit,
       a.time_low_limit,
       a.lift_ref,
       a.lift_up_limit,
       a.lift_low_limit,
       a.current_ref,
       a.current_up_limit,
       a.current_low_limit,
       a.enery_ref,
       a.energy_up_limit,
       a.energy_low_limit,
       a.stickout_ref,
       a.stickout_up_limit,
       a.stickout_low_limit
from imp_weld_references a;


-- penetration: variations spotted over months
select key_tool, key_extension, key_period, num_elements, penetration_ref, penetration_up_limit, penetration_low_limit from weld_references order by 1,2,3;
select key_tool, key_extension, key_period, num_elements, round(penetration_ref,4) from weld_references order by 1,2,3;
-- drop time: more stable
select key_tool, key_extension, key_period, num_elements, drop_time_ref, drop_time_up_limit, drop_time_low_limit from weld_references order by 1,2,3;
-- voltage: 
select key_tool, key_extension, key_period, num_elements, voltage_ref, voltage_up_limit, voltage_low_limit from weld_references order by 1,2,3;
-- time: stable
select key_tool, key_extension, key_period, num_elements, time_ref, time_up_limit, time_low_limit from weld_references order by 1,2,3;
-- lift: stable
select key_tool, key_extension, key_period, num_elements, lift_ref, lift_up_limit, lift_low_limit from weld_references order by 1,2,3;
-- current: most of time 720, why?
select key_tool, key_extension, key_period, num_elements, current_ref, current_up_limit, current_low_limit from weld_references order by 1,2,3;
-- energy
select key_tool, key_extension, key_period, num_elements, enery_ref, energy_up_limit, energy_low_limit from weld_references order by 1,2,3;
-- stickout
select key_tool, key_extension, key_period, num_elements, stickout_ref, stickout_up_limit, stickout_low_limit from weld_references order by 1,2,3;










