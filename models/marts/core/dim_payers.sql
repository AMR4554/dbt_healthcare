select
    payer_id,
    payer_name,
    payer_type,
    expected_collection_rate
from {{ ref('stg_healthcare__payers') }}
