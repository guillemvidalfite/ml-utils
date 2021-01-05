
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
                    extract(month from a.timestamp) >= 2 and extract(month from a.timestamp) <= 7 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
    (select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 2 and extract(month from b.timestamp) <= 7 group by b.tool_stud_ext having count(1) > 4000) x)
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
