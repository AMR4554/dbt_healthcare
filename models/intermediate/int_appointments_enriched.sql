{#
  Appointment enriched with descriptive attributes and its billing rollup.
  Grain: one row per appointment_id.
#}

with appointments as (
    select * from {{ ref('stg_healthcare__appointments') }}
),

patients as (
    select patient_id, age, sex
    from {{ ref('stg_healthcare__patients') }}
),

charge_rollup as (
    select
        appointment_id,
        count(*)                as charge_line_count,
        sum(charge_amount)      as total_charged,
        sum(paid_amount)        as total_paid,
        sum(outstanding_amount) as total_outstanding
    from {{ ref('int_charges_with_payments') }}
    group by 1
),

final as (
    select
        a.appointment_id,
        a.patient_id,
        a.provider_id,
        a.clinic_id,
        a.appointment_date,
        a.appointment_type,
        a.appointment_status,
        a.primary_diagnosis_code,
        a.is_completed,
        a.is_no_show,
        a.is_cancelled,

        pt.age                                  as patient_age,
        pt.sex                                  as patient_sex,
       

        coalesce(cr.charge_line_count, 0)       as charge_line_count,
        coalesce(cr.total_charged, 0)           as total_charged,
        coalesce(cr.total_paid, 0)              as total_paid,
        coalesce(cr.total_outstanding, 0)       as total_outstanding
    from appointments a
    left join patients pt      on a.patient_id = pt.patient_id
    left join charge_rollup cr on a.appointment_id = cr.appointment_id
)

select * from final
