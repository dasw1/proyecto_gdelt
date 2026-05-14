select DISTINCT
    country_type_id,
    CASE country_type_id
        WHEN 1 THEN 'region'
        WHEN 2 THEN 'territory'
        WHEN 3 THEN 'country'
END AS country_type_desc
from {{ ref('__stg_country_list') }}
order by country_type_id
