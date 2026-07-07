-- ============================================================
-- 01_defect_pareto.sql
-- Business question: Which defect type contributes the most damage?
-- Output: Pareto chart source (Page 2) — total qty, % of total,
--         running cumulative % so the 80/20 cutoff is visible.
-- ============================================================

SELECT
    defect_type,
    SUM(defect_qty)                                                    AS total_defect_qty,
    SUM(rework_cost_myr)                                               AS total_rework_cost_myr,
    ROUND(SUM(defect_qty) * 100.0 / SUM(SUM(defect_qty)) OVER (), 2)   AS pct_of_total,
    ROUND(
        SUM(SUM(defect_qty)) OVER (ORDER BY SUM(defect_qty) DESC)
        * 100.0 / SUM(SUM(defect_qty)) OVER (), 2
    )                                                                   AS cumulative_pct
FROM defect_records
GROUP BY defect_type
ORDER BY total_defect_qty DESC;
