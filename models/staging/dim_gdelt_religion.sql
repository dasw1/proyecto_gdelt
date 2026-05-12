select distinct actor1_religion1_code
from {{ ref('__stg_gdelt_export') }}

union

select distinct actor1_religion2_code
from {{ ref('__stg_gdelt_export') }}

union

select distinct actor2_religion1_code
from {{ ref('__stg_gdelt_export') }}

union

select distinct actor2_religion2_code
from {{ ref('__stg_gdelt_export') }}
