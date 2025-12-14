# Olist E-commerce Analytics – dbt + Databricks

## Overview
This project builds a modern analytics warehouse for the Olist Brazilian e-commerce dataset using dbt Core on Databricks. The goal is to take raw transactional data and, through structured transformations, produce clean fact/dimension tables and analytics marts that answer key business questions about customers, orders, products, retention, and revenue.

Using dbt, all warehouse transformations are defined as version-controlled SQL models: raw bronze tables are cleaned in staging, joined and enriched in intermediate layers, modeled into facts and dimensions, and finally aggregated into analytics models such as customer lifetime value, cohort analysis, and product performance.

## Documentation
Interactive dbt docs (lineage, models, tests):

https://charanlokku15.github.io/olist-ecommerce-dbt/#!/overview

## Architecture
- Bronze: Raw Olist CSVs loaded into Databricks Delta tables.
- Silver (staging): `stg_*` models standardize schemas, cast types (including safe `try_cast`), and filter bad or incomplete rows.
- Intermediate: `int_*` models join and enrich orders, customers, order items, and products into analysis-ready views.
- Gold/core marts:
  - `fct_orders`, `fct_order_items` (transaction-level facts)
  - `dim_customers`, `dim_products` (clean, deduplicated dimensions)
- Analytics:
  - `customer_lifetime_value` (LTV and customer segments)
  - `cohort_analysis` (acquisition cohorts and retention)
  - `product_performance` (product-level revenue and review performance)
- Snapshots:
  - `products_snapshot` (tracks changes in product attributes over time)

## What This Project Achieves

## Key Analytic Queries & Visualizations

### 1. Customer Lifetime Value by Segment

- **Business question**  
  Which customer segments generate the highest lifetime revenue so marketing and retention can focus on the most valuable customers?

  - **Visualization**  
  Bar chart with `customer_segment` on the X‑axis and `avg_lifetime_revenue` on the Y‑axis (one bar per segment).

- **Screenshot**
  ![CLV by segment](/Users/charanlokku/Downloads/clv_by_segment.png)

- Transforms raw Olist source tables into a well-modeled star schema suitable for BI tools and downstream analytics.
- Implements clear separation of concerns with a medallion (bronze/silver/gold) architecture, making the pipeline easier to understand, debug, and extend.
- Provides analytics tables that directly answer business questions:
  - Which customers are most valuable over their lifetime?
  - How do monthly cohorts retain over time?
  - Which products drive the most revenue and have the best/worst reviews?
- Enforces data quality with tests and a custom business rule to prevent negative revenue.
- Publishes interactive dbt documentation (models, columns, tests, lineage) via GitHub Pages.

## Why This Tech Stack?
- **dbt Core**
  - Treats SQL transformations as code: modular models, explicit dependencies, and reproducible builds.
  - Built-in testing (`not_null`, `unique`, `relationships`, custom tests) ensures trust in the warehouse.
  - Auto-generated documentation and lineage diagrams make the model understandable to both engineers and analysts.

- **Databricks + Delta Lake**
  - Scales to larger datasets and fits the lakehouse / medallion architecture pattern commonly used in modern data platforms.
  - Delta Lake provides ACID tables and good performance for both development and analytics workloads.
  - Databricks SQL works seamlessly with dbt’s adapter for building views, tables, and snapshots.

- **Warehouse + Transformations with dbt**
  - The warehouse isn’t just storage: dbt models perform all business logic and cleaning *inside* the data platform.
  - Staging, intermediate, fact/dimension, and analytics models are all expressed as SQL transformations managed by dbt.
  - Snapshots capture slowly changing data over time without manually managing history tables.

- **Git, GitHub, GitHub Pages**
  - Version control for all transformations, tests, and configs.
  - Public GitHub repo showcases the project for hiring managers.
  - GitHub Pages hosts dbt docs so anyone can explore models and lineage via a browser.

## Data Quality
- Tests:
  - `not_null` and `unique` on key dimension and fact columns.
  - `relationships` test to enforce referential integrity between `fct_order_items.order_id` and `fct_orders.order_id`.
- Analytics tests:
  - `not_null` on key analytics columns (e.g., `customer_id`, `cohort_month`, `product_id`, `total_revenue`).
- Custom test:
  - `assert_positive_revenue` to ensure `(price + freight_value) >= 0` in `fct_order_items`.
- Snapshot:
  - `products_snapshot` to track changes in product attributes over time.

## How to Run
\`\`\`bash
dbt deps
dbt run
dbt test
dbt docs generate
# optional
dbt build
\`\`\`

## Tech Stack
dbt Core, Databricks, Delta Lake, SQL, Python, Git
