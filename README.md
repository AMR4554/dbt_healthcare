# healthcare — dbt project

Analytics-engineering project modeling an outpatient / physical-therapy clinic
group on Snowflake. See the top-level `SETUP_GUIDE.md` for the full GCS →
Snowflake → dbt setup. This README covers the dbt project itself.

## Architecture

```
sources (RAW, from GCS)
        │
        ▼
staging/            views, 1:1 with sources, renamed + typed
  stg_healthcare__clinics / providers / payers / patients
  stg_healthcare__appointments / charges / payments
        │
        ▼
intermediate/       ephemeral, reusable business logic
  int_charges_with_payments      (charge ⨝ payments, AR, denial flags)
  int_appointments_enriched      (visit + patient + billing rollup)
        │
        ▼
marts/
  core/       dim_date, dim_patients, dim_providers, dim_clinics, dim_payers,
              fct_appointments, fct_charges
  finance/    mart_monthly_revenue, mart_payer_performance
  operations/ mart_clinic_utilization, mart_provider_productivity
```

## Layer conventions

- **staging** — one model per source table, prefixed `stg_<source>__<entity>`.
  Only renaming, casting, and light derivations. Materialized as **views**.
- **intermediate** — verbs/business logic reused by more than one mart.
  Prefixed `int_`. Materialized **ephemeral** (inlined at compile time).
- **marts** — the things people query. Star-schema `dim_`/`fct_` in `core`,
  plus subject-area marts in `finance` and `operations`. Materialized as
  **tables** in the `ANALYTICS` schema.

## Naming & keys

- Primary keys end in `_id`; date grain columns are `date_key`.
- Every `dim_`/`fct_` primary key has `unique` + `not_null` tests.
- Foreign keys carry `relationships` tests back to their dimension.

## Seeds

`ref_cpt_codes` and `ref_icd10_codes` are small reference lookups loaded with
`dbt seed`.

## No external packages (trial-friendly)

This project uses **zero dbt packages**, so it needs no `dbt deps` and no
Snowflake External Access Integration (which trial accounts don't allow).
The two things packages usually provide are built in here:

- `dim_date` is a native Snowflake `GENERATOR` date spine (no `dbt_date`).
- `tests/generic/test_accepted_range.sql` is a custom generic range test
  (no `dbt_utils`), used the same way in the schema YAMLs.

## Custom code

- `macros/patient_age.sql` — age in years from a DOB column.
- `macros/cents_to_dollars.sql` (`to_money`) — money rounding helper.
- `tests/generic/test_accepted_range.sql` — custom generic test: values within
  a `[min_value, max_value]` range.
- `tests/assert_paid_not_exceeding_charge.sql` — singular test enforcing that
  payments never exceed the billed amount.

## Commands

```bash
dbt seed        # load reference lookups (no deps step needed)
dbt build       # run + test everything
dbt docs generate   # lineage + docs (view in Snowsight; 'docs serve' isn't supported on Snowflake)
```
