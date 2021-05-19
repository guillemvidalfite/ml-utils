-- 1+ repair in training 1+ in test with 1000/10000 training welds
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
    (select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 6 and extract(month from b.timestamp) <= 8 group by b.tool_stud_ext having count(1) between 1000 and 9999) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 9 and extract(month from a.timestamp) <= 10 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext);


select a.tool_stud_ext, count(1) 
from imp_hits_all a
where extract(month from a.timestamp) >= 6 and extract(month from a.timestamp) <= 8 and
      a.tool_stud_ext in ('050-223-Z1-UB73-100-200-201-1.1-6200219_223_4_1_0_1_1_1',
                          '050-223-Z1-UB74-030-100-101-1.1-6100558_223_4_1_0_1_1_1',
                          '050-223-Z1-UB73-100-200-201-1.1-6200105_223_4_1_0_1_1_1',
                          '050-223-Z1-UB73-100-400-401-1.1-6100728_223_4_1_0_1_1_1')
group by a.tool_stud_ext;




/* 32 - 

050-213-Z1-UB63-100-200-201-1.1-620590_213_1_1_1_2_1_2
050-213-Z1-UB63-080-100-101-1.1-610665_213_1_1_1_1_1_1
050-213-Z1-UB64-120-200-201-2.1-620773_213_1_1_1_1_1_1
050-213-Z1-UB64-120-200-201-2.1-611219_213_1_1_1_2_1_1
050-213-Z1-UB64-170-100-101-1.1-610598_213_1_1_1_2_1_1
050-213-Z1-UB64-130-200-201-2.1-620772_213_1_1_1_2_1_2
050-213-Z1-UB63-090-100-101-1.1-610648_213_1_1_1_2_1_2
050-213-Z1-UB64-130-200-201-2.1-611219_213_1_1_1_1_1_2
050-213-Z1-UB63-070-100-101-1.1-610748_213_1_1_1_2_1_1
050-213-Z1-UB64-060-200-201-1.1-610492_213_1_1_1_1_1_2
050-213-Z1-UB63-080-100-101-1.1-610871_213_3_1_1_2_1_1
050-213-Z1-UB63-140-200-201-1.1-620406_213_1_1_1_1_1_1
-----050-223-Z1-UB73-100-200-201-1.1-6200219_223_4_1_0_1_1_1
-----050-223-Z1-UB73-100-400-401-1.1-6100728_223_4_1_0_1_1_1
050-213-Z1-UB64-040-200-201-2.1-620776_213_1_1_1_2_1_1
050-213-Z1-UB64-160-100-101-1.1-610598_213_1_1_1_2_1_2
050-213-Z1-UB63-130-100-101-1.1-620556_213_1_1_1_1_1_1
050-213-Z1-UB63-080-100-101-1.1-610631_213_1_1_1_2_1_1
050-213-Z1-UB64-030-400-401-2.1-610760_213_1_1_1_2_1_1
-----050-223-Z2-RS75-080-400-401-1.1-6300075_223_4_1_3_1_1_1
050-213-Z1-UB63-090-100-101-1.1-610665_213_1_1_1_1_1_2
050-213-Z1-UB63-140-300-301-1.1-620496_213_1_1_1_2_1_1
050-213-Z1-UB64-140-100-101-1.1-620669_213_1_1_1_1_1_2
050-213-Z1-UB64-130-200-201-2.1-611219_213_3_1_1_2_1_2
050-213-Z1-UB63-090-100-101-1.1-610871_213_3_1_1_2_1_2
050-213-Z1-UB63-140-200-201-1.1-620504_213_3_1_1_2_1_1
050-213-Z1-UB64-130-200-201-2.1-620772_213_1_1_1_1_1_2
050-213-Z1-UB63-140-300-301-1.1-620420_213_1_1_1_2_1_1
050-213-Z1-UB63-130-100-101-2.1-610813_213_1_1_1_1_1_1
-----050-223-Z1-UB73-100-200-201-1.1-6200105_223_4_1_0_1_1_1
050-213-Z1-UB63-140-300-301-1.1-620420_213_1_1_1_1_1_1
050-213-Z1-UB63-140-300-301-1.1-620480_213_3_1_1_2_1_1

*/

-- 1+ repair in training with 400/1000 welds and 1+ repair in test
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
    (select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 6 and extract(month from b.timestamp) <= 8 group by b.tool_stud_ext having count(1) between 400 and 1000) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 9 and extract(month from a.timestamp) <= 10 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext);


