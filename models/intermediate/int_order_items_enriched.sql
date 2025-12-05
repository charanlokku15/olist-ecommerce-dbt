with items as (
    select * from {{ ref('stg_order_items') }}
),
products as (
    select * from {{ ref('stg_products') }}
),
orders as (
    select
        order_id,
        order_status,
        order_purchase_at
    from {{ ref('stg_orders') }}
)

select
    i.*,
    p.product_category_name,
    o.order_status,
    o.order_purchase_at
from items i
left join products p
    on i.product_id = p.product_id
left join orders o
    on i.order_id = o.order_id
