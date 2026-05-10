{{ config(materialized='view') }}
WITH COUNTRYS AS (
SELECT DISTINCT
    actor1_country_code   AS country_id
FROM {{ ref('__stg_gdelt_export') }}
WHERE actor1_country_code IS NOT NULL
  AND actor1_country_code != ''

UNION

SELECT DISTINCT
    actor2_country_code   AS country_id
FROM {{ ref('__stg_gdelt_export') }}
WHERE actor2_country_code IS NOT NULL
  AND actor2_country_code != ''

UNION

SELECT DISTINCT
    action_geo_country_code   AS country_id
FROM {{ ref('__stg_gdelt_export') }}
WHERE action_geo_country_code IS NOT NULL
  AND action_geo_country_code != ''
), 
COUNTRYS2 AS
(
SELECT country_id,
    CASE  
        WHEN country_id in('EUR', 'AFR', 'ASA', 'SEA', 'MEA', 'WAF', 'EAF', 'CAS', 'SAS', 'CRB')
            THEN 1 
        WHEN country_id in('HKG', 'TWN', 'MAC', 'PGS', 'GZ', 'KS', 'KV', 'ABW')
            THEN 2
        ELSE 3
    END AS country_type
FROM COUNTRYS
)
SELECT 
    CASE
        WHEN C.country_type = 3 then L.iso3_code
        ELSE C.country_id
    END AS country_id,
    L.country_name AS country_name,
    C.country_type as country_type
FROM COUNTRYS2 C
    LEFT JOIN {{ ref('__stg_country_list') }} L
        ON C.country_id = L.country_code