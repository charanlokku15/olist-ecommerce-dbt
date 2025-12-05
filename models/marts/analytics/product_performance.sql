with orders as (
    select * from {{ ref('int_orders_enriched') }}
),

product_metrics as (
    select
        product_id,
        product_category_name,
        
        -- Sales metrics
        count(distinct order_id) as total_orders,
        sum(price) as total_revenue,
        avg(price) as avg_price,
        sum(freight_value) as total_freight,
        
        -- Calculated metrics
        sum(price + freight_value) as total_value,
        avg(price + freight_value) as avg_order_item_value
        
    from {{ ref('fct_order_items') }}  -- IMPORTANT: use items fact, not orders
    group by product_id, product_category_name
),

product_reviews as (
    select
        oi.product_id,
        avg(r.review_score) as avg_review_score,
        count(r.review_id) as review_count
    from {{ ref('stg_order_items') }} oi
    inner join {{ ref('stg_order_reviews') }} r 
        on oi.order_id = r.order_id
    group by oi.product_id
),

final as (
    select
        pm.product_id,
        pm.product_category_name,
        pm.total_orders,
        pm.total_revenue,
        pm.avg_price,
        pm.total_freight,
        pm.total_value,
        
        -- Review metrics
        coalesce(pr.avg_review_score, 0) as avg_review_score,
        coalesce(pr.review_count, 0) as review_count,
        
        -- Product ranking
        rank() over (order by pm.total_revenue desc) as revenue_rank,
        rank() over (order by pm.total_orders desc) as order_rank,
        
        current_timestamp() as dbt_updated_at
        
    from product_metrics pm
    left join product_reviews pr on pm.product_id = pr.product_id
)

select * from final
