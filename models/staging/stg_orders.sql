with source as (
    select * from {{ source('bronze', 'orders') }}
),

cleaned as (
    select
        order_id,
        customer_id,
        order_status,
        cast(order_purchase_timestamp as timestamp) as order_purchase_at,
        cast(order_approved_at as timestamp) as order_approved_at,
        cast(order_delivered_carrier_date as timestamp) as order_delivered_carrier_at,
        cast(order_delivered_customer_date as timestamp) as order_delivered_customer_at,
        cast(order_estimated_delivery_date as timestamp) as order_estimated_delivery_at,
        current_timestamp() as dbt_loaded_at
    from source
    where order_id is not null
)

select * from cleaned
