select 
    cf.cameo_full_id,
    cf.cameo_code_desc,
    cr.cameo_code_desc as cameo_root_desc    
from {{ ref('int_gdelt_cameo_full') }} cf 
    inner join {{ ref('int_gdelt_cameo_root') }} cr 
        on cf.cameo_root_id = cr.cameo_root_id