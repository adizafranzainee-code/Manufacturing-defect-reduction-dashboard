# Finished Goods Box Damage Reduction — SQL, Power BI & Root Cause Analysis

A manufacturing analytics portfolio project analyzing finished goods packaging damage across
three production lines. Built to demonstrate the full analytics workflow a process engineer
moving into data analytics would actually use: simulate realistic operational data, query it
with SQL, root-cause the defects with Lean/Six Sigma methods, and present it in an interactive
Power BI dashboard.

## Business problem

A manufacturing line is experiencing high finished goods box damage during internal handling
and shipment preparation, driving up rework cost and shipment risk. This project identifies the
top defect contributors, locates the highest-risk process stage, determines the likely root
cause, and tracks the impact of a process change implemented to fix it.

## Key findings

- **Tear and Dent defects account for 84% of all packaging damage** (Pareto analysis) — a
  small number of defect types drive nearly all of the cost.
- **Forklift handling is involved in 47% of all defect events**, more than double the next
  handling method, and concentrates heavily at the **Warehouse** and **Loading** stages
  (21,964 and 15,644 defect units respectively).
- **Replacing forklift transfer with a direct conveyor/AGV flow cut the defect rate from 8.4%
  to 3.0%** — a 5.4 percentage point improvement — with cost per 1,000 units dropping from
  RM 630.61 to RM 223.83.
- Across all 8 tracked improvement actions, total realized savings were **RM 62,800**.
- Model A and the Night shift run consistently hotter (6.9% and 6.8% defect rates) than
  Model C and Day shift (5.6% each), a smaller but real secondary pattern worth monitoring.

## Dataset

Simulated based on a realistic manufacturing defect reduction case, covering January–May 2026
across 3 production lines (A/B/C), 3 models (A/B/C), and 2 shifts (Day/Night). The data was
generated with an embedded, internally consistent story — the patterns above aren't dressed-up
random noise; they were built in deliberately so the analysis has something real to find.

| Table | Rows | Purpose |
|---|---|---|
| `production_output.csv` | 453 | Daily output by line/shift/model |
| `defect_records.csv` | 1,153 | Individual defect events with type, stage, handling method, cost |
| `root_cause_log.csv` | 25 | 5-Why / fishbone entries per defect type |
| `improvement_action.csv` | 8 | Tracked countermeasures with before/after rates and savings |

## Methodology

Standard Lean/Six Sigma structure (Define–Measure–Analyze–Improve–Control):

- **Pareto analysis** — which defect types matter most
- **Trend analysis** — monthly defect rate trajectory and the improvement cutover
- **Stratification** — by line, shift, model, process stage, handling method
- **Correlation** — process stage × handling method matrix, the evidence behind the root cause
- **5-Why** — root cause trace for the top defect type (Tear)
- **Fishbone** — root causes categorized by Method/Machine/Man/Material/Environment
- **Before/after comparison** — quantifying the improvement action's impact

## Tools

Python (dataset generation) → SQLite (query layer) → Power BI Desktop (dashboard).

## Project structure

```
manufacturing-defect-reduction-portfolio/
├── data/                          4 simulated CSVs
├── sql/                           13 tested queries (01-13, numbered by dashboard page)
├── db/                            SQLite database with all 4 tables pre-loaded
├── powerbi/                       Interactive dashboard preview (React) + the built .pbix
├── documentation/
│   └── powerbi_build_guide.md     DAX measures + page-by-page visual specs
└── README.md                      This file
```

## SQL layer

13 queries covering all 9 business questions, organized by dashboard page:

- **01–04** (Pareto & Trend): defect Pareto, monthly trend, defect rate by model, by shift
- **05–08** (Root Cause): by process stage, by handling method, stage×type matrix, stage×handling matrix
- **09–13** (Improvement): before/after defect rate, before/after cost, action impact ranking, action status, total savings

Two real bugs were caught and fixed during this build, worth calling out because they're the
kind of thing that quietly produces wrong numbers if missed:

1. **Fan-out bug**: joining `defect_records` (many rows per production day) directly to
   `production_output` and summing `output_qty` inflates it — each matching defect row
   re-adds the same output figure. Fixed by aggregating defects to one row per key *before*
   joining.
2. **Spurious Power BI relationship**: Power BI's autodetect linked `root_cause_log` and
   `improvement_action` on the shared column name "Action" — but these are two unrelated
   free-text fields with no real foreign key between them. Fixed by deleting the relationship
   and disabling autodetect.

## Power BI dashboard

Four pages, each answering a specific set of business questions:

1. **Executive Summary** — KPI cards, monthly trend, Pareto chart, before/after result, key insight
2. **Pareto & Trend** — full Pareto and trend detail, defect rate by model and shift, slicers
3. **Root Cause Analysis** — process stage and handling method breakdowns, the stage×handling
   matrix (the strongest evidence in the dashboard), fishbone summary, 5-Why trace
4. **Improvement & Control** — before/after defect rate and cost, action status tracker,
   ranked improvement action impact table, control plan for sustaining the gain

Key DAX measures: `Defect Rate %`, `Total Rework Cost`, `Cost per Defect`, before/after period
splits via `CALCULATE` with a date filter, and a running-total measure for the Pareto
cumulative % line. Full formulas are in `documentation/powerbi_build_guide.md`.

## Resume bullet

> Developed a manufacturing defect reduction analytics project using SQL and Power BI to
> analyze packaging damage by defect type, process stage, shift, model, and handling method.
> Built a 4-page interactive dashboard with Pareto analysis, root cause matrices, 5-Why/fishbone
> summaries, and before-after improvement tracking (8.4% → 3.0% defect rate, RM 62,800 in
> tracked savings) to support data-driven countermeasures.

## LinkedIn headline

Manufacturing Defect Reduction Dashboard | SQL + Power BI + Root Cause Analysis
