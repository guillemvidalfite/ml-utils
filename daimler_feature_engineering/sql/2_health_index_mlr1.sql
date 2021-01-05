


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
------- 
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
drop table if exists health_index_mlr1;
create table health_index_mlr1(
	"id"                              numeric,
	"tool_id"                         varchar(100),
	"day"                             date, 
	"health"                          numeric,
    "avg_health_5d"                   numeric,
    "avg_health_10d"                  numeric,
    "avg_health_20d"                  numeric,
    "range_health_5d"                 numeric,
    "range_health_10d"                numeric,
    "range_health_20d"                numeric,
    "min_health_5d"                   numeric,
    "min_health_10d"                  numeric,
    "min_health_20d"                  numeric,
    "var_health_5d"                   numeric,
    "var_health_10d"                  numeric,
    "var_health_20d"                  numeric,
    "ratio_health_under_100_10d"      numeric,
    "ratio_health_under_100_20d"      numeric,
    "ratio_health_under_100_30d"      numeric,
    "ratio_health_under_80_10d"       numeric,
    "ratio_health_under_80_20d"       numeric,
    "ratio_health_under_80_30d"       numeric,
    "ratio_health_under_60_10d"       numeric,
    "ratio_health_under_60_20d"       numeric,
    "ratio_health_under_60_30d"       numeric,
    "welds"                           numeric,
    "avg_welds_5d"                    numeric,
    "avg_welds_10d"                   numeric,
    "avg_welds_20d"                   numeric,
    "range_welds_5d"                  numeric,
    "range_welds_10d"                 numeric,
    "range_welds_20d"                 numeric,
    "var_welds_5d"                    numeric,
    "var_welds_10d"                   numeric,
    "var_welds_20d"                   numeric,
    "min_welds_5d"                    numeric,
    "min_welds_10d"                   numeric,
    "min_welds_20d"                   numeric,
    "wops"                            numeric,
    "avg_wops_5d"                     numeric,
    "avg_wops_10d"                    numeric,
    "avg_wops_20d"                    numeric,
    "range_wops_5d"                   numeric,
    "range_wops_10d"                  numeric,
    "range_wops_20d"                  numeric,
    "var_wops_5d"                     numeric,
    "var_wops_10d"                    numeric,
    "var_wops_20d"                    numeric,
    "max_wops_5d"                     numeric,
    "max_wops_10d"                    numeric,
    "max_wops_20d"                    numeric,
    "health_d+5"                      numeric,
    "health_d+7"                      numeric,
    "health_d+10"                     numeric,
    "health_d+15"                     numeric,
    "is_health_d+5_under_0.8?"        varchar(3),
    "is_health_d+7_under_0.8?"        varchar(3),
    "is_health_d+10_under_0.8?"       varchar(3),
    "is_health_d+15_under_0.8?"       varchar(3),
    "health_index_decrease_d+5"       varchar(3),
    "health_index_decrease_d+7"       varchar(3),
    "health_index_decrease_d+10"      varchar(3),
    "health_index_decrease_d+15"      varchar(3),
    "health_index_decrease1_d+5"      varchar(3),
    "health_index_decrease1_d+7"      varchar(3),
    "health_index_decrease1_d+10"     varchar(3),
    "health_index_decrease1_d+15"     varchar(3)
);

-- INITIAL INSERT, 1 row for each tool and day
insert into health_index_mlr1(id, tool_id, day, health, welds, wops)
select a.id::numeric, a.tool_id, a.day, round(a.health,4), a.weld_count, a.wops_count
from health_index a
order by day, tool_id;

create index inx_himlr1_toolday on health_index_mlr1(tool_id, day);

