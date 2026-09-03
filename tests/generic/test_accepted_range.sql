{#
  Custom generic test: fail rows whose value falls outside [min_value, max_value].
  Replaces dbt_utils.accepted_range so the project needs no external packages.
  Nulls are ignored (use not_null separately). Passes when 0 rows return.

  Usage in a schema.yml:
    columns:
      - name: collection_rate_pct
        data_tests:
          - accepted_range:
              min_value: 0
              max_value: 100
              inclusive: true
#}
{% test accepted_range(model, column_name, min_value=none, max_value=none, inclusive=true) %}

with validation as (
    select {{ column_name }} as val
    from {{ model }}
)

select val
from validation
where val is not null
  and (
    {%- if min_value is not none %}
        val {{ '<' if inclusive else '<=' }} {{ min_value }}
    {%- endif %}
    {%- if min_value is not none and max_value is not none %} or {% endif %}
    {%- if max_value is not none %}
        val {{ '>' if inclusive else '>=' }} {{ max_value }}
    {%- endif %}
  )

{% endtest %}
