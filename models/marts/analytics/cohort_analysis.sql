with customer_first_order as (
    select
        customer_id,
        date_trunc('month', min(order_purchase_at)) as cohort_month,
        min(order_purchase_at) as first_order_at
    from {{ ref('fct_orders') }}
    group by customer_id
),

orders_by_month as (
    select
        o.customer_id,
        date_trunc('month', o.order_purchase_at) as order_month,
        count(distinct o.order_id) as orders_in_month
    from {{ ref('fct_orders') }} o
    group by o.customer_id, date_trunc('month', o.order_purchase_at)
),

joined as (
    select
        c.customer_id,
        c.cohort_month,
        o.order_month,
        datediff(o.order_month, c.cohort_month) / 30 as months_since_first_order,
        o.orders_in_month
    from customer_first_order c
    join orders_by_month o
        on c.customer_id = o.customer_id
),

cohort_stats as (
    select
        cohort_month,
        months_since_first_order,
        count(distinct customer_id) as active_customers
    from joined
    group by cohort_month, months_since_first_order
),

cohort_sizes as (
    select
        cohort_month,
        count(distinct customer_id) as cohort_size
    from customer_first_order
    group by cohort_month
),

final as (
    select
        s.cohort_month,
        s.months_since_first_order,
        s.active_customers,
        c.cohort_size,
        round(s.active_customers * 100.0 / c.cohort_size, 2) as retention_rate_pct
    from cohort_stats s
    join cohort_sizes c using (cohort_month)
)

select * from final
