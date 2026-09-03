-- Singular (custom) test: a business rule.
-- Payments posted against a charge line should never exceed the billed amount.
-- The test passes when this query returns zero rows.

select
    charge_id,
    charge_amount,
    paid_amount
from {{ ref('int_charges_with_payments') }}
where paid_amount > charge_amount + 0.01
