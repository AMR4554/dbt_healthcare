{#
  Revenue-cycle summary by month and clinic.
  Metrics: gross charges, payments received, outstanding AR, collection rate.
#}

with charges as (
    select * from {{ ref('fct_charges') }}
),

clinics as (
    select clinic_id, clinic_name from {{ ref('dim_clinics') }}
)

select
    date_trunc('month', c.date_key)                     as month,
    c.clinic_id,
    cl.clinic_name,

    count(*)                                            as charge_lines,
    sum(c.charge_amount)                                as gross_charges,
    sum(c.paid_amount)                                  as payments_received,
    sum(c.outstanding_amount)                           as outstanding_ar,

    round(
        div0(sum(c.paid_amount), sum(c.charge_amount)) * 100
    , 1)                                                as collection_rate_pct,

    round(
        div0(
            sum(case when c.is_denied_or_unpaid then 1 else 0 end),
            count(*)
        ) * 100
    , 1)                                                as denied_or_unpaid_rate_pct
from charges c
left join clinics cl on c.clinic_id = cl.clinic_id
group by 1, 2, 3
order by 1, 2
