Select 
    event_id,
    source_url,
    is_root_event,
    goldstein_scale,
    num_mentions,
    num_sources,
    num_articles,
    avg_tone,
    actor1_id,
    actor2_id,
    cameo_event_id,
    quad_class_id,
    geo_locations_id,
    action_geo_lat as latitude,
    action_geo_long as longitude
from {{ ref('__stg_gdelt_export') }}