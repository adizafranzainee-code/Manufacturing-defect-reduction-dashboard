-- ============================================================
-- 05_process_stage_analysis.sql
-- Business question: Which process stage creates the highest damage?
-- Output: Defect by process stage chart (Page 3 / RCA)
-- ============================================================

SELECT
    process_stage,
    SUM(defect_qty)                                                    AS total_defect_qty,
    SUM(rework_cost_myr)                                               AS total_rework_cost_myr,
    ROUND(SUM(defect_qty) * 100.0 / SUM(SUM(defect_qty)) OVER (), 2)   AS pct_of_total
FROM defect_records
GROUP BY process_stage
ORDER BY total_defect_qty DESC;
