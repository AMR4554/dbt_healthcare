-- Analyses are compiled (dbt compile) but not materialized. Handy for
-- ad-hoc queries you want version-controlled. Grab the compiled SQL from
-- target/compiled/ and run it in Snowflake.

select
    a.primary_diagnosis_code,
    d.icd10_description,
    count(*)                                as appointment_count,
    count(distinct a.patient_id)            as patient_count
from {{ ref('fct_appointments') }} a
left join {{ ref('ref_icd10_codes') }} d
    on a.primary_diagnosis_code = d.icd10_code
group by 1, 2
order by appointment_count desc
