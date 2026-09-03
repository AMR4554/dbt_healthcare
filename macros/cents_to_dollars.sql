{#
  Example utility macro: round a numeric amount to 2 decimal places safely.
  Kept simple to demonstrate the macro pattern; extend as needed.
#}
{% macro to_money(column) %}
    round(cast({{ column }} as number(18,4)), 2)
{% endmacro %}
