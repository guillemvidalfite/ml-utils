-- A quick evaluation grouped by TSE
SELECT 
      tse,
      train_welds, 
      predictions,
      train_repairs,
      test_repairs,
      tp, fp, tn, fn,
      ROUND(TP::decimal * 100 / NULLIF((TP + FN), 0), 2) as recall,
      ROUND(TP::decimal * 100 / NULLIF((TP + FP), 0), 2) as precision,
      ROUND(train_repairs::decimal * 1000 / NULLIF((train_welds + predictions), 0), 4) as rep_per_1k,
      class_welds,
      class_repairs,
      ROUND(class_repairs::decimal * 100 / NULLIF(class_welds, 0), 4) as rep_per_100_class
FROM (SELECT tse,
      train_repairs,
      test_repairs,
      COUNT(*) FILTER (WHERE dataset = 'train') as train_welds,
      COUNT(*) FILTER (WHERE dataset != 'train') as predictions,
      COUNT(*) FILTER (WHERE repaired is true AND score >= threshold AND dataset != 'train') as TP,
      COUNT(*) FILTER (WHERE repaired is false AND score >= threshold AND dataset != 'train') as FP,
      COUNT(*) FILTER (WHERE repaired is false AND score < threshold AND dataset != 'train') as TN,
      COUNT(*) FILTER (WHERE repaired is true AND score < threshold AND dataset != 'train') as FN,
      COUNT(*) FILTER (WHERE score >= 0.55 AND dataset != 'train') as class_welds,
      COUNT(*) FILTER (WHERE repaired is true AND score >= 0.55 AND dataset != 'train') as class_repairs
      FROM predictions JOIN (SELECT tse, COALESCE(train_t5, 0.6) as threshold, 
                                    train_repairs, 
                                    test_repairs + val_repairs as test_repairs
                             FROM thresholds) t USING(tse)
      GROUP BY tse, train_repairs, test_repairs
      ORDER BY tse desc) a;

-- A quick evaluation grouped by TSE
SELECT tse,
      train_welds,
      predictions,
      train_repairs,
      test_repairs,
      tp, fp, tn, fn,
      ROUND(TP::decimal * 100 / NULLIF((TP + FN), 0), 2) as recall,
      ROUND(TP::decimal * 100 / NULLIF((TP + FP), 0), 2) as precision,
      ROUND(FP::decimal * 100 / NULLIF((TP + FP + TN + FN), 0), 2) as FPR,
      ROUND(train_repairs::decimal * 1000 / NULLIF((train_welds + predictions), 0), 4) as rep_per_1k,
      train_body_repairs,
      test_body_repairs,
      train_assembly_repairs,
      test_assembly_repairs,
      class_welds,
      class_repairs,
      ROUND(class_repairs::decimal * 100 / NULLIF(class_welds, 0), 4) as rep_per_100_class,
      anomaly
FROM (SELECT tse,
      train_repairs,
      test_repairs,
      COUNT(*) FILTER (WHERE dataset = 'train') as train_welds,
      COUNT(*) FILTER (WHERE dataset != 'train') as predictions,
      COUNT(*) FILTER (WHERE repaired is true AND score >= threshold AND dataset != 'train') as TP,
      COUNT(*) FILTER (WHERE repaired is false AND score >= threshold AND dataset != 'train') as FP,
      COUNT(*) FILTER (WHERE repaired is false AND score < threshold AND dataset != 'train') as TN,
      COUNT(*) FILTER (WHERE repaired is true AND score < threshold AND dataset != 'train') as FN,
      COUNT(*) FILTER (WHERE repaired is true AND body_repair = true AND dataset = 'train') as train_body_repairs,
      COUNT(*) FILTER (WHERE repaired is true AND body_repair = true AND dataset != 'train') as test_body_repairs,
      COUNT(*) FILTER (WHERE repaired is true AND assembly_repair = true AND dataset = 'train') as train_assembly_repairs,
      COUNT(*) FILTER (WHERE repaired is true AND assembly_repair = true AND dataset != 'train') as test_assembly_repairs,
      COUNT(*) FILTER (WHERE score >= 0.55 AND dataset != 'train') as class_welds,
      COUNT(*) FILTER (WHERE repaired is true AND score >= 0.55 AND dataset != 'train') as class_repairs
      FROM predictions JOIN (SELECT tse,
                                    0.60 as threshold,
                                    train_repairs,
                                    test_repairs + val_repairs as test_repairs
                             FROM thresholds) t USING(tse)
      GROUP BY tse, train_repairs, test_repairs
      ORDER BY tse desc) a 
      LEFT JOIN resources r using (tse);


