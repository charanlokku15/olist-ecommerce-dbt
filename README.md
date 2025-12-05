# Olist E-commerce Analytics – dbt + Databricks

## Overview
End-to-end analytics engineering project modeling the Olist Brazilian e-commerce dataset using dbt Core and Databricks. Implements a medallion architecture and exposes clean fact/dimension tables and analytics marts.

## Architecture
- Bronze: Raw Olist CSVs loaded into Databricks Delta tables.
- Silver (staging): `stg_*` models standardize schemas, types, and filter bad rows.
- Intermediate: `int_*` models join and enrich orders and order items.
- Gold/core marts:
  - `fct_orders`, `fct_order_items`
  - `dim_customers`, `dim_products`
- Analytics:
  - `customer_lifetime_value`
  - `cohort_analysis`
  - `product_performance`
- Snapshots:
  - `products_snapshot` (tracks product attribute changes)

## Data Quality
- Tests: `not_null`, `unique`, `relationships` on key fact/dim columns.
- Analytics tests on key metrics.
- Custom test: `assert_positive_revenue` on `fct_order_items`.

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
