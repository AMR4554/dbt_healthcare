{#
  Fact table: one row per charge line, with payment outcome.
  This is the grain most revenue-cycle analysis starts from.
#}

with charges as (
    select * from {{ ref('int_charges_with_payments') }}
),

cpt as (
    select cpt_code, cpt_description from {{ ref('ref_cpt_codes') }}
)

select
    c.charge_id,
    c.appointment_id,
    c.service_date          as date_key,
    c.patient_id,
    c.provider_id,
    c.clinic_id,
    c.payer_id,

    c.cpt_code,
    cpt.cpt_description,
    c.units,

    c.charge_amount,
    c.paid_amount,
    c.outstanding_amount,
    c.is_paid,
    c.is_denied_or_unpaid,
    c.days_to_payment
from charges c
left join cpt on c.cpt_code = cpt.cpt_code
