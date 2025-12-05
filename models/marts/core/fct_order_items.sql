select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    price,
    freight_value,
    order_status,
    order_purchase_at,
    product_category_name
from {{ ref('int_order_items_enriched') }}
