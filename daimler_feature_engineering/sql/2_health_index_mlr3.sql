---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
-------  health_index_mlr3
---------------------------------------------------
---------------------------------------------------
---------------------------------------------------
drop table if exists health_index_mlr3;
create table health_index_mlr3(
	"id"                                          numeric,
	"tool_id"                                     varchar(100),
	"day"                                         date, 
	"health"                                      numeric,
    "welds"                                       numeric,
    "wops"                                        numeric,
    "alerts"                                      numeric,
    "repairs"                                     numeric,
    "score_avg"                                   numeric,
    "ftsit_avg_roll_mean_ratio"                   numeric,
    "alerts_score_avg_roll_mean_ratio"            numeric,
    "dta_avg_roll_mean_ratio"                     numeric,
    "fta_avg_roll_mean_ratio"                     numeric,
    "lmlha_avg_roll_mean_ratio"                   numeric,
    "lmpa_avg_roll_mean_ratio"                    numeric,
    "pva_avg_roll_mean_ratio"                     numeric,
    "sa_avg_roll_mean_ratio"                      numeric,
    "score_avg_roll_mean_ratio"                   numeric,
    "wca_avg_roll_mean_ratio"                     numeric,
    "wea_avg_roll_mean_ratio"                     numeric,
    "wta_avg_roll_mean_ratio"                     numeric,
    "wtmtlpb_avg_roll_mean_ratio"                 numeric,
    "wtmtlpf_avg_roll_mean_ratio"                 numeric,
    "wtsbmt_avg_roll_mean_ratio"                  numeric,
    "wtsfmt_avg_roll_mean_ratio"                  numeric,
    "wtsfrtalbp_avg_roll_mean_ratio"              numeric,
    "wtsfsp_avg_roll_mean_ratio"                  numeric,
    "wva_avg_roll_mean_ratio"                     numeric,
    "ratio_health_under_100_10d"                  numeric,
    "ratio_health_under_100_20d"                  numeric,
    "ratio_health_under_100_30d"                  numeric,
    "welds_total_count"                           numeric,
    "wops_total_count"                            numeric,
    "total_welds_30_days"                         numeric,
    "total_wops_30_days"                          numeric,
    "ftsit_avg_dist_day_ratio"                    numeric,
    "ftsit_off_day_ratio"                         numeric,
    "dta_avg_dist_day_ratio"                      numeric,
    "dta_off_day_ratio"                           numeric,
    "fta_avg_dist_day_ratio"                      numeric,
    "fta_off_day_ratio"                           numeric,
    "lmlha_avg_dist_day_ratio"                    numeric,
    "lmlha_off_day_ratio"                         numeric,
    "lmpa_avg_dist_day_ratio"                     numeric,
    "lmpa_off_day_ratio"                          numeric,
    "pva_avg_dist_day_ratio"                      numeric,
    "pva_off_day_ratio"                           numeric,
    "sa_avg_dist_day_ratio"                       numeric,
    "sa_off_day_ratio"                            numeric,
    "wca_avg_dist_day_ratio"                      numeric,
    "wca_off_day_ratio"                           numeric,
    "wea_avg_dist_day_ratio"                      numeric,
    "wea_off_day_ratio"                           numeric,
    "wta_avg_dist_day_ratio"                      numeric,
    "wta_off_day_ratio"                           numeric,
    "wtmtlpb_avg_dist_day_ratio"                  numeric,
    "wtmtlpb_off_day_ratio"                       numeric,
    "wtmtlpf_avg_dist_day_ratio"                  numeric,
    "wtmtlpf_off_day_ratio"                       numeric,
    "wtsbmt_avg_dist_day_ratio"                   numeric,
    "wtsbmt_off_day_ratio"                        numeric,
    "wtsfmt_avg_dist_day_ratio"                   numeric,
    "wtsfmt_off_day_ratio"                        numeric,
    "wtsfrtalbp_avg_dist_day_ratio"               numeric,
    "wtsfrtalbp_off_day_ratio"                    numeric,
    "wtsfsp_avg_dist_day_ratio"                   numeric,
    "wtsfsp_off_day_ratio"                        numeric,
    "wva_avg_dist_day_ratio"                      numeric,
    "wva_off_day_ratio"                           numeric,
    "ftsit_avg_dist_avg_ratio"                    numeric,
    "ftsit_off_avg_ratio"                         numeric,
    "dta_avg_dist_avg_ratio"                      numeric,
    "dta_off_avg_ratio"                           numeric,
    "fta_avg_dist_avg_ratio"                      numeric,
    "fta_off_avg_ratio"                           numeric,
    "lmlha_avg_dist_avg_ratio"                    numeric,
    "lmlha_off_avg_ratio"                         numeric,
    "lmpa_avg_dist_avg_ratio"                     numeric,
    "lmpa_off_avg_ratio"                          numeric,
    "pva_avg_dist_avg_ratio"                      numeric,
    "pva_off_avg_ratio"                           numeric,
    "sa_avg_dist_avg_ratio"                       numeric,
    "sa_off_avg_ratio"                            numeric,
    "wca_avg_dist_avg_ratio"                      numeric,
    "wca_off_avg_ratio"                           numeric,
    "wea_avg_dist_avg_ratio"                      numeric,
    "wea_off_avg_ratio"                           numeric,
    "wta_avg_dist_avg_ratio"                      numeric,
    "wta_off_avg_ratio"                           numeric,
    "wtmtlpb_avg_dist_avg_ratio"                  numeric,
    "wtmtlpb_off_avg_ratio"                       numeric,
    "wtmtlpf_avg_dist_avg_ratio"                  numeric,
    "wtmtlpf_off_avg_ratio"                       numeric,
    "wtsbmt_avg_dist_avg_ratio"                   numeric,
    "wtsbmt_off_avg_ratio"                        numeric,
    "wtsfmt_avg_dist_avg_ratio"                   numeric,
    "wtsfmt_off_avg_ratio"                        numeric,
    "wtsfrtalbp_avg_dist_avg_ratio"               numeric,
    "wtsfrtalbp_off_avg_ratio"                    numeric,
    "wtsfsp_avg_dist_avg_ratio"                   numeric,
    "wtsfsp_off_avg_ratio"                        numeric,
    "wva_avg_dist_avg_ratio"                      numeric,
    "wva_off_avg_ratio"                           numeric,
    "3_lower_health_7days?"                       varchar(3),
    "3_under_100_7days?"                          varchar(3),
    "6_lower_health_14days?"                      varchar(3),
    "6_under_100_14days?"                         varchar(3)
);