-- A quick evaluation grouped by TSE
SELECT tse,
      train_welds,
      predictions,
      train_repairs,
      test_repairs,
      train_body_repairs,
      test_body_repairs,
      train_assembly_repairs,
      test_assembly_repairs
FROM (SELECT tse,
      train_repairs,
      test_repairs,
      COUNT(*) FILTER (WHERE dataset = 'train') as train_welds,
      COUNT(*) FILTER (WHERE dataset != 'train') as predictions,
      COUNT(*) FILTER (WHERE repaired is true AND score >= threshold AND dataset != 'train') as TP,
      COUNT(*) FILTER (WHERE repaired is false AND score >= threshold AND dataset != 'train') as FP,
      COUNT(*) FILTER (WHERE repaired is false AND score < threshold AND dataset != 'train') as TN,
      COUNT(*) FILTER (WHERE repaired is true AND score < threshold AND dataset != 'train') as FN,
      COUNT(*) FILTER (WHERE repaired is true AND body_repair = true AND dataset = 'train') as train_body_repairs,
      COUNT(*) FILTER (WHERE repaired is true AND body_repair = true AND dataset != 'train') as test_body_repairs,
      COUNT(*) FILTER (WHERE repaired is true AND assembly_repair = true AND dataset = 'train') as train_assembly_repairs,
      COUNT(*) FILTER (WHERE repaired is true AND assembly_repair = true AND dataset != 'train') as test_assembly_repairs,
      COUNT(*) FILTER (WHERE score >= 0.55 AND dataset != 'train') as class_welds,
      COUNT(*) FILTER (WHERE repaired is true AND score >= 0.55 AND dataset != 'train') as class_repairs
      FROM predictions JOIN (SELECT tse,
                                    0.60 as threshold,
                                    train_repairs,
                                    test_repairs + val_repairs as test_repairs
                             FROM thresholds) t USING(tse)
      GROUP BY tse, train_repairs, test_repairs
      ORDER BY tse desc) a 
      LEFT JOIN resources r using (tse);





COPY 
(SELECT tse, carbody_id, stud_id, fingerprint, timestamp, score, body_repair, assembly_repair, repaired, alert, classification, class_confidence
FROM
(SELECT tse, carbody_id, stud_id, fingerprint, timestamp, score, body_repair, assembly_repair, repaired, score >= threshold as alert, classification, class_confidence, dataset
   FROM predictions LEFT JOIN (SELECT tse, COALESCE(train_t5, 0.6) as threshold
                 FROM thresholds) t USING (tse)) x) TO '/tmp/repair_flags.csv' DELIMITER ',' CSV HEADER;



(if (and (= (f "repaired") "t") (= (f "alert") "t")) "TP"
    (if (and (= (f "repaired") "t") (= (f "alert") "f")) "FN"
        (if (and (= (f "repaired") "f") (= (f "alert") "t")) "FP" "TN")
    )
)

yyyy-MM-dd HH:mm:ss-SS


(or (= (f "repaired_at") "Assembly Shop") 
    (and (= (f "repaired_at") "Body Shop") (or (= (f "error_code") "3000") (= (f "error_code") "2000")))
)