/* 7 
-----050-223-Z1-UB75-020-500-501-1.1-6100369_223_4_1_3_1_1_1
050-213-Z1-UB63-140-200-201-1.1-620422_213_1_2_1_1_1_1
-----050-223-Z1-UB75-020-500-501-1.1-6100437_223_4_1_3_1_1_1
-----050-223-Z1-UB75-030-300-301-1.1-6100123_223_4_1_3_1_1_2
-----050-223-Z1-UB74-030-100-101-1.1-6100558_223_4_1_0_1_1_1
050-213-Z1-UB63-140-300-301-1.1-620408_213_1_2_1_2_1_1
-----050-223-Z1-UB75-020-500-501-1.1-6100439_223_4_1_3_1_1_1
*/

-- no repairs in train but repairs in test
(select a.tool_stud_ext
from imp_hits_all a
where not exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 6 and extract(month from a.timestamp) <= 8 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
    (select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 6 and extract(month from b.timestamp) <= 8 group by b.tool_stud_ext having count(1) between 1500 and 4000) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 9 and extract(month from a.timestamp) <= 10 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext);

/*
8 used
                     tool_stud_ext                      
--------------------------------------------------------
050-213-Z1-UB63-070-100-101-1.1-610866_213_3_1_1_2_1_1
050-213-Z1-UB64-140-100-101-1.1-610457_213_3_1_1_2_1_2
050-213-Z1-UB64-160-100-101-1.1-610845_213_1_1_1_1_1_2
050-213-Z1-UB64-120-300-301-2.1-630312_213_3_1_1_2_1_1
050-213-Z1-UB63-080-100-101-1.1-610871_213_3_1_1_2_1_1
050-213-Z1-UB64-030-400-401-2.1-610636_213_3_1_1_2_1_1
050-213-Z1-UB64-110-100-101-1.1-610353_213_3_1_1_2_1_1
050-213-Z1-UB63-140-300-301-1.1-620480_213_3_1_1_2_1_1
050-213-Z1-UB64-040-200-201-1.1-620400_213_3_1_1_2_1_1
050-213-Z1-UB64-040-200-201-1.1-620887_213_3_1_1_2_1_1
050-213-Z1-UB64-110-400-401-2.1-610589_213_3_1_1_2_1_1
050-213-Z1-UB63-140-300-301-1.1-620386_213_3_1_1_2_1_1
050-213-Z1-UB64-140-200-201-2.1-620625_213_3_1_1_2_1_2
050-213-Z1-UB64-130-400-401-1.1-620023_213_3_1_1_2_1_2
050-213-Z1-UB64-130-200-201-2.1-611219_213_3_1_1_2_1_2
050-213-Z1-UB63-070-200-201-1.1-620590_213_1_1_1_1_1_1
050-213-Z1-UB63-130-100-101-2.1-610813_213_1_2_1_2_1_1
050-213-Z1-UB64-140-300-301-1.1-620766_213_3_1_1_2_1_2
050-213-Z1-UB64-140-400-401-2.1-610587_213_3_1_1_2_1_2
050-213-Z1-UB64-140-400-401-2.1-610746_213_3_1_1_2_1_2
050-213-Z1-UB63-110-200-201-1.1-620722_213_1_2_1_2_1_1
050-213-Z1-UB63-110-200-201-1.1-620586_213_3_1_1_1_1_1
050-213-Z1-UB63-140-200-201-1.1-620406_213_3_1_1_1_1_1
050-213-Z1-UB64-160-100-101-1.1-610598_213_1_1_1_1_1_2
050-213-Z1-UB64-120-200-201-2.1-620773_213_3_1_1_2_1_1
050-213-Z1-UB64-130-100-101-2.1-611014_213_3_1_1_2_1_2
050-213-Z1-UB64-120-400-401-1.1-620139_213_3_1_1_2_1_1
050-213-Z1-UB64-060-400-401-2.1-610584_213_3_1_1_2_1_2
050-213-Z1-UB64-050-200-201-2.1-620785_213_3_1_1_2_1_2
050-213-Z1-UB64-120-100-101-2.1-611663_213_3_1_1_2_1_1
050-213-Z1-UB63-080-100-101-1.1-610872_213_3_1_1_2_1_1
050-213-Z1-UB64-140-100-101-1.1-620482_213_3_1_1_2_1_2
050-213-Z1-UB63-140-300-301-1.1-620420_213_3_1_1_2_1_1
050-213-Z1-UB63-140-200-201-1.1-620388_213_1_2_1_2_1_1
*/


