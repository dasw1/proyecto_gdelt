select distinct
    actor1_id,
    actor1_name,
    actor1_code,
    actor1_country_code,
    actor1_ethnic_code,
    actor1_known_group_code
from {{ ref('__stg_gdelt_export') }}

union

select distinct
    actor2_id,
    actor2_name,
    actor2_code,
    actor2_country_code,
    actor2_ethnic_code,
    actor2_known_group_code
from {{ ref('__stg_gdelt_export') }}