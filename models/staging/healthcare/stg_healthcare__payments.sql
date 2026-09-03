with source as (
    select * from {{ source('healthcare', 'payments') }}
),

renamed as (
    select
        payment_id,
        charge_id,
        appointment_id,
        payer_id,
        payment_date,
        payment_amount,
        lower(payment_source)   as payment_source
    from source
)

select * from renamed
