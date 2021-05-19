

drop table if exists wop_repairs_welds;
create table wop_repair_welds(
   fingerprint       varchar(100), 
   studid            varchar(20),
   carbody           varchar(20),
   faultcode         varchar(10),
   penetration       numeric,
   weldEnergyActual  numeric,
   liftHeight        numeric,
   currentPositive   numeric,
   weldVoltageActual numeric
);

-- read csv file
copy wop_repair_welds(
      fingerprint,
      studid,
      carbody,
      faultcode,
      penetration,
      weldEnergyActual,
      liftHeight,
      currentPositive,
      weldVoltageActual
)
FROM '/Users/guillem/Data/Customers/Daimler/anomalies-analysis/empty_repairs.csv' DELIMITER ',' CSV HEADER;

create index inx_fingerprint_wrw on wop_repair_welds(fingerprint);
create index inx_carbodystud_wrw on wop_repair_welds(carbody, studid);

#COPY 
# (select repaired_at, repaired_out_of_line, carbody_id, stud_id, stud_type, bad_weld, error_code from tmp_repaired_studs)
#TO '/tmp/all_repair_flags.csv' DELIMITER ',' CSV HEADER;

drop table if exists all_repair_flags;
create table all_repair_flags(
       repaired_at           varchar(20),
       repaired_out_of_line  varchar(10),
       carbody_id            varchar(50),
       stud_id               varchar(50),
       stud_type             varchar(30),
       bad_weld              varchar(10),
       error_code            varchar(10)
);

-- read csv file
copy all_repair_flags(
      repaired_at,
      repaired_out_of_line,
      carbody_id,
      stud_id,
      stud_type,
      bad_weld,
      error_code)
FROM '/Users/guillem/Data/Customers/Daimler/anomalies-analysis/all_repair_flags.csv' DELIMITER ',' CSV HEADER;

create index inx_carbodystud_allrepflags on all_repair_flags(carbody_id, stud_id);

