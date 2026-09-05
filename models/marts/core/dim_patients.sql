with patients as (
    select * from {{ ref('stg_healthcare__patients') }}
),

clinics as (
    select clinic_id, clinic_name from {{ ref('stg_healthcare__clinics') }}
),

final as (
    select
        p.patient_id,
        p.first_name,
        p.last_name,
        p.age,
        case
            when p.age < 18 then '0-17'
            when p.age < 35 then '18-34'
            when p.age < 50 then '35-49'
            when p.age < 65 then '50-64'
            else '65+'
        end                         as age_band,
        p.sex,
        p.first_visit_date,
        c.clinic_name               as primary_clinic
    from patients p
    left join clinics c on p.primary_clinic_id = c.clinic_id
)

select * from final