-- no repairs in train but repairs in test, with low train data
(select a.tool_stud_ext
from imp_hits_all a
where not exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 6 and extract(month from a.timestamp) <= 8 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
    (select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 6 and extract(month from b.timestamp) <= 8 group by b.tool_stud_ext having count(1) between 400 and 600) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 9 and extract(month from a.timestamp) <= 10 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext);

/*
5 used
050-213-Z1-UB64-160-100-101-1.1-610598_213_1_2_1_2_1_2
050-223-Z1-UB75-030-500-501-1.1-6100326_223_4_1_3_1_1_2
050-223-Z1-UB75-030-100-101-1.1-6200038_223_4_1_3_1_1_2
050-223-Z1-UB75-030-300-301-1.1-6100127_223_4_1_3_1_1_2
050-223-Z1-UB75-030-300-301-1.1-6100123_223_4_1_3_1_1_2
050-223-Z1-UB75-030-100-101-1.1-6100653_223_4_1_3_1_1_2
*/


-- repairs in train without repairs in test with 1500/4000 welds
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
    (select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 6 and extract(month from b.timestamp) <= 8 group by b.tool_stud_ext having count(1) between 1500 and 4000) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where not exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 9 and extract(month from a.timestamp) <= 10 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext);

/*
(8 used)
050-213-Z1-UB63-070-100-101-1.1-610763_213_1_1_1_1_1_1
050-213-Z1-UB64-130-400-401-1.1-620780_213_3_1_1_2_1_2
050-213-Z1-UB64-030-100-101-1.1-610063_213_3_1_1_2_1_1
050-213-Z1-UB64-110-100-101-1.1-620355_213_3_1_1_2_1_1
050-213-Z1-UB64-110-100-101-1.1-610952_213_3_1_1_2_1_1
050-213-Z1-UB64-030-300-301-1.1-610319_213_3_1_1_2_1_1
050-213-Z1-UB64-060-200-201-1.1-610348_213_3_1_1_2_1_2
050-213-Z1-UB63-080-100-101-1.1-610871_213_3_1_1_2_1_1
050-213-Z1-UB64-110-100-101-1.1-610456_213_3_1_1_2_1_1
050-213-Z1-UB63-130-100-101-1.1-620558_213_1_2_1_2_1_1
050-213-Z1-UB64-120-300-301-1.1-620506_213_3_1_1_2_1_1
050-213-Z1-UB64-030-400-401-2.1-610638_213_3_1_1_2_1_1
050-213-Z1-UB64-140-100-101-1.1-620728_213_3_1_1_2_1_2
050-213-Z1-UB64-040-200-201-2.1-620776_213_3_1_1_2_1_1
050-213-Z1-UB64-030-400-401-2.1-610760_213_3_1_1_2_1_1
050-213-Z1-UB64-060-400-401-2.1-610740_213_3_1_1_2_1_2
050-213-Z1-UB64-030-500-501-1.1-620534_213_3_1_1_2_1_1
050-213-Z1-UB64-030-200-201-2.1-611382_213_3_1_1_2_1_1
050-213-Z1-UB63-070-100-101-1.1-610748_213_1_1_1_1_1_1
050-213-Z1-UB64-130-200-201-2.1-611219_213_3_1_1_2_1_2
050-213-Z1-UB64-110-100-101-1.1-610455_213_3_1_1_2_1_1
050-213-Z1-UB63-140-200-201-1.1-620738_213_3_1_1_1_1_1
050-213-Z1-UB64-050-200-201-1.1-610351_213_3_1_1_2_1_2
050-213-Z1-UB64-130-200-201-1.1-620462_213_3_1_1_2_1_2
050-213-Z1-UB64-060-400-401-2.1-610580_213_3_1_1_2_1_2
050-213-Z1-UB64-130-400-401-1.1-620098_213_3_1_1_2_1_2
050-213-Z1-UB63-140-200-201-1.1-620422_213_1_2_1_2_1_1
050-213-Z1-UB64-030-300-301-1.1-610502_213_3_1_1_2_1_1
050-213-Z1-UB64-140-100-101-1.1-610456_213_3_1_1_2_1_2
050-213-Z1-UB64-140-100-101-1.1-620522_213_3_1_1_2_1_2
050-213-Z1-UB64-110-100-101-1.1-620522_213_3_1_1_2_1_1
050-213-Z1-UB64-060-500-501-1.1-620450_213_3_1_1_2_1_2
050-213-Z1-UB64-030-400-401-2.1-610581_213_3_1_1_2_1_1
050-213-Z1-UB63-140-300-301-1.1-620480_213_3_1_1_2_1_1

*/


