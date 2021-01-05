
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
---EXTENSION_AGGREGATED
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
drop table if exists extension_aggregated;
create table extension_aggregated(
	extension_id      varchar(100),
	welds_count       numeric,
	wops_count        numeric,
    ftsit_avg         numeric,
    ftsit_top         numeric,
    ftsit_bottom      numeric,
    dta_avg           numeric,
    dta_top           numeric,
    dta_bottom        numeric,
    fta_avg           numeric,
    fta_top           numeric,
    fta_bottom        numeric,
    lmlha_avg         numeric,
    lmlha_top         numeric,
    lmlha_bottom      numeric,
    lmpa_avg          numeric,
    lmpa_top          numeric,
    lmpa_bottom       numeric,
    pva_avg           numeric,
    pva_top           numeric,
    pva_bottom        numeric,
    sa_avg            numeric,
    sa_top            numeric,
    sa_bottom         numeric,
    wca_avg           numeric,
    wca_top           numeric,
    wca_bottom        numeric,
    wea_avg           numeric,
    wea_top           numeric,
    wea_bottom        numeric,
    wta_avg           numeric,
    wta_top           numeric,
    wta_bottom        numeric,
    wtmtlpb_avg       numeric,
    wtmtlpb_top       numeric,
    wtmtlpb_bottom    numeric,
    wtmtlpf_avg       numeric,
    wtmtlpf_top       numeric,
    wtmtlpf_bottom    numeric,
    wtsbmt_avg        numeric,
    wtsbmt_top        numeric,
    wtsbmt_bottom     numeric,
    wtsfmt_avg        numeric,
    wtsfmt_top        numeric,
    wtsfmt_bottom     numeric,
    wtsfrtalbp_avg    numeric,
    wtsfrtalbp_top    numeric,
    wtsfrtalbp_bottom numeric,
    wtsfsp_avg        numeric,
    wtsfsp_top        numeric,
    wtsfsp_bottom     numeric,
    wva_avg           numeric,
    wva_top           numeric,
    wva_bottom        numeric
);


insert into extension_aggregated
select a.extension_id, 
       sum(weld_count), 
       sum(wops_count), 
       round(avg(a.ftsit_avg),4),
       round(avg(a.ftsit_avg) + 2*stddev(a.ftsit_avg),4),
       round(avg(a.ftsit_avg) - 2*stddev(a.ftsit_avg),4),
       round(avg(a.dta_avg),4),
       round(avg(a.dta_avg) + 2*stddev(a.dta_avg),4),
       round(avg(a.dta_avg) - 2*stddev(a.dta_avg),4),
       round(avg(a.fta_avg),4),
       round(avg(a.fta_avg) + 2*stddev(a.fta_avg),4),
       round(avg(a.fta_avg) - 2*stddev(a.fta_avg),4),
       round(avg(a.lmlha_avg),4),
       round(avg(a.lmlha_avg) + 2*stddev(a.lmlha_avg),4),
       round(avg(a.lmlha_avg) - 2*stddev(a.lmlha_avg),4),
       round(avg(a.lmpa_avg),4),
       round(avg(a.lmpa_avg) + 2*stddev(a.lmpa_avg),4),
       round(avg(a.lmpa_avg) - 2*stddev(a.lmpa_avg),4),
       round(avg(a.pva_avg),4),
       round(avg(a.pva_avg) + 2*stddev(a.pva_avg),4),
       round(avg(a.pva_avg) - 2*stddev(a.pva_avg),4),
       round(avg(a.sa_avg),4),
       round(avg(a.sa_avg) + 2*stddev(a.sa_avg),4),
       round(avg(a.sa_avg) - 2*stddev(a.sa_avg),4),
       round(avg(a.wca_avg),4),
       round(avg(a.wca_avg) + 2*stddev(a.wca_avg),4),
       round(avg(a.wca_avg) - 2*stddev(a.wca_avg),4),
       round(avg(a.wea_avg),4),
       round(avg(a.wea_avg) + 2*stddev(a.wea_avg),4),
       round(avg(a.wea_avg) - 2*stddev(a.wea_avg),4),
       round(avg(a.wta_avg),4),
       round(avg(a.wta_avg) + 2*stddev(a.wta_avg),4),
       round(avg(a.wta_avg) - 2*stddev(a.wta_avg),4),
       round(avg(a.wtmtlpb_avg),4),
       round(avg(a.wtmtlpb_avg) + 2*stddev(a.wtmtlpb_avg),4),
       round(avg(a.wtmtlpb_avg) - 2*stddev(a.wtmtlpb_avg),4),
       round(avg(a.wtmtlpf_avg),4),
       round(avg(a.wtmtlpf_avg) + 2*stddev(a.wtmtlpf_avg),4),
       round(avg(a.wtmtlpf_avg) - 2*stddev(a.wtmtlpf_avg),4),
       round(avg(a.wtsbmt_avg),4),
       round(avg(a.wtsbmt_avg) + 2*stddev(a.wtsbmt_avg),4),
       round(avg(a.wtsbmt_avg) - 2*stddev(a.wtsbmt_avg),4),
       round(avg(a.wtsfmt_avg),4),
       round(avg(a.wtsfmt_avg) + 2*stddev(a.wtsfmt_avg),4),
       round(avg(a.wtsfmt_avg) - 2*stddev(a.wtsfmt_avg),4),
       round(avg(a.wtsfrtalbp_avg),4),
       round(avg(a.wtsfrtalbp_avg) + 2*stddev(a.wtsfrtalbp_avg),4),
       round(avg(a.wtsfrtalbp_avg) - 2*stddev(a.wtsfrtalbp_avg),4),
       round(avg(a.wtsfsp_avg),4),
       round(avg(a.wtsfsp_avg) + 2*stddev(a.wtsfsp_avg),4),
       round(avg(a.wtsfsp_avg) - 2*stddev(a.wtsfsp_avg),4),
       round(avg(a.wva_avg),4),
       round(avg(a.wva_avg) + 2*stddev(a.wva_avg),4),
       round(avg(a.wva_avg) - 2*stddev(a.wva_avg),4)
