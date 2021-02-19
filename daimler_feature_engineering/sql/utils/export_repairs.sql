
# locate into csv files directory and connect to proper db


# 1: extract all repairs information into a csv file:
COPY (SELECT tse, fingerprint, score, body_repair, assembly_repair, repaired, score >= threshold as alert, classification, class_confidence
      FROM predictions LEFT JOIN (SELECT tse, COALESCE(train_t5, 0.6) as threshold
                                  FROM thresholds) t USING (tse)) TO '/tmp/repair_flags.csv' DELIMITER ',' CSV HEADER;


COPY 
(SELECT tse, fingerprint, score, body_repair, assembly_repair, repaired, alert, classification, class_confidence
 FROM
(SELECT tse, fingerprint, score, body_repair, assembly_repair, repaired, score >= threshold as alert, classification, class_confidence, dataset
      FROM predictions LEFT JOIN (SELECT tse, COALESCE(train_t5, 0.6) as threshold
                                  FROM thresholds) t USING (tse)) x
 WHERE dataset != 'train' ) TO '/tmp/repair_flags.csv' DELIMITER ',' CSV HEADER;


 #### with training:
 COPY 
(SELECT tse, fingerprint, score, body_repair, assembly_repair, repaired, alert, classification, class_confidence
 FROM
(SELECT tse, fingerprint, score, body_repair, assembly_repair, repaired, score >= threshold as alert, classification, class_confidence, dataset
      FROM predictions LEFT JOIN (SELECT tse, COALESCE(train_t5, 0.6) as threshold
                                  FROM thresholds) t USING (tse)) x) TO '/tmp/repair_flags.csv' DELIMITER ',' CSV HEADER;

                             


# 2: concatenate test and validation files for interesting tse

# 3: export all resulting files into a specific directory