select distinct
    action_geo_type
from {{ ref('__stg_gdelt_export') }}