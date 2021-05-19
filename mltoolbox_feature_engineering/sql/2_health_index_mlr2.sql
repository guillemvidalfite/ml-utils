


---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
-------  health_index_mlr2
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
drop table if exists health_index_mlr2;
create table health_index_mlr2(
	  "id"                                          numeric,
	  "tool_id"                                     varchar(100),
	  "day"                                         date, 
	  "health"                                      numeric,
    "welds"                                       numeric,
    "wops"                                        numeric,
    "alerts"                                      numeric,
    "repairs"                                     numeric,
    "score_avg"                                   numeric,
    "ftsit_avg"                                   numeric,
    "dta_avg"                                     numeric,
    "fta_avg"                                     numeric,
    "lmlha_avg"                                   numeric,
    "lmpa_avg"                                    numeric,
    "pva_avg"                                     numeric,
    "sa_avg"                                      numeric,
    "wca_avg"                                     numeric,
    "wea_avg"                                     numeric,
    "wta_avg"                                     numeric,
    "wtmtlpb_avg"                                 numeric,
    "wtmtlpf_avg"                                 numeric,
    "wtsbmt_avg"                                  numeric,
    "wtsfmt_avg"                                  numeric,
    "wtsfrtalbp_avg"                              numeric,
    "wtsfsp_avg"                                  numeric,
    "wva_avg"                                     numeric,
    "ftsit_avg_roll_mean"                         numeric,
    "ftsit_avg_roll_mean_ratio"                   numeric,
    "alerts_score_avg_roll_mean"                  numeric,
    "alerts_score_avg_roll_mean_ratio"            numeric,
    "dta_avg_roll_mean"                           numeric,
    "dta_avg_roll_mean_ratio"                     numeric,
    "fta_avg_roll_mean"                           numeric,
    "fta_avg_roll_mean_ratio"                     numeric,
    "lmlha_avg_roll_mean"                         numeric,
    "lmlha_avg_roll_mean_ratio"                   numeric,
    "lmpa_avg_roll_mean"                          numeric,
    "lmpa_avg_roll_mean_ratio"                    numeric,
    "pva_avg_roll_mean"                           numeric,
    "pva_avg_roll_mean_ratio"                     numeric,
    "sa_avg_roll_mean"                            numeric,
    "sa_avg_roll_mean_ratio"                      numeric,
    "score_avg_roll_mean"                         numeric,
    "score_avg_roll_mean_ratio"                   numeric,
    "wca_avg_roll_mean"                           numeric,
    "wca_avg_roll_mean_ratio"                     numeric,
    "wea_avg_roll_mean"                           numeric,
    "wea_avg_roll_mean_ratio"                     numeric,
    "wta_avg_roll_mean"                           numeric,
    "wta_avg_roll_mean_ratio"                     numeric,
    "wtmtlpb_avg_roll_mean"                       numeric,
    "wtmtlpb_avg_roll_mean_ratio"                 numeric,
    "wtmtlpf_avg_roll_mean"                       numeric,
    "wtmtlpf_avg_roll_mean_ratio"                 numeric,
    "wtsbmt_avg_roll_mean"                        numeric,
    "wtsbmt_avg_roll_mean_ratio"                  numeric,
    "wtsfmt_avg_roll_mean"                        numeric,
    "wtsfmt_avg_roll_mean_ratio"                  numeric,
    "wtsfrtalbp_avg_roll_mean"                    numeric,
    "wtsfrtalbp_avg_roll_mean_ratio"              numeric,
    "wtsfsp_avg_roll_mean"                        numeric,
    "wtsfsp_avg_roll_mean_ratio"                  numeric,
    "wva_avg_roll_mean"                           numeric,
    "wva_avg_roll_mean_ratio"                     numeric,
    "ratio_health_under_100_10d"                  numeric,
    "ratio_health_under_100_20d"                  numeric,
    "ratio_health_under_100_30d"                  numeric,
    "welds_total_count"                           numeric,
    "wops_total_count"                            numeric,
    "total_welds_30_days"                         numeric,
    "total_wops_30_days"                          numeric,
    "health_d+7"                                  numeric,
    "health_index_decrease_d+7"                   varchar(3),
    "3_lower_health_7days?"                       varchar(3),
    "3_under_100_7days?"                          varchar(3)
);


