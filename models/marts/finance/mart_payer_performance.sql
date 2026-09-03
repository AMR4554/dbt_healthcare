{#
  How each payer actually performs: what they were billed, what they paid,
  realized collection rate vs. the contractual expectation, denial rate, and
  average days to payment. A classic revenue-cycle scorecard.
#}

with charges as (
    select * from {{ ref('fct_charges') }}
),

payers as (
    select * from {{ ref('dim_payers') }}
),

by_payer as (
    select
        payer_id,
        count(*)                                        as charge_lines,
        sum(charge_amount)                              as gross_charges,
        sum(paid_amount)                                as payments_received,
        sum(outstanding_amount)                         as outstanding_ar,
        avg(days_to_payment)                            as avg_days_to_payment,
        div0(
            sum(case when is_denied_or_unpaid then 1 else 0 end),
            count(*)
        )                                               as denial_rate,
        div0(sum(paid_amount), sum(charge_amount))      as realized_collection_rate
    from charges
    group by 1
)

select
    p.payer_id,
    p.payer_name,
    p.payer_type,
    b.charge_lines,
    b.gross_charges,
    b.payments_received,
    b.outstanding_ar,
    round(b.avg_days_to_payment, 1)                     as avg_days_to_payment,
    round(b.denial_rate * 100, 1)                       as denial_rate_pct,
    round(b.realized_collection_rate * 100, 1)          as realized_collection_rate_pct,
    round(p.expected_collection_rate * 100, 1)          as expected_collection_rate_pct,
    round((b.realized_collection_rate - p.expected_collection_rate) * 100, 1)
                                                        as collection_variance_pct
from payers p
left join by_payer b on p.payer_id = b.payer_id
order by b.gross_charges desc nulls last
