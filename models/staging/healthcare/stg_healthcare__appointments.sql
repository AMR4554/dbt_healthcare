with source as (
    select * from {{ source('healthcare', 'appointments') }}
),

renamed as (
    select
        appointment_id,
        patient_id,
        provider_id,
        clinic_id,
        appointment_date,
        appointment_time,
        lower(appointment_type)                     as appointment_type,
        lower(status)                               as appointment_status,
        primary_diagnosis_code,

        -- helpful booleans for downstream aggregation
        (lower(status) = 'completed')               as is_completed,
        (lower(status) = 'no_show')                 as is_no_show,
        (lower(status) = 'cancelled')               as is_cancelled
    from source
)

select * from renamed