-- INITIAL INSERT, 1 row for each tool and day
insert into health_index_mlr2(
       "id",
       "tool_id",
       "day",
       "health",
       "welds",
       "wops",
       "alerts",
       "repairs",
       "score_avg",
       "ftsit_avg",
       "dta_avg",
       "fta_avg",
       "lmlha_avg",
       "lmpa_avg",
       "pva_avg",
       "sa_avg",
       "wca_avg",
       "wea_avg",
       "wta_avg",
       "wtmtlpb_avg",
       "wtmtlpf_avg",
       "wtsbmt_avg",
       "wtsfmt_avg",
       "wtsfrtalbp_avg",
       "wtsfsp_avg",
       "wva_avg",
       "ftsit_avg_roll_mean",
       "ftsit_avg_roll_mean_ratio",
       "alerts_score_avg_roll_mean",
       "alerts_score_avg_roll_mean_ratio",
       "dta_avg_roll_mean",
       "dta_avg_roll_mean_ratio",
       "fta_avg_roll_mean",
       "fta_avg_roll_mean_ratio",
       "lmlha_avg_roll_mean",
       "lmlha_avg_roll_mean_ratio",
       "lmpa_avg_roll_mean",
       "lmpa_avg_roll_mean_ratio",
       "pva_avg_roll_mean",
       "pva_avg_roll_mean_ratio",
       "sa_avg_roll_mean",
       "sa_avg_roll_mean_ratio",
       "score_avg_roll_mean",
       "score_avg_roll_mean_ratio",
       "wca_avg_roll_mean",
       "wca_avg_roll_mean_ratio",
       "wea_avg_roll_mean",
       "wea_avg_roll_mean_ratio",
       "wta_avg_roll_mean",
       "wta_avg_roll_mean_ratio",
       "wtmtlpb_avg_roll_mean",
       "wtmtlpb_avg_roll_mean_ratio",
       "wtmtlpf_avg_roll_mean",
       "wtmtlpf_avg_roll_mean_ratio",
       "wtsbmt_avg_roll_mean",
       "wtsbmt_avg_roll_mean_ratio",
       "wtsfmt_avg_roll_mean",
       "wtsfmt_avg_roll_mean_ratio",
       "wtsfrtalbp_avg_roll_mean",
       "wtsfrtalbp_avg_roll_mean_ratio",
       "wtsfsp_avg_roll_mean",
       "wtsfsp_avg_roll_mean_ratio",
       "wva_avg_roll_mean",
       "wva_avg_roll_mean_ratio")
select 
       a.id::numeric, 
       a.tool_id, 
       a.day, 
       round(a.health,4), 
       a.weld_count, 
       a.wops_count,
       a.alerts_count,
       a.bodyshop_tp_count + a.assembly_shop_count,
       a.score_avg,
       a.ftsit_avg,
       a.dta_avg,
       a.fta_avg,
       a.lmlha_avg,
       a.lmpa_avg,
       a.pva_avg,
       a.sa_avg,
       a.wca_avg,
       a.wea_avg,
       a.wta_avg,
       a.wtmtlpb_avg,
       a.wtmtlpf_avg,
       a.wtsbmt_avg,
       a.wtsfmt_avg,
       a.wtsfrtalbp_avg,
       a.wtsfsp_avg,
       a.wva_avg,
       a.ftsit_avg_roll_mean,
       a.ftsit_avg_roll_mean_ratio,
       a.alerts_score_avg_roll_mean,
       a.alerts_score_avg_roll_mean_ratio,
       a.dta_avg_roll_mean,
       a.dta_avg_roll_mean_ratio,
       a.fta_avg_roll_mean,
       a.fta_avg_roll_mean_ratio,
       a.lmlha_avg_roll_mean,
       a.lmlha_avg_roll_mean_ratio,
       a.lmpa_avg_roll_mean,
       a.lmpa_avg_roll_mean_ratio,
       a.pva_avg_roll_mean,
       a.pva_avg_roll_mean_ratio,
       a.sa_avg_roll_mean,
       a.sa_avg_roll_mean_ratio,
       a.score_avg_roll_mean,
       a.score_avg_roll_mean_ratio,
       a.wca_avg_roll_mean,
       a.wca_avg_roll_mean_ratio,
       a.wea_avg_roll_mean,
       a.wea_avg_roll_mean_ratio,
       a.wta_avg_roll_mean,
       a.wta_avg_roll_mean_ratio,
       a.wtmtlpb_avg_roll_mean,
       a.wtmtlpb_avg_roll_mean_ratio,
       a.wtmtlpf_avg_roll_mean,
       a.wtmtlpf_avg_roll_mean_ratio,
       a.wtsbmt_avg_roll_mean,
       a.wtsbmt_avg_roll_mean_ratio,
       a.wtsfmt_avg_roll_mean,
       a.wtsfmt_avg_roll_mean_ratio,
       a.wtsfrtalbp_avg_roll_mean,
       a.wtsfrtalbp_avg_roll_mean_ratio,
       a.wtsfsp_avg_roll_mean,
       a.wtsfsp_avg_roll_mean_ratio,
       a.wva_avg_roll_mean,
       a.wva_avg_roll_mean_ratio
