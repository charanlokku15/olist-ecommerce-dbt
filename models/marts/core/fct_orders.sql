select
    order_id,
    customer_id,
    order_status,
    order_purchase_at,
    order_approved_at,
    order_delivered_customer_at,
    order_estimated_delivery_at,
    customer_city,
    customer_state
from {{ ref('int_orders_enriched') }}
