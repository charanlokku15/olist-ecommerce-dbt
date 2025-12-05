with source as (
    select * from {{ source('bronze', 'customers') }}
),

cleaned as (
    select
        customer_id,
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state,
        current_timestamp() as dbt_loaded_at
    from source
    where customer_id is not null
)

select * from cleaned