from health_index a
order by day, tool_id;

create index inx_himlr2_toolday on health_index_mlr2(tool_id, day);

------------------------------------------------------------------------------------------
------------------ HEALTH UNDER 100 RATIOS
------------------------------------------------------------------------------------------
-- tmp tables
drop table if exists tmp_health_10d_counts;
create table tmp_health_10d_counts as
select a.tool_id, a.day, count(*)::numeric as total, (count(*) filter (where b.health < 1))::numeric as count_u100, (count(*) filter (where b.health < 0.8))::numeric as count_u80, (count(*) filter (where b.health < 0.6))::numeric as count_u60
from health_index_mlr2 a, health_index b
where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day
group by a.tool_id, a.day;

create index inx_tmph10dcounts_toolday on tmp_health_10d_counts(tool_id, day);

drop table if exists tmp_health_20d_counts;
create table tmp_health_20d_counts as
select a.tool_id, a.day, count(*)::numeric as total, (count(*) filter (where b.health < 1))::numeric as count_u100, (count(*) filter (where b.health < 0.8))::numeric as count_u80, (count(*) filter (where b.health < 0.6))::numeric as count_u60
from health_index_mlr2 a, health_index b
where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day
group by a.tool_id, a.day;

create index inx_tmph20dcounts_toolday on tmp_health_20d_counts(tool_id, day);

drop table if exists tmp_health_30d_counts;
create table tmp_health_30d_counts as
select a.tool_id, a.day, count(*)::numeric as total, (count(*) filter (where b.health < 1))::numeric as count_u100, (count(*) filter (where b.health < 0.8))::numeric as count_u80, (count(*) filter (where b.health < 0.6))::numeric as count_u60
from health_index_mlr2 a, health_index b
where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '30 DAY' and a.day
group by a.tool_id, a.day;

create index inx_tmph30dcounts_toolday on tmp_health_30d_counts(tool_id, day);

update health_index_mlr2 a set "ratio_health_under_100_10d" = (select round((b.count_u100 / b.total),4) from tmp_health_10d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr2 a set "ratio_health_under_100_20d" = (select round((b.count_u100 / b.total),4) from tmp_health_20d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr2 a set "ratio_health_under_100_30d" = (select round((b.count_u100 / b.total),4) from tmp_health_30d_counts b where b.tool_id = a.tool_id and b.day = a.day);

drop table if exists tmp_health_10d_counts;
drop table if exists tmp_health_20d_counts;
drop table if exists tmp_health_30d_counts;

------------------------------------------------------
--   WELDS COUNTS
------------------------------------------------------
update health_index_mlr2 a set welds_total_count = (select total_welds from tool_counters_day b, tool_codes c where b.uniqueid = c.uniqueid and c.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr2 a set wops_total_count = (select total_wops from tool_counters_day b, tool_codes c where b.uniqueid = c.uniqueid and c.tool_id = a.tool_id and b.day = a.day);

-- health_d+7
update health_index_mlr2 a set "health_d+7" = (select b.health from health_index b where b.tool_id = a.tool_id and b.day = a.day + INTERVAL '7 DAY');
-- health_index_decrease_d+7
update health_index_mlr2 set "health_index_decrease_d+7" = case when "health_d+7" < health then 'YES' else 'NO' end;


-- 3_lower_health_7days?
update health_index_mlr2 a set "3_lower_health_7days?" = (select case when count(*) >= 3 then 'YES' else 'NO' end from health_index b where b.tool_id = a.tool_id and b.day > a.day and b.day <= a.day + INTERVAL '7 DAY' and b.health < a.health);
-- 3_under_100_7days?
update health_index_mlr2 a set "3_under_100_7days?" = (select case when count(*) >= 3 then 'YES' else 'NO' end from health_index b where b.tool_id = a.tool_id and b.day > a.day and b.day <= a.day + INTERVAL '7 DAY' and b.health < 1);