from tse_health_index a
where a.health > 0.9
group by a.extension_id;

create index inx_extensionaggregated_extid on extension_aggregated(extension_id);

----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
--- tse_tool_diff_offlimits
----------------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------------
drop table if exists tse_tool_diff_offlimits;
create table tse_tool_diff_offlimits(
	tool_id                      varchar(100),
	extension_id                 varchar(100),
	day                          date,
	ftsit_avg_dist_day_ratio         numeric,
    ftsit_off_day_ratio              numeric,
    dta_avg_dist_day_ratio           numeric,
    dta_off_day_ratio                numeric,
    fta_avg_dist_day_ratio           numeric,
    fta_off_day_ratio                numeric,
    lmlha_avg_dist_day_ratio         numeric,
    lmlha_off_day_ratio              numeric,
    lmpa_avg_dist_day_ratio          numeric,
    lmpa_off_day_ratio               numeric,
    pva_avg_dist_day_ratio           numeric,
    pva_off_day_ratio                numeric,
    sa_avg_dist_day_ratio            numeric,
    sa_off_day_ratio                 numeric,
    wca_avg_dist_day_ratio           numeric,
    wca_off_day_ratio                numeric,
    wea_avg_dist_day_ratio           numeric,
    wea_off_day_ratio                numeric,
    wta_avg_dist_day_ratio           numeric,
    wta_off_day_ratio                numeric,
    wtmtlpb_avg_dist_day_ratio       numeric,
    wtmtlpb_off_day_ratio            numeric,
    wtmtlpf_avg_dist_day_ratio       numeric,
    wtmtlpf_off_day_ratio            numeric,
    wtsbmt_avg_dist_day_ratio        numeric,
    wtsbmt_off_day_ratio             numeric,
    wtsfmt_avg_dist_day_ratio        numeric,
    wtsfmt_off_day_ratio             numeric,
    wtsfrtalbp_avg_dist_day_ratio    numeric,
    wtsfrtalbp_off_day_ratio         numeric,
    wtsfsp_avg_dist_day_ratio        numeric,
    wtsfsp_off_day_ratio             numeric,
    wva_avg_dist_day_ratio           numeric,
    wva_off_day_ratio                numeric
);

