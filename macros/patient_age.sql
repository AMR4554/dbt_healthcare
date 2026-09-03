{#
  Returns age in whole years from a date-of-birth column, as of today.
  Cross-database-ish but written for Snowflake.
  Usage:  {{ patient_age('date_of_birth') }}
#}
{% macro patient_age(dob_column) %}
    floor(datediff('day', {{ dob_column }}, current_date) / 365.25)
{% endmacro %}
