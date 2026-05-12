select distinct trim(upper(actor1_known_group_code)) as known_group_id
from {{ ref('__stg_gdelt_export') }}

UNION

select distinct trim(upper(actor2_known_group_code))
from {{ ref('__stg_gdelt_export') }}