with providers as (
    select * from {{ ref('stg_healthcare__providers') }}
),

clinics as (
    select clinic_id, clinic_name from {{ ref('stg_healthcare__clinics') }}
)

select
    p.provider_id,
    p.provider_name,
    p.credential,
    p.provider_status,
    p.is_active,
    p.hire_date,
    c.clinic_name   as home_clinic
from providers p
left join clinics c on p.home_clinic_id = c.clinic_id
