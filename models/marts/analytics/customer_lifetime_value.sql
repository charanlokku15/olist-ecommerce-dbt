with customer_orders as (
    select
        o.customer_id,
        min(o.order_purchase_at) as first_order_at,
        max(o.order_purchase_at) as last_order_at,
        count(distinct o.order_id) as orders_count,
        sum(oi.price + oi.freight_value) as total_revenue
    from {{ ref('fct_orders') }} o
    join {{ ref('fct_order_items') }} oi
        on o.order_id = oi.order_id
    group by o.customer_id
),

recency_base as (
    select max(last_order_at) as max_order_date
    from customer_orders
),

scored as (
    select
        c.customer_id,
        c.first_order_at,
        c.last_order_at,
        c.orders_count,
        c.total_revenue,
        datediff(r.max_order_date, c.last_order_at) as recency_days,
        case
            when c.total_revenue >= 1000 then 'High'
            when c.total_revenue >= 300 then 'Medium'
            else 'Low'
        end as revenue_segment,
        case
            when c.orders_count >= 5 then 'Frequent'
            when c.orders_count >= 2 then 'Occasional'
            else 'One-time'
        end as frequency_segment
    from customer_orders c
    cross join recency_base r
),

final as (
    select
        customer_id,
        first_order_at,
        last_order_at,
        orders_count,
        total_revenue,
        recency_days,
        revenue_segment,
        frequency_segment,
        concat(revenue_segment, ' / ', frequency_segment) as customer_segment,
        current_timestamp() as dbt_updated_at
    from scored
)

select * from final