-- joined table
drop table if exists wop_missing_welds_repairs;
create table wop_missing_welds_repairs as
select   a.fingerprint,
         a.studid,
         a.carbody,
         a.faultcode,
         a.penetration,
         a.weldEnergyActual,
         a.liftHeight,
         a.currentPositive,
         a.weldVoltageActual,
         b.repaired_at,
         b.repaired_out_of_line,
         b.carbody_id,
         b.stud_id,
         b.stud_type,
         b.bad_weld,
         b.error_code,
         (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000'))) as repaired,
         (a.weldVoltageActual = 0 and a.currentPositive = 0 and a.weldenergyactual = 0) as is_cur_signal_missing,
         (a.penetration is null and a.liftHeight is null) as is_lp_signal_missing
from wop_repair_welds a left join all_repair_flags b
on  (b.carbody_id = a.carbody and
      b.stud_id = a.studid);

-- clean
delete from wop_missing_welds_repairs where error_code in ('0','0000','1');
update wop_missing_welds_repairs set repaired = 'FALSE' where repaired is null;




-- queries
-- repairs and missings distribution
select is_cur_signal_missing, is_lp_signal_missing, repaired, count(1) 
from wop_missing_welds_repairs group by is_cur_signal_missing, is_lp_signal_missing, repaired
order by 1,2;

-- BOTH missing
select repaired, count(1) from wop_missing_welds_repairs where is_cur_signal_missing = 't' and is_lp_signal_missing = 't' group by repaired;

select faultcode, count(1) from wop_missing_welds_repairs where is_cur_signal_missing = 't' and is_lp_signal_missing = 't' and repaired = 't' group by faultcode order by 2 desc;
select faultcode, count(1) from wop_missing_welds_repairs where is_cur_signal_missing = 't' and is_lp_signal_missing = 't' and repaired = 'f' group by faultcode order by 2 desc;

-- CURRENT missing
select repaired, count(1) from wop_missing_welds_repairs where is_cur_signal_missing = 't' and is_lp_signal_missing = 'f' group by repaired;
select faultcode, count(1) from wop_missing_welds_repairs where is_cur_signal_missing = 't' and is_lp_signal_missing = 'f' and repaired = 't' group by faultcode order by 2 desc;
select faultcode, count(1) from wop_missing_welds_repairs where is_cur_signal_missing = 't' and is_lp_signal_missing = 'f' and repaired = 'f' group by faultcode order by 2 desc;

-- NO SIGNAL missing
select repaired, count(1) from wop_missing_welds_repairs where is_cur_signal_missing = 'f' and is_lp_signal_missing = 'f' group by repaired;
select faultcode, count(1) from wop_missing_welds_repairs where is_cur_signal_missing = 'f' and is_lp_signal_missing = 'f' and repaired = 't' group by faultcode order by 2 desc;
select faultcode, count(1) from wop_missing_welds_repairs where is_cur_signal_missing = 'f' and is_lp_signal_missing = 'f' and repaired = 'f' group by faultcode order by 2 desc;



--------------------------------
-- WIP missing welds
--------------------------------
drop table if exists wip_missing_welds;
create table wip_missing_welds(
   fingerprint       varchar(100), 
   studid            varchar(20),
   carbody           varchar(20),
   faultcode         varchar(10),
   penetration       numeric,
   weldEnergyActual  numeric,
   liftHeight        numeric,
   currentPositive   numeric,
   weldVoltageActual numeric,
   WIP               varchar(10)
);

-- read csv file
copy wip_missing_welds(
      fingerprint,
      studid,
      carbody,
      faultcode,
      penetration,
      weldEnergyActual,
      liftHeight,
      currentPositive,
      weldVoltageActual,
      WIP
)
FROM '/Users/guillem/Data/Customers/Daimler/anomalies-analysis/empty_repairs_WIP.csv' DELIMITER ',' CSV HEADER;

create index inx_fingerprint_wmw on wip_missing_welds(fingerprint);
create index inx_carbodystud_wmw on wip_missing_welds(carbody, studid);


-- joined table
drop table if exists wip_missing_welds_repairs;
create table wip_missing_welds_repairs as
select   a.fingerprint,
         a.studid,
         a.carbody,
         a.faultcode,
         a.penetration,
         a.weldEnergyActual,
         a.liftHeight,
         a.currentPositive,
         a.weldVoltageActual,
         a.WIP,
         b.repaired_at,
         b.repaired_out_of_line,
         b.carbody_id,
         b.stud_id,
         b.stud_type,
         b.bad_weld,
         b.error_code,
         (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000'))) as repaired,
         (a.weldVoltageActual = 0 and a.currentPositive = 0 and a.weldenergyactual = 0) as is_cur_signal_missing,
         (a.penetration is null and a.liftHeight is null) as is_lp_signal_missing
from wip_missing_welds a left join all_repair_flags b
on  (b.carbody_id = a.carbody and
      b.stud_id = a.studid)
where a.WIP = 'True';

-- clean
delete from wip_missing_welds_repairs where error_code in ('0','0000','1');
update wip_missing_welds_repairs set repaired = 'FALSE' where repaired is null;


-- queries
select repaired, error_code, count(1) from wip_missing_welds_repairs group by repaired, error_code;



------------------------ september/october ALL missings exploration
drop table if exists all_missings_sept_oct;
create table all_missings_sept_oct(
      Fingerprint                varchar(100),
      StudId                     varchar(100),
      CarbodyId                  varchar(100),
      FaultCode                  varchar(20),
      LMPenetrationActual        numeric,
      WeldEnergyActual           numeric,
      LMLiftHeightActual         numeric,
      WeldCurrentActualPositive  numeric,
      weldVoltageActual          numeric,
      WIP                        varchar(20)
);

-- read csv file
copy all_missings_sept_oct(
      Fingerprint,
      StudId,
      CarbodyId,
      FaultCode,
      LMPenetrationActual,
      WeldEnergyActual,
      LMLiftHeightActual,
      WeldCurrentActualPositive,
      weldVoltageActual,
      WIP
)
FROM '/Users/guillem/Data/Customers/Daimler/anomalies-analysis/missing_welds_all_SO.csv' DELIMITER ',' CSV HEADER;



-- joined table
drop table if exists all_missings_SO;
create table all_missings_SO as
select   
         a.Fingerprint,
         a.StudId,
         a.CarbodyId,
         a.FaultCode,
         a.LMPenetrationActual,
         a.WeldEnergyActual,
         a.LMLiftHeightActual,
         a.WeldCurrentActualPositive,
         a.weldVoltageActual,
         a.WIP,
         b.repaired_at,
         b.repaired_out_of_line,
         b.carbody_id,
         b.stud_id,
         b.stud_type,
         b.bad_weld,
         b.error_code,
         (b.repaired_at = 'Assembly Shop' or (b.repaired_at = 'Body Shop' and b.error_code in ('2000','3000'))) as repaired,
         (a.weldVoltageActual = 0 and a.WeldCurrentActualPositive = 0 and a.WeldEnergyActual = 0) as is_cur_signal_missing,
         (a.LMPenetrationActual is null and a.LMLiftHeightActual is null) as is_lp_signal_missing
from all_missings_sept_oct a left join all_repair_flags b
on  (b.carbody_id = a.CarbodyId and
      b.stud_id = a.StudId);

delete from all_missings_SO where error_code in ('0','0000','1');
update all_missings_SO set repaired = 'FALSE' where repaired is null;




create table repeated_id_SO (fingerprint varchar(100));


insert into repeated_id_SO (fingerprint) values ('62caaf6f014679b97188d23d691f460aa49f5e97');
insert into repeated_id_SO (fingerprint) values ('77b08f4294f66adf60974f5b2e3ad0d127c6597f');
insert into repeated_id_SO (fingerprint) values ('d5af5264c8e9276695d24c4d3bb6fec422365f00');
insert into repeated_id_SO (fingerprint) values ('ba4d250700997f579f10b6f8d2bf75f5f2e7ce46');
insert into repeated_id_SO (fingerprint) values ('a7c70d7128dd39f2b3131ed5c2a747f0b6b7c199');
insert into repeated_id_SO (fingerprint) values ('8247e37ac551e09aa375a5f8266cef2529439f4d');
insert into repeated_id_SO (fingerprint) values ('85ed05e1deecd9f69aa3924c2b82498027a8910d');
insert into repeated_id_SO (fingerprint) values ('5562ce532f301e3055051e7a44990f1263632f06');
insert into repeated_id_SO (fingerprint) values ('79ae8199b60a60006556f59c55ccd132f8ced34f');
insert into repeated_id_SO (fingerprint) values ('659dca8bae8f0d55ce69d73682509c6d431f8d5d');
insert into repeated_id_SO (fingerprint) values ('eaa257e7cd235d8deb856b37ba9bfad528005294');
insert into repeated_id_SO (fingerprint) values ('09b90df9f457ced83ae5cfe79a8e83b07bc135c4');
insert into repeated_id_SO (fingerprint) values ('d2ca21f7f822715b5ecbf1337dd8963505bda366');
insert into repeated_id_SO (fingerprint) values ('21e692e77da85197d3876f767dce9f8b67637dd3');
insert into repeated_id_SO (fingerprint) values ('b33e3776ce2a6a118527641add35028b3787ac53');
insert into repeated_id_SO (fingerprint) values ('8247d08d9b7b9fb089fb0f553ce7f6e6383779db');
insert into repeated_id_SO (fingerprint) values ('8ccec17c8296f14be9ab052dfc2dd2615fc8765f');
insert into repeated_id_SO (fingerprint) values ('557cdb564da33081533314f5c6db774aadb71fd6');
insert into repeated_id_SO (fingerprint) values ('9e031d1e58f85a18d723b8d960c3da15e4b6516d');
insert into repeated_id_SO (fingerprint) values ('521d8372ad6fb9e0ee1f60bcc48376bc6384166d');
insert into repeated_id_SO (fingerprint) values ('2c25f097b3603e094d30ab046372af01f4fd55f9');
insert into repeated_id_SO (fingerprint) values ('674cbd9e1473e1bb320e051da7005451a86d3955');
insert into repeated_id_SO (fingerprint) values ('ba4d0d4b572b2f6c65593852e721ccd6cdebfd49');
insert into repeated_id_SO (fingerprint) values ('13869126704cdb53fe02f013edfaaa30f8dbf142');
insert into repeated_id_SO (fingerprint) values ('c0c3583c8df39120b5759471f55fc2e40bd24711');
insert into repeated_id_SO (fingerprint) values ('c0d5f5f5ca8b385759ca098290333aadd4fe6225');
insert into repeated_id_SO (fingerprint) values ('edf56d0479540fd887340e1e49db9e3ff4760c06');
insert into repeated_id_SO (fingerprint) values ('dfa583a998e0bce4bcbfd01be6fd31f7738f5268');
insert into repeated_id_SO (fingerprint) values ('ca3739191cc28d4f900e0ee685ea2233760a84dc');
insert into repeated_id_SO (fingerprint) values ('f467c3d0bf4487003ed76ba046ed5a813eaadea6');
insert into repeated_id_SO (fingerprint) values ('e990241ab331e57d62db9f0fa7555e038b6996a0');
insert into repeated_id_SO (fingerprint) values ('c5709600ecba327bcaa15bda23eb16e46c7a5be3');
insert into repeated_id_SO (fingerprint) values ('3cea19ff147e17080c2937037d495d3414d738b2');
insert into repeated_id_SO (fingerprint) values ('5809fe4bdf8b8939114f274ea99abd920d604d12');
insert into repeated_id_SO (fingerprint) values ('0db0a1870bb398fad52c47722ce62b19eb54b392');
insert into repeated_id_SO (fingerprint) values ('3f26c010bdb99bc86028f20e0bfa391847c72622');
insert into repeated_id_SO (fingerprint) values ('f376be98d16796be98722914e220341062f7c80d');
insert into repeated_id_SO (fingerprint) values ('9955742809d52fc69789b25b2663b32e2af81563');
insert into repeated_id_SO (fingerprint) values ('90ee533ff0f7405cff4e5f69d0e5017f539c93d9');
insert into repeated_id_SO (fingerprint) values ('ebf159f0c8e666d6eb0af78851c4fb40f3ca228d');
insert into repeated_id_SO (fingerprint) values ('62d0ac52b8188dcf81568396e3b5d6b9f61d33e6');
insert into repeated_id_SO (fingerprint) values ('6c6b0ace9146dcf1ad458090b9755b00eaa9c514');
insert into repeated_id_SO (fingerprint) values ('105fb5c5a96bc38680e4efd7b84f44ea775f8b7a');
insert into repeated_id_SO (fingerprint) values ('15a2c37b0047da313f3f5aced07642b1564b0dfa');
insert into repeated_id_SO (fingerprint) values ('9c46c37919899cee55e441edc765dc22bba021a6');
insert into repeated_id_SO (fingerprint) values ('8b9975deebc39729c6a1b035103ca41ab8705f62');
insert into repeated_id_SO (fingerprint) values ('ca7bb6423b70523c16f339e5abe541a9814533fc');
insert into repeated_id_SO (fingerprint) values ('91ce26525449280f176601a76ee8284c77cb6f67');
insert into repeated_id_SO (fingerprint) values ('127a046835a130a6370d840bc33f5874c5dca8b8');
insert into repeated_id_SO (fingerprint) values ('981e27c01576b03939dba8e6b141013514b9aea3');
insert into repeated_id_SO (fingerprint) values ('c269fd6a9c9f9745eb057ef5eabd5fbd97845623');
insert into repeated_id_SO (fingerprint) values ('db2dc45b0bff76ff355353d780665e3d98c456db');
insert into repeated_id_SO (fingerprint) values ('018e6093d5578355fcc5e69e1e9e21a42f988144');
insert into repeated_id_SO (fingerprint) values ('b612fb1661868935a2a7733aa5cac946c8c3e987');
insert into repeated_id_SO (fingerprint) values ('06981e1b06fba27f3b47b7b6edff172cb2afbdea');
insert into repeated_id_SO (fingerprint) values ('7e6600521d310d41980fbc49b814a439d346582a');
insert into repeated_id_SO (fingerprint) values ('46de9cf6b6953c233fcb1768cbefe8c8c2143f6d');
insert into repeated_id_SO (fingerprint) values ('25f6a03bd666ea306e0d19dba0277007d3ee474f');
insert into repeated_id_SO (fingerprint) values ('2eab5d56f42277489025c11fda77da73993ab397');
insert into repeated_id_SO (fingerprint) values ('4a551f3c85e4e22fb721def2f23d2ffe9025d07d');
insert into repeated_id_SO (fingerprint) values ('58430ebb8441fbf7d76d0a356d056a6e5bd3a834');
insert into repeated_id_SO (fingerprint) values ('319ca92deda401fe800777c93ee8258aa60eb2c9');
insert into repeated_id_SO (fingerprint) values ('1074d3693a680197677a62de7cf6b6e37b734452');
insert into repeated_id_SO (fingerprint) values ('cbd27abae54652fed90b467c7b25eb84e3f98ebf');
insert into repeated_id_SO (fingerprint) values ('ab1e0987d8022ed07957007e8d550b67d0568e2c');
insert into repeated_id_SO (fingerprint) values ('dc6728864eb4a7ec47202ff9c77bea7c5b0d25a1');
insert into repeated_id_SO (fingerprint) values ('6fb7fcc7bdeb2ca2f8ee63352def6835ce0da130');
insert into repeated_id_SO (fingerprint) values ('28ed91bdf856535c6f68d11e080723f345d4109d');
insert into repeated_id_SO (fingerprint) values ('3a6ddadfde40516e3e91d0d436d280dc014c336e');
insert into repeated_id_SO (fingerprint) values ('eb913d4283d1471d7bad2b1e6177c65990b2f113');
insert into repeated_id_SO (fingerprint) values ('69d8065d17f6f9f46a459fef236151e9ecce877e');
insert into repeated_id_SO (fingerprint) values ('c4ccbcdf09e64775a893118e25f7df9d60466f65');
insert into repeated_id_SO (fingerprint) values ('97bfdc1294fe864e554eac5e329d56d7a4ee7cd1');
insert into repeated_id_SO (fingerprint) values ('376665e4bd558d3def804ee769b5315330999460');
insert into repeated_id_SO (fingerprint) values ('f7aa96c8e2731bd0f8dc2d44300c28a32cda3596');
insert into repeated_id_SO (fingerprint) values ('d265efdf3a2a51ce207f0cc1d7fbd74d0920d70b');
insert into repeated_id_SO (fingerprint) values ('2d696f8ab23eed2ec28cb5d1bffa990c3ef9ff3e');
insert into repeated_id_SO (fingerprint) values ('1717f09c76d344db9f2e63cadde5f6f12641cbaf');
insert into repeated_id_SO (fingerprint) values ('6dea34ee675901530634f5750da96347a5f6875f');
insert into repeated_id_SO (fingerprint) values ('7ed0f814094f0c243ffa21de42a11349b43bc2c3');
insert into repeated_id_SO (fingerprint) values ('fa169581150ca85e7d22744aec251f224c248884');
insert into repeated_id_SO (fingerprint) values ('a278c0c61bd24b8a9a2ab1d4472be63163f73fa1');
insert into repeated_id_SO (fingerprint) values ('5b86f73a90df2ada11a353c1ba088a97f1f68b70');
insert into repeated_id_SO (fingerprint) values ('54bf2e51f8404af32324dff479c1480d1470d537');
insert into repeated_id_SO (fingerprint) values ('bb5fa19fcfca51317d58157ca0c4901f737c5c1b');
insert into repeated_id_SO (fingerprint) values ('e4da554ffdcec30d32c5402b63ef4f5d2d8eae0c');
insert into repeated_id_SO (fingerprint) values ('8e3ddbccc3cd8d8ac9a798aeec77e95936105854');
insert into repeated_id_SO (fingerprint) values ('ea155992d845d55eeeb65122c46ab28646b5e62a');
insert into repeated_id_SO (fingerprint) values ('8efea0c143bc461c2c738fc15f3fcfed6e9e4c98');
insert into repeated_id_SO (fingerprint) values ('0965dcfb3fd3400d425d2b78756ec7c70d61eb16');
insert into repeated_id_SO (fingerprint) values ('e2ade0d38db749c5c08d18d8e0c9fe26be5c56c7');
insert into repeated_id_SO (fingerprint) values ('f274cd69d699a1cb82ede6838e84e98e27e5fcba');
insert into repeated_id_SO (fingerprint) values ('843679cd03b50e6c0d65a5467f38bc2d5284515c');
insert into repeated_id_SO (fingerprint) values ('2f2edec640230612f07206a41aa87383c68b4740');
insert into repeated_id_SO (fingerprint) values ('215415a5501f0ab6e8ac526269af056debe081ab');
insert into repeated_id_SO (fingerprint) values ('9199dddba4c97e50e72706e28a6c6e6694443489');
insert into repeated_id_SO (fingerprint) values ('84a5b9eec6e63cc9fcdf7e95aa09e7ecb28e0884');
insert into repeated_id_SO (fingerprint) values ('fc0aa19f6dc1722c3a312cc7ec2011b7149828e4');
insert into repeated_id_SO (fingerprint) values ('185c9fab7d0ce8c995da4357be86f91f6f461685');
insert into repeated_id_SO (fingerprint) values ('9611e0024ae394e34040ec76c341dc788e85747f');
insert into repeated_id_SO (fingerprint) values ('90f6b29c7e4c1a08ebcc299f417b17ea3e3fc734');
insert into repeated_id_SO (fingerprint) values ('5095343f79f7f82fe9cf2894f798532f4b096eb3');
insert into repeated_id_SO (fingerprint) values ('6f16a88aa4e489a9d56b84cfc79c7f76938d61e7');
insert into repeated_id_SO (fingerprint) values ('5a42783cc0460e6cfbebe023faf58f457f737a65');
insert into repeated_id_SO (fingerprint) values ('b4ce558dfd6ec13ca9258272676437133a3ad836');
insert into repeated_id_SO (fingerprint) values ('1cb5c3a06ac9f3e1b4763e906fc9e0b88f536b89');
insert into repeated_id_SO (fingerprint) values ('9babbf5ac42d24cf59a5ac398e4a7ce94f607b8c');
insert into repeated_id_SO (fingerprint) values ('8d597464aefcba5a6f2a1576c5047e3d90a283b0');
insert into repeated_id_SO (fingerprint) values ('85eb8405211d5f801294d9c6cdc2fffff13b4165');
insert into repeated_id_SO (fingerprint) values ('f570c63249faa916e2a05e72c44e07200d4961df');
insert into repeated_id_SO (fingerprint) values ('6a6691b990a173387d790fb5c9cc6f394fe677eb');
insert into repeated_id_SO (fingerprint) values ('3585429c6974486634e988dc3afb337671a01897');
insert into repeated_id_SO (fingerprint) values ('f6a0c50e7a8ca0093330eb7f91a2d7d61f90d634');
insert into repeated_id_SO (fingerprint) values ('0c578985f783d4bf1333b413c336aaf68e1523ad');
insert into repeated_id_SO (fingerprint) values ('b0e65222d01913145e4658697d97bbae10b0241d');
insert into repeated_id_SO (fingerprint) values ('f8d1286a41c8ad9743554237aa306b3957624df2');
insert into repeated_id_SO (fingerprint) values ('85f6e7ea17572ed814d6e59298394dc00c0e7d4c');
insert into repeated_id_SO (fingerprint) values ('a76f7085eba87a834fd1e3a8208cd362594d22ca');
insert into repeated_id_SO (fingerprint) values ('0b925c08edce79787c9dd5fffb9623e775cb6fae');
insert into repeated_id_SO (fingerprint) values ('73adb8a8ef232f95e250685289ecde457afff587');
insert into repeated_id_SO (fingerprint) values ('dcdd5ff40e7aa1ccac5b1f8cdc153fc78f7cc366');
insert into repeated_id_SO (fingerprint) values ('f1af7c681d1a42aafbafbeb43e35e7120a8ec21c');
insert into repeated_id_SO (fingerprint) values ('161fb579197bc78692984fc6000881d55f69a7c5');
insert into repeated_id_SO (fingerprint) values ('20912a33f1347119d656a0a9559249a9b4a1261d');
insert into repeated_id_SO (fingerprint) values ('c4417207bf49e63b2ef01081dcd97dad8e4c2432');
insert into repeated_id_SO (fingerprint) values ('ba57ffbbc5b3e124bf4b691055ae3e6fc6bb010e');
insert into repeated_id_SO (fingerprint) values ('e47461a15568ac54f40d76dc35c9e508168a37a5');
insert into repeated_id_SO (fingerprint) values ('9177b113c0506616fce45188ea6c80b5d70d53e2');
insert into repeated_id_SO (fingerprint) values ('f0ea155997c3f2587366f7fd39fa17720d7a325f');
insert into repeated_id_SO (fingerprint) values ('03538cee7fbc8b3cf2dbaa1af294a9d2a91cf92c');
insert into repeated_id_SO (fingerprint) values ('6351587e91428c69021a8d45ded569b57fd673a4');
insert into repeated_id_SO (fingerprint) values ('5ad494414cb9b45dbdff4de94a0d80a4b7a5a6fd');
insert into repeated_id_SO (fingerprint) values ('95f82a3c9b3a0ecb29bee7e3c952d8edc0d706e8');
insert into repeated_id_SO (fingerprint) values ('133075e0118aed308028a42b6663d228178c4f60');
insert into repeated_id_SO (fingerprint) values ('ee80f69bcd4f2bfa06480b7c2946a04bbfa00d2b');
insert into repeated_id_SO (fingerprint) values ('2f9852d1026a301f4bdc1f899d8029f42f25e915');
insert into repeated_id_SO (fingerprint) values ('61825c615e1e9b9cd179d4d542e1788f21091224');
insert into repeated_id_SO (fingerprint) values ('34b0f693321c5f48a29f59b4d7cbaea36df8a04e');
insert into repeated_id_SO (fingerprint) values ('81430b68d8e655a461c17450904ea3cb70769efe');
insert into repeated_id_SO (fingerprint) values ('45e70236df0f0af623a0cd67b82d21a9de8cdd00');
insert into repeated_id_SO (fingerprint) values ('ffca7825e9a79537eaa76fc408482e7982bffca0');
insert into repeated_id_SO (fingerprint) values ('f9016dc89719b63d7810299bd006129c4b797333');
insert into repeated_id_SO (fingerprint) values ('37633fe29552c49d34490b906c412792f4a1cc58');
insert into repeated_id_SO (fingerprint) values ('99a05e143ad65cc3c3fd7d89f433895f4794de06');
insert into repeated_id_SO (fingerprint) values ('bdf9f9db260038d42f725af828453f70f383afd3');
insert into repeated_id_SO (fingerprint) values ('3845be2596ee3a1cf7be0e5ebb4bc6480c13d33e');
insert into repeated_id_SO (fingerprint) values ('d9aa2a6dce31b1012ae1da5d4f9fb2f883fd10a2');
insert into repeated_id_SO (fingerprint) values ('cfa46392cf43494c1228946a76be9c5cff53a4d8');
insert into repeated_id_SO (fingerprint) values ('f4efdaee8f0978d8c91e1953891c126fb4ff3c30');
insert into repeated_id_SO (fingerprint) values ('f9f70077bff94969349664506e4b2ce37a7c06fb');
insert into repeated_id_SO (fingerprint) values ('86cfc3c6070052825494c31e64e82c3b4b9729f8');
insert into repeated_id_SO (fingerprint) values ('f618aa58a5d7d09dabef0e0a1b89df237fa61f79');
insert into repeated_id_SO (fingerprint) values ('de9025e82afdb9d8b075e377b112c117fd7595c7');
insert into repeated_id_SO (fingerprint) values ('530b7aaa7b38343b05beb3a0c43897fc3c5daa41');
insert into repeated_id_SO (fingerprint) values ('49938eeacd10a1c63800033d4d1af7ca5ea16f0a');
insert into repeated_id_SO (fingerprint) values ('e2fc6877b712f6d6139e87c21fbb2a13307a1963');
insert into repeated_id_SO (fingerprint) values ('50b52e606f0c3c2f36ea2de249070af6b664489d');
insert into repeated_id_SO (fingerprint) values ('16fb91e64b7558e605f8d9a69afb709fc76777fe');
insert into repeated_id_SO (fingerprint) values ('7ad2010470bbde1cc900a0b0d0cd77675bbf7e45');
insert into repeated_id_SO (fingerprint) values ('7065c147e392cf188901316d6b16e4828c7ce709');
insert into repeated_id_SO (fingerprint) values ('1bd1eed5bc228293e6d406f0f5fda144bebf626d');
insert into repeated_id_SO (fingerprint) values ('089f21bca6182b7536d961007ac6de14a5ee497a');
insert into repeated_id_SO (fingerprint) values ('8628d6d60376cc17415555d83f3aca562b47cbce');
insert into repeated_id_SO (fingerprint) values ('654958d75d3676481ffe8c5c3a66eed197ab04a0');
insert into repeated_id_SO (fingerprint) values ('69a58e28293b7cd1a8b17e1747f72474df6cd2c0');
insert into repeated_id_SO (fingerprint) values ('b0d533803e8f5c014a2e99828079bd97f7592f1d');
insert into repeated_id_SO (fingerprint) values ('d70d79cf885edc9b5dabb703e2026561f7dbe068');
insert into repeated_id_SO (fingerprint) values ('3942f085604e6ce2dde556a714732fe73325462a');
insert into repeated_id_SO (fingerprint) values ('70d39f4a878331f388f120d65b0ef56e2200aa25');
insert into repeated_id_SO (fingerprint) values ('17f95b768d59f7dae55135ace19b41f32608bcf2');
insert into repeated_id_SO (fingerprint) values ('837cb1d6f6150ccf8b2233ef8a17461533bc5ffe');
insert into repeated_id_SO (fingerprint) values ('7982148cfca2bdf2886f78639ac5b3aa6a162dce');
insert into repeated_id_SO (fingerprint) values ('b3444c48d3561051afc112fe97c84624878884fd');
insert into repeated_id_SO (fingerprint) values ('ce1812ac76f8db68626f59da296025fc641d7392');
insert into repeated_id_SO (fingerprint) values ('95d4b909ce7842b8e50342359b937ffe36dc9f1f');
insert into repeated_id_SO (fingerprint) values ('34df0b431be619f2e38444faab1c0ceab2e04ccb');
insert into repeated_id_SO (fingerprint) values ('9fd69585d68d83474b5ec3b3aa8873eedc345ebb');
insert into repeated_id_SO (fingerprint) values ('f4e1ee8279e8c8117119f2110aeec575cb596441');
insert into repeated_id_SO (fingerprint) values ('e957e1432932c1d8be343dc3d42a867c05102b11');
insert into repeated_id_SO (fingerprint) values ('4483a2bf8ef3bfa363aa853d69674fbc6eccb5a1');
insert into repeated_id_SO (fingerprint) values ('15f6782858b90758042731edd4a6bbdd9b2df163');
insert into repeated_id_SO (fingerprint) values ('c05244cbef8643cce76872dba40231fa0c2c92ca');
insert into repeated_id_SO (fingerprint) values ('57d976d21217297b8f0354081171ffea882be1da');
insert into repeated_id_SO (fingerprint) values ('40a86ee85147c7b085b4a74fc975b0ff192b5cca');
insert into repeated_id_SO (fingerprint) values ('7b718d41b9fe56e31b99020374fe22e64ebd4de9');
insert into repeated_id_SO (fingerprint) values ('61dfee9620cc5cea6d52ae58605a82bdc54ed836');
insert into repeated_id_SO (fingerprint) values ('783de6819fb43a81a74ccf90683095a35f6b2176');
insert into repeated_id_SO (fingerprint) values ('e986be8e3d56dfff778639892d923e21cc03b456');
insert into repeated_id_SO (fingerprint) values ('54e7d9e6adaef593ad927d7225ba6eb57cc91c2b');
insert into repeated_id_SO (fingerprint) values ('3c5a99bf4ac56215471115bf09eee2eb3edb3341');
insert into repeated_id_SO (fingerprint) values ('ee9cf05bd1f6b62435bc7c5a8a4598f59b9852a8');
insert into repeated_id_SO (fingerprint) values ('53e2e1e8a21fbc65bac8e0b2dffc95478bb1bbb6');
insert into repeated_id_SO (fingerprint) values ('da1ce7065ae3b6f5c0ed7926efbd88d150860080');
insert into repeated_id_SO (fingerprint) values ('b28df2d197ca097d13f7cf0b46903fc78370d31f');
insert into repeated_id_SO (fingerprint) values ('ce4b02e6d8d7af2d00b53d97e3aaa9e9edc86e25');
insert into repeated_id_SO (fingerprint) values ('a55d84aae5e9327b4c13055d56bce0aa4e96c4d3');
insert into repeated_id_SO (fingerprint) values ('88f91ccfad3aab94bf90a8692ed47c26dcffdd37');
insert into repeated_id_SO (fingerprint) values ('698ede89e1cddcdcf95a62cc9ac6afee6882c289');
insert into repeated_id_SO (fingerprint) values ('10ae8bf6677b45e10b0f4aa255859830108fa465');
insert into repeated_id_SO (fingerprint) values ('86d0771a5d6cf1927fcd5c645301800e2ef56975');
insert into repeated_id_SO (fingerprint) values ('317f0e58ada383f7a9e596f2285e2910f48fc189');
insert into repeated_id_SO (fingerprint) values ('bba63bdb7cef5f1ca5c2ab4c3f951b2591ef331e');
insert into repeated_id_SO (fingerprint) values ('c09dc12d90286a21eb2b260b7276e37fc9df24c9');
insert into repeated_id_SO (fingerprint) values ('e306a34c8a15107f8c3da64fdadd2662b4294325');
insert into repeated_id_SO (fingerprint) values ('a1487228eac3e94598e87f7f11a5bb5f7ecc6953');
insert into repeated_id_SO (fingerprint) values ('ccd1a95894c32b92e3af64b9539a12a375ff3078');
insert into repeated_id_SO (fingerprint) values ('70a8ab5192b2454b006e1197b36add194ddc8b2c');
insert into repeated_id_SO (fingerprint) values ('5db52df269da7fd507e52159f7785425f5c2341a');
insert into repeated_id_SO (fingerprint) values ('162e6c7f6d845b812b433e95cee2c1e167c9acd6');
insert into repeated_id_SO (fingerprint) values ('2f3d66538b2198913026b425cfac53564d3a0468');
insert into repeated_id_SO (fingerprint) values ('2eb64ee6a9f80c59334157c0968715c24de80df9');
insert into repeated_id_SO (fingerprint) values ('284658d13755e5ed14bbb08e0fb0e94b5a8d90bc');
insert into repeated_id_SO (fingerprint) values ('24b398d05755cd5f0b9a63b439f7bcdcbe8b63ae');
insert into repeated_id_SO (fingerprint) values ('dc0135bb86b9b828d862f25aeeed89deda666505');
insert into repeated_id_SO (fingerprint) values ('84e96f7e8c55c151e257ca7382e9ad74b6ad943e');
insert into repeated_id_SO (fingerprint) values ('37d4df4d5e197ff9be757ead65ddb10774306aff');
insert into repeated_id_SO (fingerprint) values ('77d13b2c845c8cf2f0f11f104e4f9f70688b6263');
insert into repeated_id_SO (fingerprint) values ('4f61509d5a4a1cc1dbba601347b776e1982d1953');
insert into repeated_id_SO (fingerprint) values ('1b4dfaf12bff51eb0dc362dfe8fde91ab7b326bb');
insert into repeated_id_SO (fingerprint) values ('8a3aa5be06e16d852cd3112558966d74241a43dd');
insert into repeated_id_SO (fingerprint) values ('3d81f357bf3d51d0f86476d1adebb6b52a5e122b');
insert into repeated_id_SO (fingerprint) values ('c1639f43e5c14c87d6ea7ae3fb87bbe83df0217e');
insert into repeated_id_SO (fingerprint) values ('a65c1e7956b9f0aff0545a91ae8ab3164ae16cd9');
insert into repeated_id_SO (fingerprint) values ('c6e5313d1d6e6078d6846c9f180708cf27b66e93');
insert into repeated_id_SO (fingerprint) values ('d7a7d64442619823fd79d11a8763b8a1e3e14689');
insert into repeated_id_SO (fingerprint) values ('1c0c9942ceda585b93bded77ebe50a79f78ed6bb');
insert into repeated_id_SO (fingerprint) values ('8932e138775abb1d8e1c8e4401837f5bf048621a');
insert into repeated_id_SO (fingerprint) values ('8eb22dbc1da5a79cd4fd445b3e9942acb9ac55e5');
insert into repeated_id_SO (fingerprint) values ('dc57c5e9712686460b5ac25fee4a494bd98be561');
insert into repeated_id_SO (fingerprint) values ('f8600c7bec872029c1fd0fa2a556ff40d16875b5');
insert into repeated_id_SO (fingerprint) values ('f5d87ff9e9a097462c81b0fd5459c1ad2fc92588');
insert into repeated_id_SO (fingerprint) values ('df686855f7df202521e5851c07473f3ea168ae8a');
insert into repeated_id_SO (fingerprint) values ('e9045fcede53450a8ef7fdcee6f0d3500798c01f');
insert into repeated_id_SO (fingerprint) values ('3ac90734ccc0816997034de536201f5eb889702c');
insert into repeated_id_SO (fingerprint) values ('e37c7884e2d7435b216077a64759ad4f0339f8e2');
insert into repeated_id_SO (fingerprint) values ('275ecd542c8d1ac79c00432312b18eecd0f78a8d');
insert into repeated_id_SO (fingerprint) values ('663991f85fb91a760844811e385bd22bc7e82f55');
insert into repeated_id_SO (fingerprint) values ('5a888a9747c68a654ea10cc1be23f36ce92f1419');
insert into repeated_id_SO (fingerprint) values ('d46abbecb16bfc3925a84c3ca71e72353bb7de0a');
insert into repeated_id_SO (fingerprint) values ('81771a6cc137fc54a22bd2bee2457c5756ac3f33');
insert into repeated_id_SO (fingerprint) values ('e906265730ca056cd2fee73ec919b3a86bef0490');
insert into repeated_id_SO (fingerprint) values ('ed68e13a3f9fa782286ff7673ebae7c77bdd0444');
insert into repeated_id_SO (fingerprint) values ('c50a1026073f08603f2a0d9378384d588b54e377');
insert into repeated_id_SO (fingerprint) values ('2ef81e83c63f32d576ae019ec5e047e95343f90e');
insert into repeated_id_SO (fingerprint) values ('1fbc85857fc198028ae2ac80019ed76887ec33ea');
insert into repeated_id_SO (fingerprint) values ('115eada79afeb3e265029e65c47b28755bde2543');
insert into repeated_id_SO (fingerprint) values ('de3e870b7a2a083c1ee39c4813384c4de6071a51');
insert into repeated_id_SO (fingerprint) values ('b0851a187256c72d8fe52f684df2e3927bb2d2ac');
insert into repeated_id_SO (fingerprint) values ('715871446b5eb1267ee3c625511a6c5a3f758140');
insert into repeated_id_SO (fingerprint) values ('7029fca689e006ad574264a5d51582796810ece6');
insert into repeated_id_SO (fingerprint) values ('787b5cbcdce4b4f6a5e65eee8014a054fa7da14d');
insert into repeated_id_SO (fingerprint) values ('ffcb2fb5c261e8db280c90fde8161b33117c1de9');
insert into repeated_id_SO (fingerprint) values ('4969688fd80d040a949d3c2cb6cab4eb02102ecf');
insert into repeated_id_SO (fingerprint) values ('ec90d1d63d98781b6be0eefa565413babe5d7e73');
insert into repeated_id_SO (fingerprint) values ('08ed5a1abfa02feb7d67beb4f6b01690979e58b3');
insert into repeated_id_SO (fingerprint) values ('5305110e5e8332d091234dfd30d705693b55a272');
insert into repeated_id_SO (fingerprint) values ('817590df956052ba60127626ce1272480e506011');
insert into repeated_id_SO (fingerprint) values ('3491c929a65fb66e0086807d8cb7c839f2669d49');
insert into repeated_id_SO (fingerprint) values ('a09cd5b19e3bbf7d082b7833d93b078c0177856d');
insert into repeated_id_SO (fingerprint) values ('878009fc78acb00f0534aa1d2e591f5fd312df86');
insert into repeated_id_SO (fingerprint) values ('b6cc54486277655792260f753b093d08048c78cd');
insert into repeated_id_SO (fingerprint) values ('560aa371d9964aeb7fefb9bfc2e5222964cda6f0');
insert into repeated_id_SO (fingerprint) values ('f3b80d1c5cf66d60758bd3860a7a8fdb50ac73e4');
insert into repeated_id_SO (fingerprint) values ('86839568c98d5df61146b591e4ccfb771e096347');
insert into repeated_id_SO (fingerprint) values ('caf7dc5e68c7764e5b2c18927f1ab74f7295c06a');
insert into repeated_id_SO (fingerprint) values ('7d923ab8c3579622f01fbee4a50768690bac9206');
insert into repeated_id_SO (fingerprint) values ('f736537465ecf777617b018bcf6bce92b16ad04c');
insert into repeated_id_SO (fingerprint) values ('e36d135e76aaae0115ee26d32c2b298c3b587c27');
insert into repeated_id_SO (fingerprint) values ('a7908d30369d0ab78de99297d24607b113ab1668');
insert into repeated_id_SO (fingerprint) values ('34d89a3dd1b62dda34b7ce09504e9fcf0a9be152');
insert into repeated_id_SO (fingerprint) values ('24cca842457b2f2116885c4211dcb7318ccadcb8');
insert into repeated_id_SO (fingerprint) values ('f2520a0df53ae33b57da4bd831aa2ff1cc9da74f');
insert into repeated_id_SO (fingerprint) values ('9037722c3956c7177628bd126bcce52b9e8ff6bb');
insert into repeated_id_SO (fingerprint) values ('7c49035916619096956e630b44471adcd7e195aa');
insert into repeated_id_SO (fingerprint) values ('906b19cc457209f6d4678abd0d683231e613d5c8');
insert into repeated_id_SO (fingerprint) values ('e97b29be0dde7ffbbed5fcb075e025308d01db00');
insert into repeated_id_SO (fingerprint) values ('f3a4fabe7e471ea385e6d6a95ae5e6c4437f7021');
insert into repeated_id_SO (fingerprint) values ('d6463b2e9ce01a6a77f794914a7850958fa5ccff');
insert into repeated_id_SO (fingerprint) values ('872d91cd538567411467537e383826d2b3f97316');
insert into repeated_id_SO (fingerprint) values ('aeac5d6284ddda29b1778d4ab3be6490de11e00c');
insert into repeated_id_SO (fingerprint) values ('00390f6c37705f98aabadc0502da4d3f1331a0f1');
insert into repeated_id_SO (fingerprint) values ('89d9d6532efea116b255e224488aa55fd2d65ccf');
insert into repeated_id_SO (fingerprint) values ('f2d27179a6179a0040943325edc9a26f1f3b7172');
insert into repeated_id_SO (fingerprint) values ('c7703c7e835e4fa0cc953af62388b6a1fdc7d6d4');
insert into repeated_id_SO (fingerprint) values ('ebff815c1e515eeca13020a2652e69f849a87aaf');
insert into repeated_id_SO (fingerprint) values ('c866a6f3a3e6d570782ac8c7b80a4414f63cb8b4');
insert into repeated_id_SO (fingerprint) values ('0f8e86db7d1ebb4e2981786e5fc16cd937fe3464');
insert into repeated_id_SO (fingerprint) values ('2e2ffa222b95fe13d4221b0fcef0bc980108813b');
insert into repeated_id_SO (fingerprint) values ('b7a63ad0de742f326213bb7956ae5432cce9df4d');
insert into repeated_id_SO (fingerprint) values ('4b0d7dc9f3da9b14e5df3c94801233a2a6a5ea70');
insert into repeated_id_SO (fingerprint) values ('0b8d90b1ae03a835027d3fe64fc10699b4e4fa8c');
insert into repeated_id_SO (fingerprint) values ('5dee6545a51321fc07d518ad437fe034866ed545');
insert into repeated_id_SO (fingerprint) values ('7f7c5bb6bd91efc162ba54435b960b4af07372c6');
insert into repeated_id_SO (fingerprint) values ('122778b61bc898ce78df656bbf0e7c7b892464f1');
insert into repeated_id_SO (fingerprint) values ('5bce2269be7498a696c46b29abea509a4ed3baaf');
insert into repeated_id_SO (fingerprint) values ('521b6b35f3897c6ca02a3f3a42d07f96a6fb0547');
insert into repeated_id_SO (fingerprint) values ('a4c6ce3f0e0adc3228c4858a6b7ba9564fe68662');


alter table all_missings_SO add column is_duplicate varchar(10);


update all_missings_SO a set is_duplicate = 'f';
update all_missings_SO a set is_duplicate = 't' where a.fingerprint in (select fingerprint from repeated_id_SO);










