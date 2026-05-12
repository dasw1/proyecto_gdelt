select distinct
    actor1_ethnic_code
from {{ ref('__stg_gdelt_export') }}

union

select distinct
    actor2_ethnic_code
from {{ ref('__stg_gdelt_export') }}