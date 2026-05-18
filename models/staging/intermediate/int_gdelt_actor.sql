{{ config(
    materialized='incremental',
    unique_key='actor_id',
    on_schema_change='sync_all_columns'
) }}

WITH base AS (
    SELECT * FROM {{ ref('__stg_gdelt_export') }}
    {% if is_incremental() %}
    WHERE loaded_at > (SELECT MAX(loaded_at) FROM {{ this }})
    {% endif %}
)

SELECT DISTINCT
    actor1_id                               AS actor_id,
    UPPER(TRIM(actor1_name))                AS actor_name,
    UPPER(TRIM(actor1_code))                AS actor_code,
    c.iso3_code                             AS country_id,
    UPPER(TRIM(actor1_ethnic_code))         AS ethnic_id,
    UPPER(TRIM(actor1_known_group_code))    AS known_group_id,
    UPPER(TRIM(actor1_religion1_code))      AS religion1_id,
    UPPER(TRIM(actor1_religion2_code))      AS religion2_id
FROM base e
LEFT JOIN {{ ref('__stg_country_list') }} c
    ON e.actor1_country_code = c.country_code
QUALIFY ROW_NUMBER() OVER (PARTITION BY actor1_id ORDER BY c.iso3_code) = 1

UNION

SELECT DISTINCT
    actor2_id,
    UPPER(TRIM(actor2_name)),
    UPPER(TRIM(actor2_code)),
    c.iso3_code,
    UPPER(TRIM(actor2_ethnic_code)),
    UPPER(TRIM(actor2_known_group_code)),
    UPPER(TRIM(actor2_religion1_code)),
    UPPER(TRIM(actor2_religion2_code))
FROM base e
LEFT JOIN {{ ref('__stg_country_list') }} c
    ON e.actor2_country_code = c.country_code
QUALIFY ROW_NUMBER() OVER (PARTITION BY actor2_id ORDER BY c.iso3_code) = 1