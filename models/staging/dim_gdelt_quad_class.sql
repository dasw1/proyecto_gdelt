select distinct
    quad_class as quad_class_id
from {{ ref('__stg_gdelt_export') }}