-- 5D update
update health_index_mlr1 a set avg_health_5d    = (select round(avg(health),4)                       from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set range_health_5d  = (select round(max(health) - min(health),4)         from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set min_health_5d    = (select round(min(health),4)                       from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set var_health_5d    = (select round(variance(health),4)                  from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set avg_welds_5d     = (select round(avg(weld_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set range_welds_5d   = (select round(max(weld_count) - min(weld_count),4) from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set var_welds_5d     = (select round(variance(weld_count),4)              from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set min_welds_5d     = (select round(min(weld_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set avg_wops_5d      = (select round(avg(wops_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set range_wops_5d    = (select round(max(wops_count) - min(wops_count),4) from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set var_wops_5d      = (select round(variance(wops_count),4)              from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);
update health_index_mlr1 a set max_wops_5d      = (select round(max(wops_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '5 DAY' and a.day);

-- 10D update
update health_index_mlr1 a set avg_health_10d    = (select round(avg(health),4)                       from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set range_health_10d  = (select round(max(health) - min(health),4)         from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set min_health_10d    = (select round(min(health),4)                       from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set var_health_10d    = (select round(variance(health),4)                  from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set avg_welds_10d     = (select round(avg(weld_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set range_welds_10d   = (select round(max(weld_count) - min(weld_count),4) from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set var_welds_10d     = (select round(variance(weld_count),4)              from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set min_welds_10d     = (select round(min(weld_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set avg_wops_10d      = (select round(avg(wops_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set range_wops_10d    = (select round(max(wops_count) - min(wops_count),4) from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set var_wops_10d      = (select round(variance(wops_count),4)              from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);
update health_index_mlr1 a set max_wops_10d      = (select round(max(wops_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day);

-- 20D update
update health_index_mlr1 a set avg_health_20d    = (select round(avg(health),4)                       from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set range_health_20d  = (select round(max(health) - min(health),4)         from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set min_health_20d    = (select round(min(health),4)                       from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set var_health_20d    = (select round(variance(health),4)                  from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set avg_welds_20d     = (select round(avg(weld_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set range_welds_20d   = (select round(max(weld_count) - min(weld_count),4) from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set var_welds_20d     = (select round(variance(weld_count),4)              from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set min_welds_20d     = (select round(min(weld_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set avg_wops_20d      = (select round(avg(wops_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set range_wops_20d    = (select round(max(wops_count) - min(wops_count),4) from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set var_wops_20d      = (select round(variance(wops_count),4)              from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);
update health_index_mlr1 a set max_wops_20d      = (select round(max(wops_count),4)                   from health_index b where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day);

-- RATIOS
-- tmp tables
drop table if exists tmp_health_10d_counts;
create table tmp_health_10d_counts as
select a.tool_id, a.day, count(*)::numeric as total, (count(*) filter (where b.health < 1))::numeric as count_u100, (count(*) filter (where b.health < 0.8))::numeric as count_u80, (count(*) filter (where b.health < 0.6))::numeric as count_u60
from health_index_mlr1 a, health_index b
where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day
group by a.tool_id, a.day;

create index inx_tmph10dcounts_toolday on tmp_health_10d_counts(tool_id, day);

drop table if exists tmp_health_20d_counts;
create table tmp_health_20d_counts as
select a.tool_id, a.day, count(*)::numeric as total, (count(*) filter (where b.health < 1))::numeric as count_u100, (count(*) filter (where b.health < 0.8))::numeric as count_u80, (count(*) filter (where b.health < 0.6))::numeric as count_u60
from health_index_mlr1 a, health_index b
where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day
group by a.tool_id, a.day;

create index inx_tmph20dcounts_toolday on tmp_health_20d_counts(tool_id, day);

drop table if exists tmp_health_30d_counts;
create table tmp_health_30d_counts as
select a.tool_id, a.day, count(*)::numeric as total, (count(*) filter (where b.health < 1))::numeric as count_u100, (count(*) filter (where b.health < 0.8))::numeric as count_u80, (count(*) filter (where b.health < 0.6))::numeric as count_u60
from health_index_mlr1 a, health_index b
where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '30 DAY' and a.day
group by a.tool_id, a.day;

create index inx_tmph30dcounts_toolday on tmp_health_30d_counts(tool_id, day);

update health_index_mlr1 a set "ratio_health_under_100_10d" = (select round((b.count_u100 / b.total),4) from tmp_health_10d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr1 a set "ratio_health_under_100_20d" = (select round((b.count_u100 / b.total),4) from tmp_health_20d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr1 a set "ratio_health_under_100_30d" = (select round((b.count_u100 / b.total),4) from tmp_health_30d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr1 a set "ratio_health_under_80_10d"  = (select round((b.count_u80 / b.total),4) from tmp_health_10d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr1 a set "ratio_health_under_80_20d"  = (select round((b.count_u80 / b.total),4) from tmp_health_20d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr1 a set "ratio_health_under_80_30d"  = (select round((b.count_u80 / b.total),4) from tmp_health_30d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr1 a set "ratio_health_under_60_10d"  = (select round((b.count_u60 / b.total),4) from tmp_health_10d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr1 a set "ratio_health_under_60_20d"  = (select round((b.count_u60 / b.total),4) from tmp_health_20d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr1 a set "ratio_health_under_60_30d"  = (select round((b.count_u60 / b.total),4) from tmp_health_30d_counts b where b.tool_id = a.tool_id and b.day = a.day);

drop table if exists tmp_health_10d_counts;
drop table if exists tmp_health_20d_counts;
drop table if exists tmp_health_30d_counts;



-- OBJECTIVE FIELDS
update health_index_mlr1 a set "health_d+5" = (select b.health from health_index b where b.tool_id = a.tool_id and b.day = a.day + INTERVAL '5 DAY');
update health_index_mlr1 a set "health_d+7" = (select b.health from health_index b where b.tool_id = a.tool_id and b.day = a.day + INTERVAL '7 DAY');
update health_index_mlr1 a set "health_d+10" = (select b.health from health_index b where b.tool_id = a.tool_id and b.day = a.day + INTERVAL '10 DAY');
update health_index_mlr1 a set "health_d+15" = (select b.health from health_index b where b.tool_id = a.tool_id and b.day = a.day + INTERVAL '15 DAY');

update health_index_mlr1 set "is_health_d+5_under_0.8?"  = case when "health_d+5" < 0.8 then 'YES' else 'NO' end;
update health_index_mlr1 set "is_health_d+7_under_0.8?"  = case when "health_d+7" < 0.8 then 'YES' else 'NO' end;
update health_index_mlr1 set "is_health_d+10_under_0.8?" = case when "health_d+10" < 0.8 then 'YES' else 'NO' end;
update health_index_mlr1 set "is_health_d+15_under_0.8?" = case when "health_d+15" < 0.8 then 'YES' else 'NO' end;

update health_index_mlr1 set "health_index_decrease_d+5" = case when "health_d+5" < health then 'YES' else 'NO' end;    
update health_index_mlr1 set "health_index_decrease_d+7" = case when "health_d+7" < health then 'YES' else 'NO' end;    
update health_index_mlr1 set "health_index_decrease_d+10" = case when "health_d+10" < health then 'YES' else 'NO' end;
update health_index_mlr1 set "health_index_decrease_d+15" = case when "health_d+15" < health then 'YES' else 'NO' end;
#update health_index_mlr1 set "health_index_decrease1_d+5" = case when "health_d+5" < health then "YES" else 'NO' end;   
#update health_index_mlr1 set "health_index_decrease1_d+7" = case when "health_d+5" < health then "YES" else 'NO' end;   
#update health_index_mlr1 set "health_index_decrease1_d+10" = case when "health_d+5" < health then "YES" else 'NO' end;  
#update health_index_mlr1 set "health_index_decrease1_d+15" = case when "health_d+5" < health then "YES" else 'NO' end;  











