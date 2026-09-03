{#
  Clinic operational scorecard by month:
  visit volume, completion rate, and no-show / cancellation rates.
#}

with appts as (
    select * from {{ ref('fct_appointments') }}
),

clinics as (
    select clinic_id, clinic_name from {{ ref('dim_clinics') }}
)

select
    date_trunc('month', a.date_key)                     as month,
    a.clinic_id,
    cl.clinic_name,

    count(*)                                            as total_appointments,
    sum(case when a.is_completed then 1 else 0 end)     as completed_appointments,
    sum(case when a.is_no_show   then 1 else 0 end)     as no_show_appointments,
    sum(case when a.is_cancelled then 1 else 0 end)     as cancelled_appointments,

    round(div0(sum(case when a.is_completed then 1 else 0 end), count(*)) * 100, 1)
                                                        as completion_rate_pct,
    round(div0(sum(case when a.is_no_show then 1 else 0 end), count(*)) * 100, 1)
                                                        as no_show_rate_pct
from appts a
left join clinics cl on a.clinic_id = cl.clinic_id
group by 1, 2, 3
order by 1, 2
