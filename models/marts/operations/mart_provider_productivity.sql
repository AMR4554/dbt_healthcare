{#
  Provider productivity scorecard (all-time in this dataset):
  completed visits, unique patients, charges generated, revenue collected,
  and average revenue per completed visit.
#}

with appts as (
    select * from {{ ref('fct_appointments') }}
),

providers as (
    select * from {{ ref('dim_providers') }}
),

by_provider as (
    select
        provider_id,
        count(*)                                            as total_appointments,
        sum(case when is_completed then 1 else 0 end)       as completed_visits,
        count(distinct patient_id)                          as unique_patients,
        sum(total_charged)                                  as total_charged,
        sum(total_paid)                                     as total_collected
    from appts
    group by 1
)

select
    p.provider_id,
    p.provider_name,
    p.credential,
    p.home_clinic,
    p.is_active,
    b.total_appointments,
    b.completed_visits,
    b.unique_patients,
    b.total_charged,
    b.total_collected,
    round(div0(b.total_collected, b.completed_visits), 2) as revenue_per_completed_visit
from providers p
left join by_provider b on p.provider_id = b.provider_id
order by b.total_collected desc nulls last