insert into tse_tool_diff_offlimits(
	tool_id,
    extension_id,
    day,
    ftsit_avg_dist_day_ratio,
    ftsit_off_day_ratio,
    dta_avg_dist_day_ratio,
    dta_off_day_ratio,
    fta_avg_dist_day_ratio,
    fta_off_day_ratio,
    lmlha_avg_dist_day_ratio,
    lmlha_off_day_ratio,
    lmpa_avg_dist_day_ratio,
    lmpa_off_day_ratio,
    pva_avg_dist_day_ratio,
    pva_off_day_ratio,
    sa_avg_dist_day_ratio,
    sa_off_day_ratio,
    wca_avg_dist_day_ratio,
    wca_off_day_ratio,
    wea_avg_dist_day_ratio,
    wea_off_day_ratio,
    wta_avg_dist_day_ratio,
    wta_off_day_ratio,
    wtmtlpb_avg_dist_day_ratio,
    wtmtlpb_off_day_ratio,
    wtmtlpf_avg_dist_day_ratio,
    wtmtlpf_off_day_ratio,
    wtsbmt_avg_dist_day_ratio,
    wtsbmt_off_day_ratio,
    wtsfmt_avg_dist_day_ratio,
    wtsfmt_off_day_ratio,
    wtsfrtalbp_avg_dist_day_ratio,
    wtsfrtalbp_off_day_ratio,
    wtsfsp_avg_dist_day_ratio,
    wtsfsp_off_day_ratio,
    wva_avg_dist_day_ratio,
    wva_off_day_ratio
)
select a.tool_id,
       a.extension_id,
       a.day,
       case a.ftsit_avg when 0 then 0 else round((a.ftsit_avg - b.ftsit_avg)/abs(b.ftsit_avg),6) end,
       case when a.ftsit_avg > b.ftsit_top    then round((a.ftsit_avg - b.ftsit_top)/abs(b.ftsit_top - b.ftsit_avg),6) 
            when a.ftsit_avg < b.ftsit_bottom then round((b.ftsit_bottom - a.ftsit_avg)/abs(b.ftsit_avg - b.ftsit_bottom),6)
            else 0 end,
       case a.dta_avg when 0 then 0 else round((a.dta_avg - b.dta_avg)/abs(b.dta_avg),6) end,
       case when a.dta_avg > b.dta_top    then round((a.dta_avg - b.dta_top)/abs(b.dta_top - b.dta_avg),6) 
            when a.dta_avg < b.dta_bottom then round((b.dta_bottom - a.dta_avg)/abs(b.dta_avg - b.dta_bottom),6)
            else 0 end,
       case a.fta_avg when 0 then 0 else round((a.fta_avg - b.fta_avg)/abs(b.fta_avg),6) end,
       case when a.fta_avg > b.fta_top    then round((a.fta_avg - b.fta_top)/abs(b.fta_top - b.fta_avg),6) 
            when a.fta_avg < b.fta_bottom then round((b.fta_bottom - a.fta_avg)/abs(b.fta_avg - b.fta_bottom),6)
            else 0 end,
       case a.lmlha_avg when 0 then 0 else round((a.lmlha_avg - b.lmlha_avg)/abs(b.lmlha_avg),6) end,
       case when a.lmlha_avg > b.lmlha_top    then round((a.lmlha_avg - b.lmlha_top)/abs(b.lmlha_top - b.lmlha_avg),6) 
            when a.lmlha_avg < b.lmlha_bottom then round((b.lmlha_bottom - a.lmlha_avg)/abs(b.lmlha_avg - b.lmlha_bottom),6)
            else 0 end,
       case a.lmpa_avg when 0 then 0 else round((a.lmpa_avg - b.lmpa_avg)/abs(b.lmpa_avg),6) end,
       case when a.lmpa_avg > b.lmpa_top    then round((a.lmpa_avg - b.lmpa_top)/abs(b.lmpa_top - b.lmpa_avg),6) 
            when a.lmpa_avg < b.lmpa_bottom then round((b.lmpa_bottom - a.lmpa_avg)/abs(b.lmpa_avg - b.lmpa_bottom),6)
            else 0 end,
       case a.pva_avg when 0 then 0 else round((a.pva_avg - b.pva_avg)/abs(b.pva_avg),6) end,
       case when a.pva_avg > b.pva_top    then round((a.pva_avg - b.pva_top)/abs(b.pva_top - b.pva_avg),6) 
            when a.pva_avg < b.pva_bottom then round((b.pva_bottom - a.pva_avg)/abs(b.pva_avg - b.pva_bottom),6)
            else 0 end,
       case a.sa_avg when 0 then 0 else round((a.sa_avg - b.sa_avg)/abs(b.sa_avg),6) end,
       case when a.sa_avg > b.sa_top    then round((a.sa_avg - b.sa_top)/abs(b.sa_top - b.sa_avg),6) 
            when a.sa_avg < b.sa_bottom then round((b.sa_bottom - a.sa_avg)/abs(b.sa_avg - b.sa_bottom),6)
            else 0 end,
       case a.wca_avg when 0 then 0 else round((a.wca_avg - b.wca_avg)/abs(b.wca_avg),6) end,
       case when a.wca_avg > b.wca_top    then round((a.wca_avg - b.wca_top)/abs(b.wca_top - b.wca_avg),6) 
            when a.wca_avg < b.wca_bottom then round((b.wca_bottom - a.wca_avg)/abs(b.wca_avg - b.wca_bottom),6)
            else 0 end,
       case a.wea_avg when 0 then 0 else round((a.wea_avg - b.wea_avg)/abs(b.wea_avg),6) end,
       case when a.wea_avg > b.wea_top    then round((a.wea_avg - b.wea_top)/abs(b.wea_top - b.wea_avg),6) 
            when a.wea_avg < b.wea_bottom then round((b.wea_bottom - a.wea_avg)/abs(b.wea_avg - b.wea_bottom),6)
            else 0 end,
       case a.wta_avg when 0 then 0 else round((a.wta_avg - b.wta_avg)/abs(b.wta_avg),6) end,
       case when a.wta_avg > b.wta_top    then round((a.wta_avg - b.wta_top)/abs(b.wta_top - b.wta_avg),6) 
            when a.wta_avg < b.wta_bottom then round((b.wta_bottom - a.wta_avg)/abs(b.wta_avg - b.wta_bottom),6)
            else 0 end,
       case a.wtmtlpb_avg when 0 then 0 else round((a.wtmtlpb_avg - b.wtmtlpb_avg)/abs(b.wtmtlpb_avg),6) end,
       case when a.wtmtlpb_avg > b.wtmtlpb_top    then round((a.wtmtlpb_avg - b.wtmtlpb_top)/abs(b.wtmtlpb_top - b.wtmtlpb_avg),6) 
            when a.wtmtlpb_avg < b.wtmtlpb_bottom then round((b.wtmtlpb_bottom - a.wtmtlpb_avg)/abs(b.wtmtlpb_avg - b.wtmtlpb_bottom),6)
            else 0 end,
       case a.wtmtlpf_avg when 0 then 0 else round((a.wtmtlpf_avg - b.wtmtlpf_avg)/abs(b.wtmtlpf_avg),6) end,
       case when a.wtmtlpf_avg > b.wtmtlpf_top    then round((a.wtmtlpf_avg - b.wtmtlpf_top)/abs(b.wtmtlpf_top - b.wtmtlpf_avg),6) 
            when a.wtmtlpf_avg < b.wtmtlpf_bottom then round((b.wtmtlpf_bottom - a.wtmtlpf_avg)/abs(b.wtmtlpf_avg - b.wtmtlpf_bottom),6)
            else 0 end,
       case a.wtsbmt_avg when 0 then 0 else round((a.wtsbmt_avg - b.wtsbmt_avg)/abs(b.wtsbmt_avg),6) end,
       case when a.wtsbmt_avg > b.wtsbmt_top    then round((a.wtsbmt_avg - b.wtsbmt_top)/abs(b.wtsbmt_top - b.wtsbmt_avg),6) 
            when a.wtsbmt_avg < b.wtsbmt_bottom then round((b.wtsbmt_bottom - a.wtsbmt_avg)/abs(b.wtsbmt_avg - b.wtsbmt_bottom),6)
            else 0 end,
       case a.wtsfmt_avg when 0 then 0 else round((a.wtsfmt_avg - b.wtsfmt_avg)/abs(b.wtsfmt_avg),6) end,
       case when a.wtsfmt_avg > b.wtsfmt_top    then round((a.wtsfmt_avg - b.wtsfmt_top)/abs(b.wtsfmt_top - b.wtsfmt_avg),6) 
            when a.wtsfmt_avg < b.wtsfmt_bottom then round((b.wtsfmt_bottom - a.wtsfmt_avg)/abs(b.wtsfmt_avg - b.wtsfmt_bottom),6)
            else 0 end,
       case a.wtsfrtalbp_avg when 0 then 0 else round((a.wtsfrtalbp_avg - b.wtsfrtalbp_avg)/abs(b.wtsfrtalbp_avg),6) end,
       case when a.wtsfrtalbp_avg > b.wtsfrtalbp_top    then round((a.wtsfrtalbp_avg - b.wtsfrtalbp_top)/abs(b.wtsfrtalbp_top - b.wtsfrtalbp_avg),6) 
            when a.wtsfrtalbp_avg < b.wtsfrtalbp_bottom then round((b.wtsfrtalbp_bottom - a.wtsfrtalbp_avg)/abs(b.wtsfrtalbp_avg - b.wtsfrtalbp_bottom),6)
            else 0 end,
       case b.wtsfsp_avg when 0 then 0 else round((a.wtsfsp_avg - b.wtsfsp_avg)/abs(b.wtsfsp_avg),6) end,
       case when a.wtsfsp_avg > b.wtsfsp_top    then round((a.wtsfsp_avg - b.wtsfsp_top)/abs(b.wtsfsp_top - b.wtsfsp_avg),6) 
            when a.wtsfsp_avg < b.wtsfsp_bottom then round((b.wtsfsp_bottom - a.wtsfsp_avg)/abs(b.wtsfsp_avg - b.wtsfsp_bottom),6)
            else 0 end,
       case b.wva_avg when 0 then 0 else round((a.wva_avg - b.wva_avg)/abs(b.wva_avg),6) end,
       case when a.wva_avg > b.wva_top    then round((a.wva_avg - b.wva_top)/abs(b.wva_top - b.wva_avg),6) 
            when a.wva_avg < b.wva_bottom then round((b.wva_bottom - a.wva_avg)/abs(b.wva_avg - b.wva_bottom),6)
            else 0 end
from tse_health_index a, extension_aggregated b
where a.extension_id = b.extension_id;




