{#
  Charge line enriched with its payment activity.
  Grain: one row per charge_id.
  Computes paid amount, outstanding balance, denial/paid flags, and the
  lag from service date to first payment. This is the backbone of the
  revenue-cycle marts.
#}

with charges as (
    select * from {{ ref('stg_healthcare__charges') }}
),

payments as (
    select
        charge_id,
        sum(payment_amount)   as total_paid,
        min(payment_date)     as first_payment_date,
        count(*)              as payment_count
    from {{ ref('stg_healthcare__payments') }}
    group by 1
),

joined as (
    select
        c.charge_id,
        c.appointment_id,
        c.patient_id,
        c.provider_id,
        c.clinic_id,
        c.payer_id,
        c.service_date,
        c.cpt_code,
        c.units,
        c.charge_amount,

        coalesce(p.total_paid, 0)                   as paid_amount,
        c.charge_amount - coalesce(p.total_paid, 0) as outstanding_amount,
        p.first_payment_date,
        coalesce(p.payment_count, 0)                as payment_count,

        -- adjudication status
        (p.charge_id is null)                       as is_denied_or_unpaid,
        (p.charge_id is not null)                   as is_paid,

        -- days from service to first payment (null if never paid)
        datediff('day', c.service_date, p.first_payment_date) as days_to_payment
    from charges c
    left join payments p on c.charge_id = p.charge_id
)

select * from joined
