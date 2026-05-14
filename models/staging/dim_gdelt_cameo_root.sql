with cameo_root as (
    select distinct 
        event_root_code as cameo_root_id
    from {{ ref('__stg_gdelt_export') }}

), cameo_r_l as(
    select distinct
        cameo_code_full_id as cameo_root_id,
        cameo_code_desc
    from {{ ref('__stg_gdelt_cameo_code_list') }}
    where length(cameo_code_full_id) = 2
)

select distinct
    c.cameo_root_id,
    l.cameo_code_desc
from cameo_root c
    left join cameo_r_l l 
        on c.cameo_root_id=l.cameo_root_id
order by 
    c.cameo_root_id