-- INITIAL INSERT, 1 row for each tool and day
insert into health_index_mlr3(
    "id",
    "tool_id",
    "day",
    "health",
    "welds",
    "wops",
    "alerts",
    "repairs",
    "score_avg",
    "ftsit_avg_roll_mean_ratio",
    "alerts_score_avg_roll_mean_ratio",
    "dta_avg_roll_mean_ratio",
    "fta_avg_roll_mean_ratio",
    "lmlha_avg_roll_mean_ratio",
    "lmpa_avg_roll_mean_ratio",
    "pva_avg_roll_mean_ratio",
    "sa_avg_roll_mean_ratio",
    "score_avg_roll_mean_ratio",
    "wca_avg_roll_mean_ratio",
    "wea_avg_roll_mean_ratio",
    "wta_avg_roll_mean_ratio",
    "wtmtlpb_avg_roll_mean_ratio",
    "wtmtlpf_avg_roll_mean_ratio",
    "wtsbmt_avg_roll_mean_ratio",
    "wtsfmt_avg_roll_mean_ratio",
    "wtsfrtalbp_avg_roll_mean_ratio",
    "wtsfsp_avg_roll_mean_ratio",
    "wva_avg_roll_mean_ratio",
    "welds_total_count",
    "wops_total_count")
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
       a.ftsit_avg_roll_mean_ratio,
       a.alerts_score_avg_roll_mean_ratio,
       a.dta_avg_roll_mean_ratio,
       a.fta_avg_roll_mean_ratio,
       a.lmlha_avg_roll_mean_ratio,
       a.lmpa_avg_roll_mean_ratio,
       a.pva_avg_roll_mean_ratio,
       a.sa_avg_roll_mean_ratio,
       a.score_avg_roll_mean_ratio,
       a.wca_avg_roll_mean_ratio,
       a.wea_avg_roll_mean_ratio,
       a.wta_avg_roll_mean_ratio,
       a.wtmtlpb_avg_roll_mean_ratio,
       a.wtmtlpf_avg_roll_mean_ratio,
       a.wtsbmt_avg_roll_mean_ratio,
       a.wtsfmt_avg_roll_mean_ratio,
       a.wtsfrtalbp_avg_roll_mean_ratio,
       a.wtsfsp_avg_roll_mean_ratio,
       a.wva_avg_roll_mean_ratio,
       ct.total_welds,
       ct.total_wops
