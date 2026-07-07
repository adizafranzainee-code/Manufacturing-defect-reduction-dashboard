-- ============================================================
-- 08_stage_vs_handling_method_matrix.sql
-- Output: Correlation check between handling method and process
-- stage (Page 3 / RCA). This is the evidence behind the 5-Why:
-- if Forklift rows are concentrated in Warehouse/Loading, that
-- supports "forklift transfer" as the root cause rather than a
-- generic stage or handling issue on its own.
-- ============================================================

SELECT
    process_stage,
    SUM(CASE WHEN handling_method = 'Forklift' THEN defect_qty ELSE 0 END) AS forklift,
    SUM(CASE WHEN handling_method = 'AGV'      THEN defect_qty ELSE 0 END) AS agv,
    SUM(CASE WHEN handling_method = 'Manual'   THEN defect_qty ELSE 0 END) AS manual,
    SUM(CASE WHEN handling_method = 'Conveyor' THEN defect_qty ELSE 0 END) AS conveyor,
    SUM(defect_qty)                                                        AS row_total
FROM defect_records
GROUP BY process_stage
ORDER BY row_total DESC;
