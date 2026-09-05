with source as (
    select * from {{ source('healthcare', 'patients') }}
),

renamed as (
    select
        patient_id,
        first_name,
        last_name,
        date_of_birth,
        {{ patient_age('date_of_birth') }}  as age,
        upper(sex)                          as sex,
        primary_clinic_id,
        first_visit_date
    from source
)

select * from renamed