-- without repairs in both training and test 
(select a.tool_stud_ext
from imp_hits_all a
where not exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 6 and extract(month from a.timestamp) <= 8 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext)
intersect
(select x.tool_stud_ext from
    (select b.tool_stud_ext, count(1) from imp_hits_all b where extract(month from b.timestamp) >= 6 and extract(month from b.timestamp) <= 8 group by b.tool_stud_ext having count(1) between 1500 and 4000) x)
intersect
(select a.tool_stud_ext
from imp_hits_all a
where not exists (select 1 from tmp_repaired_studs b
              where b.stud_id = a.stud_id and
                    b.carbody_id = a.carbody_id and 
                    extract(month from a.timestamp) >= 9 and extract(month from a.timestamp) <= 10 and
                    b.repaired_at is not null and
                    error_code != '1000' and
                    not exists (select 1 from tmp_weldtimeactual_zero c where c.fingerprint = a.fingerprint))
group by a.tool_stud_ext);


/*
OUT OF MANY: (5 used)
050-213-Z1-UB64-060-400-401-2.1-610760_213_1_1_1_1_1_2
050-213-Z1-UB64-120-300-301-1.1-620213_213_3_1_1_2_1_1
050-213-Z1-UB64-050-100-101-1.1-620321_213_3_1_1_2_1_2
050-213-Z1-UB63-070-100-101-1.1-610866_213_3_1_1_2_1_1
050-213-Z1-UB64-140-100-101-1.1-610457_213_3_1_1_2_1_2
050-213-Z1-UB64-140-400-401-1.1-611637_213_3_1_1_2_1_2
050-213-Z1-UB64-040-100-101-1.1-620594_213_3_1_1_2_1_1
050-213-Z1-UB64-060-400-401-1.1-610741_213_1_1_1_1_1_2
050-213-Z1-UB64-120-300-301-1.1-620629_213_3_1_1_2_1_1
050-213-Z1-UB63-070-100-101-1.1-610763_213_1_1_1_1_1_1
050-213-Z1-UB63-070-100-101-1.1-610619_213_3_1_1_2_1_1
050-213-Z1-UB64-130-400-401-1.1-620780_213_3_1_1_2_1_2
050-213-Z1-UB64-140-400-401-1.1-610659_213_3_1_1_2_1_2
050-213-Z1-UB64-130-400-401-1.1-620094_213_3_1_1_2_1_2
050-213-Z1-UB64-130-300-301-1.1-620209_213_3_1_1_2_1_2
050-213-Z1-UB64-140-200-201-2.1-620614_213_3_1_1_2_1_2
-----050-223-Z1-HC73-080-200-201-1.1-6100113_223_4_1_1_1_1_1
050-213-Z1-UB64-050-300-301-1.1-611071_213_3_1_1_2_1_2
050-213-Z1-UB64-130-100-101-1.1-610663_213_3_1_1_2_1_2
050-213-Z1-UB64-140-300-301-1.1-610826_213_3_1_1_2_1_2
050-213-Z1-UB63-070-200-201-1.1-620566_213_3_1_1_2_1_1
050-213-Z1-UB64-040-200-201-1.1-610352_213_3_1_1_2_1_1
050-213-Z1-UB64-060-300-301-1.1-610318_213_3_1_1_2_1_2
050-213-Z1-UB64-050-200-201-1.1-610445_213_3_1_1_2_1_2
050-213-Z1-UB64-060-100-101-1.1-620628_213_3_1_1_2_1_2
050-213-Z1-UB64-130-100-101-1.1-610870_213_3_1_1_2_1_2
050-213-Z1-UB64-160-100-101-1.1-610845_213_1_1_1_1_1_2
050-213-Z1-UB64-050-100-101-1.1-620550_213_3_1_1_2_1_2
050-213-Z1-UB64-130-100-101-1.1-610662_213_3_1_1_2_1_2
050-213-Z1-UB64-120-300-301-2.1-620398_213_3_1_1_2_1_1
*/

