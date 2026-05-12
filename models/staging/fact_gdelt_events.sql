Select 
    event_id,
    source_url,
    is_root_event,
    goldstein_scale,
    num_mentions,
    num_sources,
    num_articles,
    avg_tone
from {{ ref('__stg_gdelt_export') }}