{#
  Fact table: one row per appointment. Foreign keys to the core dims plus
  the billing rollup for that visit.
#}

select
    appointment_id,
    appointment_date        as date_key,
    patient_id,
    provider_id,
    clinic_id,
    primary_payer_id        as payer_id,

    appointment_type,
    appointment_status,
    primary_diagnosis_code,

    is_completed,
    is_no_show,
    is_cancelled,

    charge_line_count,
    total_charged,
    total_paid,
    total_outstanding
from {{ ref('int_appointments_enriched') }}
