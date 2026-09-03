{#
  Date dimension covering the data range plus buffer (2024-01-01 .. 2026-12-31).
  Built with native Snowflake SQL (GENERATOR) -- no external packages needed.
#}

{{ config(materialized = 'table') }}

with date_spine as (
    select
        dateadd(day, seq4(), to_date('2024-01-01')) as calendar_date
    from table(generator(rowcount => 1096))
)

select
    calendar_date                               as date_key,
    calendar_date,
    year(calendar_date)                         as year,
    quarter(calendar_date)                      as quarter,
    month(calendar_date)                        as month_number,
    monthname(calendar_date)                    as month_name,
    day(calendar_date)                          as day_of_month,
    dayofweek(calendar_date)                    as day_of_week,
    dayname(calendar_date)                      as day_name,
    weekofyear(calendar_date)                   as week_of_year,
    case when dayname(calendar_date) in ('Sat', 'Sun') then true else false end
                                                as is_weekend
from date_spine