from health_index a, tool_codes cod, tool_counters_day ct 
where a.tool_id = cod.tool_id and
      cod.uniqueid = ct.uniqueid and
      a.day = ct.day
order by day, tool_id;

create index inx_himlr3_toolday on health_index_mlr3(tool_id,day);
create index inx_himlr3_daytool on health_index_mlr3(day,tool_id);

------------------------------------------------------------------------------------------
------------------ HEALTH UNDER 100 RATIOS
------------------------------------------------------------------------------------------
-- tmp tables
drop table if exists tmp_health_10d_counts;
create table tmp_health_10d_counts as
select a.tool_id, a.day, count(*)::numeric as total, (count(*) filter (where b.health < 1))::numeric as count_u100, (count(*) filter (where b.health < 0.8))::numeric as count_u80, (count(*) filter (where b.health < 0.6))::numeric as count_u60
from health_index_mlr3 a, health_index b
where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '10 DAY' and a.day
group by a.tool_id, a.day;

create index inx_tmph10dcounts_toolday on tmp_health_10d_counts(tool_id, day);

drop table if exists tmp_health_20d_counts;
create table tmp_health_20d_counts as
select a.tool_id, a.day, count(*)::numeric as total, (count(*) filter (where b.health < 1))::numeric as count_u100, (count(*) filter (where b.health < 0.8))::numeric as count_u80, (count(*) filter (where b.health < 0.6))::numeric as count_u60
from health_index_mlr3 a, health_index b
where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '20 DAY' and a.day
group by a.tool_id, a.day;

create index inx_tmph20dcounts_toolday on tmp_health_20d_counts(tool_id, day);

drop table if exists tmp_health_30d_counts;
create table tmp_health_30d_counts as
select a.tool_id, a.day, count(*)::numeric as total, (count(*) filter (where b.health < 1))::numeric as count_u100, (count(*) filter (where b.health < 0.8))::numeric as count_u80, (count(*) filter (where b.health < 0.6))::numeric as count_u60
from health_index_mlr3 a, health_index b
where b.tool_id = a.tool_id and b.day between a.day - INTERVAL '30 DAY' and a.day
group by a.tool_id, a.day;

create index inx_tmph30dcounts_toolday on tmp_health_30d_counts(tool_id, day);

