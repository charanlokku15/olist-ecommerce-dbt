with source as (
    select * from {{ source('bronze', 'order_items') }}
),

cleaned as (
    select
        order_id,
        order_item_id,
        product_id,
        seller_id,
        cast(shipping_limit_date as timestamp) as shipping_limit_at,
        cast(price as decimal(10,2)) as price,
        cast(freight_value as decimal(10,2)) as freight_value,
        current_timestamp() as dbt_loaded_at
    from source
    where order_id is not null
      and product_id is not null
)

select * from cleaned
