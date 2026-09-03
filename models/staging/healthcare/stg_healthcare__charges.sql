with source as (
    select * from {{ source('healthcare', 'charges') }}
),

renamed as (
    select
        charge_id,
        appointment_id,
        patient_id,
        provider_id,
        clinic_id,
        payer_id,
        service_date,
        cpt_code,
        units,
        charge_amount
    from source
)

select * from renamed
