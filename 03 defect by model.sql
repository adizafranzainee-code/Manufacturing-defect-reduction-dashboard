-- ============================================================
-- 03_defect_by_model.sql
-- Business question: Which model has the highest defect rate?
-- Output: Defect by model bar chart (Page 2)
-- Note: normalized by output, not raw defect qty, so models
-- with higher production volume aren't unfairly flagged.
-- ============================================================

WITH defect_agg AS (
    -- Collapse defect_records to one row per production key FIRST,
    -- then join, to avoid inflating output_qty via fan-out.
    SELECT date, line, shift, model, SUM(defect_qty) AS defect_qty
    FROM defect_records
    GROUP BY date, line, shift, model
)
SELECT
    p.model,
    SUM(p.output_qty)                                                        AS total_output_qty,
    SUM(COALESCE(da.defect_qty, 0))                                          AS total_defect_qty,
    ROUND(SUM(COALESCE(da.defect_qty, 0)) * 100.0 / SUM(p.output_qty), 2)    AS defect_rate_pct
FROM production_output p
LEFT JOIN defect_agg da
    ON p.date = da.date
   AND p.line = da.line
   AND p.shift = da.shift
   AND p.model = da.model
GROUP BY p.model
ORDER BY defect_rate_pct DESC;
