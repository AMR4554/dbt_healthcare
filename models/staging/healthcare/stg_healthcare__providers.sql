with source as (
    select * from {{ source('healthcare', 'providers') }}
),

renamed as (
    select
        provider_id,
        first_name,
        last_name,
        first_name || ' ' || last_name  as provider_name,
        credential,
        home_clinic_id,
        hire_date,
        lower(status)                   as provider_status,
        (lower(status) = 'active')      as is_active
    from source
)

select * from renamed
