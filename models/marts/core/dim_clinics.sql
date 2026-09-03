select
    clinic_id,
    clinic_name,
    city,
    state,
    opened_date
from {{ ref('stg_healthcare__clinics') }}
