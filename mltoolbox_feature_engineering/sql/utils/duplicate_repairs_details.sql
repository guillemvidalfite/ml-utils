









select count(1) from 


select count(1)
from imp_hits_all a,
     (select carbody_id, stud_id from imp_hits_all where series = '213' and timestamp >= '2020-10-01' group by carbody_id, stud_id having count(1) > 1) x
where a.carbody_id = x.carbody_id and
      a.stud_id = x.stud_id and
      a.series = '213' and
      a.timestamp >= '2020-10-01';



select count(1)
from imp_hits_all a,
     (select carbody_id, stud_id from
         (select carbody_id, stud_id from imp_hits_all where series = '213' and timestamp >= '2020-10-01' group by carbody_id, stud_id having count(1) > 1) x) y
where a.carbody_id = y.carbody_id and
      a.stud_id = y.stud_id;



# october

# total welds 
select count(1) from imp_hits_all where series = '213' and timestamp >= '2020-10-01';

# total couples with repairs
(select count(1) from
         (select carbody_id, stud_id from imp_hits_all where series = '213' and timestamp >= '2020-10-01' group by carbody_id, stud_id having count(1) > 1) x,
         tmp_repaired_studs b
 where b.carbody_id = x.carbody_id and
       b.stud_id = x.stud_id);

# total couples with repairs and no false positives
(select count(1) from
         (select carbody_id, stud_id from imp_hits_all where series = '213' and timestamp >= '2020-10-01' group by carbody_id, stud_id having count(1) > 1) x,
         tmp_repaired_studs b
 where b.carbody_id = x.carbody_id and
       b.stud_id = x.stud_id and error_code != '1000');


# total couples with a missing
select count(1) from
         (select carbody_id, stud_id 
          from imp_hits_all a
          where series = '213' and 
                timestamp >= '2020-10-01' and
                exists (select 1 from tmp_weldtimeactual_zero b where b.fingerprint = a.fingerprint)
          group by carbody_id, stud_id having count(1) > 1) x;
 
 # september
 # total welds 
select count(1) from imp_hits_all where series = '213' and timestamp >= '2020-09-01' and timestamp < '2020-10-01';

# total couples
select count(1) from
         (select carbody_id, stud_id from imp_hits_all where series = '213' and timestamp >= '2020-09-01' group by carbody_id, stud_id having count(1) > 1) x;

# total couples with repairs
(select count(1) from
         (select carbody_id, stud_id from imp_hits_all where series = '213' and timestamp >= '2020-09-01' group by carbody_id, stud_id having count(1) > 1) x,
         tmp_repaired_studs b
 where b.carbody_id = x.carbody_id and
       b.stud_id = x.stud_id);

# total couples with repairs and no false positives
(select count(1) from
         (select carbody_id, stud_id from imp_hits_all where series = '213' and timestamp >= '2020-09-01' group by carbody_id, stud_id having count(1) > 1) x,
         tmp_repaired_studs b
 where b.carbody_id = x.carbody_id and
       b.stud_id = x.stud_id and error_code != '1000');

# repairs detail 2
(select b.error_code, count(1) from
         (select carbody_id, stud_id from imp_hits_all where series = '213' and timestamp >= '2020-09-01' group by carbody_id, stud_id having count(1) > 1) x,
         tmp_repaired_studs b
 where b.carbody_id = x.carbody_id and
       b.stud_id = x.stud_id
group by b.error_code);

(select b.repaired_at, count(1) from
         (select carbody_id, stud_id from imp_hits_all where series = '213' and timestamp >= '2020-09-01' group by carbody_id, stud_id having count(1) > 1) x,
         tmp_repaired_studs b
 where b.carbody_id = x.carbody_id and
       b.stud_id = x.stud_id
group by b.repaired_at);


# total repairs
select count(1) from imp_hits_all a, tmp_repaired_studs b 
where a.series = '213' and 
      a.timestamp >= '2020-10-01' and
      b.carbody_id = a.carbody_id and
      b.stud_id = a.stud_id and
      b.error_code != '1000';


# total couples with a missing
select count(1) from
         (select carbody_id, stud_id 
          from imp_hits_all a
          where series = '213' and 
                timestamp >= '2020-09-01' and
                exists (select 1 from tmp_weldtimeactual_zero b where b.fingerprint = a.fingerprint)
          group by carbody_id, stud_id having count(1) > 1) x;




######## candi queries

# SOLO WELDS REPARADOS
# Grupos de repetidos
select carbody_id,stud_id,string_agg(fingerprint,',' order by timestamp) fp,
       string_agg(timestamp::text,',' order by timestamp) ts,
       string_agg(wip,',' order by timestamp) wips,count(1)
from imp_hits_all_repaired
where series='213' and timestamp >= '2020-09-01'
group by 1,2 having count(1)>1;


select fp
from
(select carbody_id,stud_id,string_agg(fingerprint,',' order by timestamp) fp
from imp_hits_all_repaired
where series='213' and timestamp >= '2020-09-01'
group by 1,2 having count(1)>1) x;


# TODOS LOS WELDS (serie 213 y año 2020)
# Grupos de repetidos
select carbody_id,stud_id,string_agg(fingerprint,',' order by timestamp) fp,
       string_agg(timestamp::text,',' order by timestamp) ts,
       string_agg(wip,',' order by timestamp) wips,count(1)
from imp_hits_all
where series='213' and timestamp >= '2020-09-01'
group by 1,2 having count(1)>1;

select fp from
(select carbody_id,stud_id,string_agg(fingerprint,',' order by timestamp) fp
from imp_hits_all
where series='213' and timestamp >= '2020-09-01'
group by 1,2 having count(1)>1) x
minus
select fp
from
(select carbody_id,stud_id,string_agg(fingerprint,',' order by timestamp) fp
from imp_hits_all_repaired
where series='213' and timestamp >= '2020-09-01'
group by 1,2 having count(1)>1) x;



# Secuencias de WIPs
select replace(replace(wips,'false','WOP'),'true','WIP') "WIPs Sequence",count(1) from
   (select carbody_id,stud_id,string_agg(fingerprint,',' order by timestamp) fp,
           string_agg(timestamp::text,',' order by timestamp) ts,
           string_agg(wip,',' order by timestamp) wips,count(1)
    from imp_hits_all_repaired
    where series='213' and timestamp >= '2020-01-01'
    group by 1,2 having count(1)>1) x
group by 1 order by 2 desc;



stats=# select fingerprint, carbody_id, stud_id from imp_hits_all where fingerprint in ('c00111812cf5a167de5a535410637b52ce4bfa59','de7b253cd5e453b307b4b17999f2407030a765da');
               fingerprint                | carbody_id | stud_id 
------------------------------------------+------------+---------
 c00111812cf5a167de5a535410637b52ce4bfa59 | 29894516   | 610640
 de7b253cd5e453b307b4b17999f2407030a765da | 29913415   | 620590


select repaired_at, repaired_out_of_line, stud_type, stud_bended, stud_missing, stud_shifted, error_code from tmp_repaired_studs where carbody_id = '29894516' and stud_id = '610640';

select repaired_at, repaired_out_of_line, stud_type, stud_bended, stud_missing, stud_shifted, error_code from tmp_repaired_studs where carbody_id = '29913415' and stud_id = '620590';

