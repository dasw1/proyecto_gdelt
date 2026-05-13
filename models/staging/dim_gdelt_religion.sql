WITH religion AS (
    SELECT DISTINCT TRIM(UPPER(actor1_religion1_code)) AS religion_id
    FROM {{ ref('__stg_gdelt_export') }}

    UNION

    SELECT DISTINCT TRIM(UPPER(actor1_religion2_code))
    FROM {{ ref('__stg_gdelt_export') }}

    UNION

    SELECT DISTINCT TRIM(UPPER(actor2_religion1_code))
    FROM {{ ref('__stg_gdelt_export') }}

    UNION

    SELECT DISTINCT TRIM(UPPER(actor2_religion2_code))
    FROM {{ ref('__stg_gdelt_export') }}
)

select distinct
    COALESCE(r.religion_id, 'NS') AS religion_id,
    COALESCE(l.religion_name, 'Not Specified') AS religion_name,
    l.parent_id
from religion r
    left join {{ ref('__stg_religion_list') }} l 
        on r.religion_id = l.religion_id
order by l.parent_id