select distinct 
    event_root_code as cameo_root_id
from {{ ref('__stg_gdelt_export') }}