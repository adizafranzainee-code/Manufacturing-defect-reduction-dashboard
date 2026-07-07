-- ============================================================
-- 07_stage_vs_defect_type_matrix.sql
-- Output: Matrix visual — process stage (rows) x defect type (cols)
-- (Page 3 / RCA). Pivoted with CASE WHEN since plain SQL has no
-- native PIVOT; MySQL/Postgres/SQLite all support this pattern.
-- ============================================================

SELECT
    process_stage,
    SUM(CASE WHEN defect_type = 'Tear'         THEN defect_qty ELSE 0 END) AS tear,
    SUM(CASE WHEN defect_type = 'Dent'         THEN defect_qty ELSE 0 END) AS dent,
    SUM(CASE WHEN defect_type = 'Crushed'      THEN defect_qty ELSE 0 END) AS crushed,
    SUM(CASE WHEN defect_type = 'Wet'          THEN defect_qty ELSE 0 END) AS wet,
    SUM(CASE WHEN defect_type = 'Label Damage' THEN defect_qty ELSE 0 END) AS label_damage,
    SUM(CASE WHEN defect_type = 'Scratch'      THEN defect_qty ELSE 0 END) AS scratch,
    SUM(defect_qty)                                                        AS row_total
FROM defect_records
GROUP BY process_stage
ORDER BY row_total DESC;
