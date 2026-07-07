-- ============================================================
-- 02_monthly_defect_trend.sql
-- Business question: What is the total defect qty and defect rate
-- by month, and is it trending up or down?
-- Output: Monthly trend line (Page 1 + Page 2)
-- ============================================================

WITH defect_agg AS (
    -- Collapse defect_records to one row per production key FIRST.
    -- Joining the raw (many-rows-per-day) defect table directly to
    -- production_output would fan out and inflate output_qty.
    SELECT
        date, line, shift, model,
        SUM(defect_qty) AS defect_qty
    FROM defect_records
    GROUP BY date, line, shift, model
),
monthly AS (
    SELECT
        p.month,
        MIN(p.date)                                                 AS month_start,
        SUM(p.output_qty)                                           AS total_output_qty,
        SUM(COALESCE(da.defect_qty, 0))                             AS total_defect_qty
    FROM production_output p
    LEFT JOIN defect_agg da
        ON p.date = da.date
       AND p.line = da.line
       AND p.shift = da.shift
       AND p.model = da.model
    GROUP BY p.month
)
SELECT
    month,
    total_output_qty,
    total_defect_qty,
    ROUND(total_defect_qty * 100.0 / total_output_qty, 2)                       AS defect_rate_pct,
    ROUND(
        ROUND(total_defect_qty * 100.0 / total_output_qty, 2)
        - LAG(ROUND(total_defect_qty * 100.0 / total_output_qty, 2))
          OVER (ORDER BY month_start), 2
    )                                                                           AS mom_change_pct
FROM monthly
ORDER BY month_start;