update health_index_mlr3 a set "ratio_health_under_100_10d" = (select round((b.count_u100 / b.total),4) from tmp_health_10d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr3 a set "ratio_health_under_100_20d" = (select round((b.count_u100 / b.total),4) from tmp_health_20d_counts b where b.tool_id = a.tool_id and b.day = a.day);
update health_index_mlr3 a set "ratio_health_under_100_30d" = (select round((b.count_u100 / b.total),4) from tmp_health_30d_counts b where b.tool_id = a.tool_id and b.day = a.day);

drop table if exists tmp_health_10d_counts;
drop table if exists tmp_health_20d_counts;
drop table if exists tmp_health_30d_counts;


------------------------------------------------------------------------------------------
------------------ DAY DIFF AND OFFLIMITS
------------------------------------------------------------------------------------------
UPDATE health_index_mlr3 a
SET   ftsit_avg_dist_day_ratio       = x.avg_ftsit_avg_dist_day_ratio, 
      ftsit_off_day_ratio            = x.avg_ftsit_off_day_ratio,       
      dta_avg_dist_day_ratio         = x.avg_dta_avg_dist_day_ratio,
      dta_off_day_ratio              = x.avg_dta_off_day_ratio,
      fta_avg_dist_day_ratio         = x.avg_fta_avg_dist_day_ratio,
      fta_off_day_ratio              = x.avg_fta_off_day_ratio,
      lmlha_avg_dist_day_ratio       = x.avg_lmlha_avg_dist_day_ratio,
      lmlha_off_day_ratio            = x.avg_lmlha_off_day_ratio,
      lmpa_avg_dist_day_ratio        = x.avg_lmpa_avg_dist_day_ratio,
      lmpa_off_day_ratio             = x.avg_lmpa_off_day_ratio,
      pva_avg_dist_day_ratio         = x.avg_pva_avg_dist_day_ratio,
      pva_off_day_ratio              = x.avg_pva_off_day_ratio,
      sa_avg_dist_day_ratio          = x.avg_sa_avg_dist_day_ratio,
      sa_off_day_ratio               = x.avg_sa_off_day_ratio,
      wca_avg_dist_day_ratio         = x.avg_wca_avg_dist_day_ratio,
      wca_off_day_ratio              = x.avg_wca_off_day_ratio,
      wea_avg_dist_day_ratio         = x.avg_wea_avg_dist_day_ratio,
      wea_off_day_ratio              = x.avg_wea_off_day_ratio,
      wta_avg_dist_day_ratio         = x.avg_wta_avg_dist_day_ratio,
      wta_off_day_ratio              = x.avg_wta_off_day_ratio,
      wtmtlpb_avg_dist_day_ratio     = x.avg_wtmtlpb_avg_dist_day_ratio,
      wtmtlpb_off_day_ratio          = x.avg_wtmtlpb_off_day_ratio,
      wtmtlpf_avg_dist_day_ratio     = x.avg_wtmtlpf_avg_dist_day_ratio,
      wtmtlpf_off_day_ratio          = x.avg_wtmtlpf_off_day_ratio,
      wtsbmt_avg_dist_day_ratio      = x.avg_wtsbmt_avg_dist_day_ratio,
      wtsbmt_off_day_ratio           = x.avg_wtsbmt_off_day_ratio,
      wtsfmt_avg_dist_day_ratio      = x.avg_wtsfmt_avg_dist_day_ratio,
      wtsfmt_off_day_ratio           = x.avg_wtsfmt_off_day_ratio,
      wtsfrtalbp_avg_dist_day_ratio  = x.avg_wtsfrtalbp_avg_dist_day_ratio,
      wtsfrtalbp_off_day_ratio       = x.avg_wtsfrtalbp_off_day_ratio,
      wtsfsp_avg_dist_day_ratio      = x.avg_wtsfsp_avg_dist_day_ratio,
      wtsfsp_off_day_ratio           = x.avg_wtsfsp_off_day_ratio,
      wva_avg_dist_day_ratio         = x.avg_wva_avg_dist_day_ratio,
      wva_off_day_ratio              = x.avg_wva_off_day_ratio
FROM 
(
    SELECT   b.tool_id, 
             b.day, 
             avg(b.ftsit_avg_dist_day_ratio)       as avg_ftsit_avg_dist_day_ratio,
             avg(b.ftsit_off_day_ratio)            as avg_ftsit_off_day_ratio,
             avg(b.dta_avg_dist_day_ratio)         as avg_dta_avg_dist_day_ratio,
             avg(b.dta_off_day_ratio)              as avg_dta_off_day_ratio,
             avg(b.fta_avg_dist_day_ratio)         as avg_fta_avg_dist_day_ratio,
             avg(b.fta_off_day_ratio)              as avg_fta_off_day_ratio,
             avg(b.lmlha_avg_dist_day_ratio)       as avg_lmlha_avg_dist_day_ratio,
             avg(b.lmlha_off_day_ratio)            as avg_lmlha_off_day_ratio,
             avg(b.lmpa_avg_dist_day_ratio)        as avg_lmpa_avg_dist_day_ratio,
             avg(b.lmpa_off_day_ratio)             as avg_lmpa_off_day_ratio,
             avg(b.pva_avg_dist_day_ratio)         as avg_pva_avg_dist_day_ratio,
             avg(b.pva_off_day_ratio)              as avg_pva_off_day_ratio,
             avg(b.sa_avg_dist_day_ratio)          as avg_sa_avg_dist_day_ratio,
             avg(b.sa_off_day_ratio)               as avg_sa_off_day_ratio,
             avg(b.wca_avg_dist_day_ratio)         as avg_wca_avg_dist_day_ratio,
             avg(b.wca_off_day_ratio)              as avg_wca_off_day_ratio,
             avg(b.wea_avg_dist_day_ratio)         as avg_wea_avg_dist_day_ratio,
             avg(b.wea_off_day_ratio)              as avg_wea_off_day_ratio,
             avg(b.wta_avg_dist_day_ratio)         as avg_wta_avg_dist_day_ratio,
             avg(b.wta_off_day_ratio)              as avg_wta_off_day_ratio,
             avg(b.wtmtlpb_avg_dist_day_ratio)     as avg_wtmtlpb_avg_dist_day_ratio,
             avg(b.wtmtlpb_off_day_ratio)          as avg_wtmtlpb_off_day_ratio,
             avg(b.wtmtlpf_avg_dist_day_ratio)     as avg_wtmtlpf_avg_dist_day_ratio,
             avg(b.wtmtlpf_off_day_ratio)          as avg_wtmtlpf_off_day_ratio,
             avg(b.wtsbmt_avg_dist_day_ratio)      as avg_wtsbmt_avg_dist_day_ratio,
             avg(b.wtsbmt_off_day_ratio)           as avg_wtsbmt_off_day_ratio,
             avg(b.wtsfmt_avg_dist_day_ratio)      as avg_wtsfmt_avg_dist_day_ratio,
             avg(b.wtsfmt_off_day_ratio)           as avg_wtsfmt_off_day_ratio,
             avg(b.wtsfrtalbp_avg_dist_day_ratio)  as avg_wtsfrtalbp_avg_dist_day_ratio,
             avg(b.wtsfrtalbp_off_day_ratio)       as avg_wtsfrtalbp_off_day_ratio,
             avg(b.wtsfsp_avg_dist_day_ratio)      as avg_wtsfsp_avg_dist_day_ratio,
             avg(b.wtsfsp_off_day_ratio)           as avg_wtsfsp_off_day_ratio,
             avg(b.wva_avg_dist_day_ratio)         as avg_wva_avg_dist_day_ratio,
             avg(b.wva_off_day_ratio)              as avg_wva_off_day_ratio
      FROM tse_tool_diff_offlimits b
    group by b.tool_id, b.day
) x 
WHERE a.tool_id = x.tool_id and
      a.day = x.day;


------------------------------------------------------------------------------------------
------------------ AVG DIFF AND OFFLIMITS
------------------------------------------------------------------------------------------
UPDATE health_index_mlr3 a set ftsit_avg_dist_avg_ratio      = (select avg(x.ftsit_avg_dist_day_ratio)      from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set ftsit_off_avg_ratio           = (select avg(x.ftsit_off_day_ratio)           from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set dta_avg_dist_avg_ratio        = (select avg(x.dta_avg_dist_day_ratio)        from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set dta_off_avg_ratio             = (select avg(x.dta_off_day_ratio)             from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set fta_avg_dist_avg_ratio        = (select avg(x.fta_avg_dist_day_ratio)        from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set fta_off_avg_ratio             = (select avg(x.fta_off_day_ratio)             from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set lmlha_avg_dist_avg_ratio      = (select avg(x.lmlha_avg_dist_day_ratio)      from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set lmlha_off_avg_ratio           = (select avg(x.lmlha_off_day_ratio)           from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set lmpa_avg_dist_avg_ratio       = (select avg(x.lmpa_avg_dist_day_ratio)       from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set lmpa_off_avg_ratio            = (select avg(x.lmpa_off_day_ratio)            from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set pva_avg_dist_avg_ratio        = (select avg(x.pva_avg_dist_day_ratio)        from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set pva_off_avg_ratio             = (select avg(x.pva_off_day_ratio)             from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set sa_avg_dist_avg_ratio         = (select avg(x.sa_avg_dist_day_ratio)         from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set sa_off_avg_ratio              = (select avg(x.sa_off_day_ratio)              from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wca_avg_dist_avg_ratio        = (select avg(x.wca_avg_dist_day_ratio)        from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wca_off_avg_ratio             = (select avg(x.wca_off_day_ratio)             from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wea_avg_dist_avg_ratio        = (select avg(x.wea_avg_dist_day_ratio)        from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wea_off_avg_ratio             = (select avg(x.wea_off_day_ratio)             from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wta_avg_dist_avg_ratio        = (select avg(x.wta_avg_dist_day_ratio)        from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wta_off_avg_ratio             = (select avg(x.wta_off_day_ratio)             from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtmtlpb_avg_dist_avg_ratio    = (select avg(x.wtmtlpb_avg_dist_day_ratio)    from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtmtlpb_off_avg_ratio         = (select avg(x.wtmtlpb_off_day_ratio)         from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtmtlpf_avg_dist_avg_ratio    = (select avg(x.wtmtlpf_avg_dist_day_ratio)    from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtmtlpf_off_avg_ratio         = (select avg(x.wtmtlpf_off_day_ratio)         from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtsbmt_avg_dist_avg_ratio     = (select avg(x.wtsbmt_avg_dist_day_ratio)     from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtsbmt_off_avg_ratio          = (select avg(x.wtsbmt_off_day_ratio)          from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtsfmt_avg_dist_avg_ratio     = (select avg(x.wtsfmt_avg_dist_day_ratio)     from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtsfmt_off_avg_ratio          = (select avg(x.wtsfmt_off_day_ratio)          from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtsfrtalbp_avg_dist_avg_ratio = (select avg(x.wtsfrtalbp_avg_dist_day_ratio) from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtsfrtalbp_off_avg_ratio      = (select avg(x.wtsfrtalbp_off_day_ratio)      from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtsfsp_avg_dist_avg_ratio     = (select avg(x.wtsfsp_avg_dist_day_ratio)     from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wtsfsp_off_avg_ratio          = (select avg(x.wtsfsp_off_day_ratio)          from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wva_avg_dist_avg_ratio        = (select avg(x.wva_avg_dist_day_ratio)        from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);
UPDATE health_index_mlr3 a set wva_off_avg_ratio             = (select avg(x.wva_off_day_ratio)             from tse_tool_diff_offlimits x where x.tool_id = a.tool_id and x.day >= a.day - interval '7 DAY' and x.day < a.day);


------------------------------------------------------------------------------------------
------------------ OBJECTIVE FIELDS
------------------------------------------------------------------------------------------

-- 3_lower_health_7days?
update health_index_mlr3 a set "3_lower_health_7days?" = (select case when count(*) >= 3 then 'YES' else 'NO' end from health_index b where b.tool_id = a.tool_id and b.day > a.day and b.day <= a.day + INTERVAL '7 DAY' and b.health < a.health);
-- 3_under_100_7days?
update health_index_mlr3 a set "3_under_100_7days?" = (select case when count(*) >= 3 then 'YES' else 'NO' end from health_index b where b.tool_id = a.tool_id and b.day > a.day and b.day <= a.day + INTERVAL '7 DAY' and b.health < 1);
-- 6_lower_health_14days?
update health_index_mlr3 a set "6_lower_health_14days?" = (select case when count(*) >= 6 then 'YES' else 'NO' end from health_index b where b.tool_id = a.tool_id and b.day > a.day and b.day <= a.day + INTERVAL '14 DAY' and b.health < a.health);
-- 6_under_100_14days?
update health_index_mlr3 a set "6_under_100_14days?" = (select case when count(*) >= 6 then 'YES' else 'NO' end from health_index b where b.tool_id = a.tool_id and b.day > a.day and b.day <= a.day + INTERVAL '14 DAY' and b.health < 1);

