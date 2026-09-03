with source as (
    select * from {{ source('healthcare', 'payers') }}
),

renamed as (
    select
        payer_id,
        payer_name,
        lower(payer_type)               as payer_type,
        expected_collection_rate
    from source
)

select * from renamed
