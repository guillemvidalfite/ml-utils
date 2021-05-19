
##select a.tool_stud_ext, b.repaired_at, b.error_code, count(1)
##from imp_hits_all a, tmp_repaired_studs b
##where a.stud_id = b.stud_id and
##      a.carbody_id = b.carbody_id and 
##      extract(month from a.timestamp) >= 8 and extract(month from a.timestamp) <= 9 and
##      a.tool_stud_ext in
##('050-213-Z1-UB63-080-100-101-1.1-610631_213_1_1_1_2_1_1',
##'050-213-Z1-UB63-140-300-301-1.1-620480_213_3_1_1_2_1_1')
##group by a.tool_stud_ext, b.repaired_at, b.error_code;



--a.tool_stud_ext
-- select all extensions with both repairs in both training and test with at least 100 training welda
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 5 and extract(month from a.timestamp) <= 7 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
	(select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 5 and extract(month from b.timestamp) <= 7 group by b.tool_stud_ext having count(1) > 100) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 8 and extract(month from a.timestamp) <= 9 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext);






-- same with different period
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 6 and extract(month from a.timestamp) <= 8 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
    (select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 6 and extract(month from b.timestamp) <= 8 group by b.tool_stud_ext having count(1) between 1000 and 9000) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 8 and extract(month from a.timestamp) <= 9 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))




-- TRAIN AUG-OCT vs TEST NOV
-- select all extensions with both repairs in both training and test with at least 100 training welda
(select a.tool_stud_ext
from imp_hits_all a
where a.timestamp >= '2020-08-01' and a.timestamp < '2020-11-01' and
       exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    b.repaired_at is not null and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint) and
                    (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000'))))
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
    (select b.tool_stud_ext, count(1) from imp_hits_all b where b.timestamp >= '2020-08-01' and b.timestamp < '2020-11-01' group by b.tool_stud_ext having count(1) > 400) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where a.timestamp >= '2020-11-01' and a.timestamp < '2020-12-01' and
      exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    b.repaired_at is not null and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint) and
                   (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000'))))
group by a.tool_stud_ext);

-- candi
(select tool_stud_ext
from imp_hits_all a
where timestamp between '2020-08-01' and '2020-11-01' and
      exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint) and
                    (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000'))))
group by tool_stud_ext)
intersect
(select tool_stud_ext from imp_hits_all where timestamp between '2020-08-01' and '2020-11-01' group by tool_stud_ext having count(1) > 400)
intersect
(select tool_stud_ext
from imp_hits_all a
where timestamp between '2020-11-01' and '2020-12-01' and
      exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint) and 
                    (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000'))))
group by tool_stud_ext);


-- TRAIN OCT-DEC vs TEST JAN
-- select all extensions with both repairs in both training and test with at least 100 training welda
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    a.timestamp >= '2020-10-01' and a.timestamp < '2021-01-01' and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
    (select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 5 and extract(month from b.timestamp) <= 7 group by b.tool_stud_ext having count(1) > 400) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    a.timestamp >= '2021-01-01' and a.timestamp < '2021-02-01' and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext);





-- TRAIN OCT-DEC vs TEST JAN
-- select all extensions with both repairs in both training and test with at least 100 training welds
(select a.tool_stud_ext
from imp_hits_all a
where a.timestamp >= '2020-10-01' and a.timestamp < '2021-01-01' and
      exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    b.repaired_at is not null and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint) and
                    (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000')))) and
      not exists (select 1 from imp_conf_changes_all_tses c where c.timestamp >= '2020-10-01' and c.timestamp < '2021-01-01' and 
                                                                  c.tool_stud_ext = a.tool_stud_ext)
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
    (select b.tool_stud_ext, count(1) from imp_hits_all b where b.timestamp >= '2020-10-01' and b.timestamp < '2021-01-01' group by b.tool_stud_ext having count(1) > 500) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where a.timestamp >= '2021-01-01' and a.timestamp < '2021-02-01' and
      exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    b.repaired_at is not null and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint) and
                   (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000')))) and
      not exists (select 1 from imp_conf_changes_all_tses c where c.timestamp >= '2021-01-01' and c.timestamp < '2021-02-01' and 
                                                          c.tool_stud_ext = a.tool_stud_ext)
group by a.tool_stud_ext);

select distinct a.tool_stud_ext from imp_conf_changes a where 
not exists (select 1 from imp_conf_changes b where a.tool_stud_ext = b.tool_stud_ext and b.timestamp >= '2020-10-01' and b.timestamp < '2021-02-01');




-- TRAIN OCT-DEC vs TEST JAN
-- select all extensions with both repairs in both training and test with at least 100 training welds
(select a.tool_stud_ext
from imp_hits_all a
where a.timestamp >= '2020-10-01' and a.timestamp < '2021-01-01' and
      exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    b.repaired_at is not null and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint) and
                    (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000'))))
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
    (select b.tool_stud_ext, count(1) from imp_hits_all b where b.timestamp >= '2020-10-01' and b.timestamp < '2021-01-01' group by b.tool_stud_ext having count(1) > 3000) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where a.timestamp >= '2021-01-01' and a.timestamp < '2021-02-01' and
      exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    b.repaired_at is not null and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint) and
                   (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000'))))
group by a.tool_stud_ext);