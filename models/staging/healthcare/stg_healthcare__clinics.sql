with source as (
    select * from {{ source('healthcare', 'clinics') }}
),

renamed as (
    select
        clinic_id,
        clinic_name,
        city,
        state,
        opened_date
    from source
)

select * from renamed
