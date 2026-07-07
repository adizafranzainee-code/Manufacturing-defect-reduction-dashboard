-- ============================================================
-- 06_handling_method_analysis.sql
-- Business question: Which handling method is most associated
-- with damage?
-- Output: Defect by handling method chart (Page 3 / RCA)
-- ============================================================

SELECT
    handling_method,
    SUM(defect_qty)                                                    AS total_defect_qty,
    SUM(rework_cost_myr)                                               AS total_rework_cost_myr,
    ROUND(SUM(defect_qty) * 100.0 / SUM(SUM(defect_qty)) OVER (), 2)   AS pct_of_total
FROM defect_records
GROUP BY handling_method
ORDER BY total_defect_qty DESC;
