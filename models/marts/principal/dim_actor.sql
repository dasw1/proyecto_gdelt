select 
    a.actor_id,
    a.actor_name,
    a.actor_code,
    c.country_name
from {{ ref('int_gdelt_actor') }} a
    inner join {{ ref('int_gdelt_country') }} c 
        on a.country_id = c.country_id