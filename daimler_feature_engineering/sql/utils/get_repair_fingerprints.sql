-- select count(1) from tmp_repaired_studs;

\copy (select a.fingerprint from imp_hits_all a where exists (select 1 from tmp_repaired_studs b where a.stud_id = b.stud_id and a.carbody_id = b.carbody_id)) to '/home/bigml/guillem/repair_fingerprints.csv' delimiter as ',';


\copy (select a.fingerprint from imp_hits_all a where not exists (select 1 from tmp_repaired_studs b where a.stud_id = b.stud_id and a.carbody_id = b.carbody_id) order by random() limit 100000) to '/home/bigml/guillem/random_fingerprints.csv' delimiter as ',';

\copy (select a.fingerprint, b.repaired_at, b.error_code, case when b.error_code is null then 1 when b.error_code != '1000' then 1 else 0 end  as repaired from imp_hits_all a, tmp_repaired_studs b where a.stud_id = b.stud_id and a.carbody_id = b.carbody_id) to '/home/bigml/guillem/repair_flags.csv' delimiter as ',';
