with source as (
    select * from {{ source('bronze', 'order_reviews') }}
),

cleaned as (
    select
        review_id,
        order_id,
        try_cast(review_score as int) as review_score,
        review_comment_title,
        review_comment_message,
        cast(review_creation_date as timestamp) as review_created_date,
        cast(review_answer_timestamp as timestamp) as review_answered_at,
        current_timestamp() as dbt_loaded_at
    from source
    where review_id is not null
      and order_id is not null 
       -- keep only rows where review_score is actually numeric
      and try_cast(review_score as int) is not null
)

select * from cleaned
