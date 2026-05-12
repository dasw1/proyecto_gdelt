select distinct
    geo_locations_id,
    action_geo_fullname,
    action_geo_country_code as country_id,
    action_geo_type as geo_location_type_id
from {{ ref('__stg_gdelt_export') }}