{{ config(materialized='view') }}

SELECT
    -- Identificación
    GLOBALEVENTID::BIGINT                                                   AS event_id,
    TRY_TO_DATE(SQLDATE, 'YYYYMMDD')                                        AS event_date,
    TRY_TO_TIMESTAMP(DATEADDED, 'YYYYMMDDHH24MISS')                         AS date_added,
    SOURCEURL                                                               AS source_url,

    -- Actor 1
    COALESCE(TRIM(UPPER(ACTOR1CODE)), '')                                   AS actor1_code,
    COALESCE(TRIM(ACTOR1NAME), '')                                          AS actor1_name,
    MD5(CONCAT(COALESCE(TRIM(UPPER(ACTOR1CODE)), ''), '|', COALESCE(TRIM(ACTOR1NAME), ''))) AS actor1_id,
    TRIM(UPPER(ACTOR1COUNTRYCODE))                                          AS actor1_country_code,
    TRIM(UPPER(ACTOR1KNOWNGROUPCODE))                                       AS actor1_known_group_code,
    TRIM(UPPER(COALESCE(ACTOR1ETHNICCODE, 'NS')))                                      AS actor1_ethnic_code,
    TRIM(UPPER(COALESCE(ACTOR1RELIGION1CODE, 'NS')))                                        AS actor1_religion1_code,
    TRIM(UPPER(COALESCE(ACTOR1RELIGION2CODE, 'NS')))          COALESCE(ACTOR1RELIGION2CODE, 'NS')                              AS actor1_religion2_code,
    TRIM(UPPER(ACTOR1TYPE1CODE))                                            AS actor1_type1_code,
    TRIM(UPPER(ACTOR1TYPE2CODE))                                            AS actor1_type2_code,
    TRIM(UPPER(ACTOR1TYPE3CODE))                                            AS actor1_type3_code,

    -- Actor 2
    COALESCE(TRIM(UPPER(ACTOR2CODE)), '')                                   AS actor2_code,
    COALESCE(TRIM(ACTOR2NAME), '')                                          AS actor2_name,
    MD5(CONCAT(COALESCE(TRIM(UPPER(ACTOR2CODE)), ''), '|', COALESCE(TRIM(ACTOR2NAME), ''))) AS actor2_id,
    TRIM(UPPER(ACTOR2COUNTRYCODE))                                          AS actor2_country_code,
    TRIM(UPPER(ACTOR2KNOWNGROUPCODE))                                       AS actor2_known_group_code,
    TRIM(UPPER(COALESCE(ACTOR2ETHNICCODE, 'NS')))                                      AS actor2_ethnic_code,
    TRIM(UPPER(COALESCE(ACTOR2RELIGION1CODE, 'NS')))                                        AS actor2_religion1_code,
    TRIM(UPPER(COALESCE(ACTOR2RELIGION2CODE, 'NS')))                                        AS actor2_religion2_code,
    TRIM(UPPER(ACTOR2TYPE1CODE))                                            AS actor2_type1_code,
    TRIM(UPPER(ACTOR2TYPE2CODE))                                            AS actor2_type2_code,
    TRIM(UPPER(ACTOR2TYPE3CODE))                                            AS actor2_type3_code,

    -- Clasificación del evento
    ISROOTEVENT::BOOLEAN                                                    AS is_root_event,
    TRIM(EVENTCODE)                                                         AS cameo_code_id,
    TRIM(SUBSTR(EVENTCODE, 3))                                              AS event_subcode,
    TRIM(EVENTBASECODE)                                                     AS event_base_code,
    TRIM(EVENTROOTCODE)                                                     AS event_root_code,
    QUADCLASS::INT                                                          AS quad_class_id,
    COALESCE(GOLDSTEINSCALE::FLOAT, 0)                                      AS goldstein_scale,

    -- Métricas
    COALESCE(NUMMENTIONS::INT, 0)                                           AS num_mentions,
    COALESCE(NUMSOURCES::INT, 0)                                            AS num_sources,
    COALESCE(NUMARTICLES::INT, 0)                                           AS num_articles,
    COALESCE(AVGTONE::FLOAT, 0)                                             AS avg_tone,

    MD5(CONCAT(
        COALESCE(TRIM(ACTIONGEO_FULLNAME), ''), '|',
        COALESCE(c.iso3_code, TRIM(ACTIONGEO_COUNTRYCODE), ''), '|',
        COALESCE(TRIM(ACTIONGEO_TYPE::VARCHAR), '')
    ))                                                                      AS geo_locations_id,
    ACTIONGEO_TYPE::INT                                                     AS action_geo_type,
    ACTIONGEO_FULLNAME                                                      AS action_geo_fullname,
    ACTIONGEO_COUNTRYCODE                                                   AS action_geo_country_code,
    ACTIONGEO_ADM1CODE                                                      AS action_geo_adm1_code,
    ACTIONGEO_ADM2CODE                                                      AS action_geo_adm2_code,
    TRY_TO_DOUBLE(ACTIONGEO_LAT)                                            AS action_geo_lat,
    TRY_TO_DOUBLE(ACTIONGEO_LONG)                                           AS action_geo_long,

    -- Metadatos
    _LOADED_AT                                                              AS loaded_at,
    _SOURCE_FILE                                                            AS source_file

FROM {{ source('bronze', 'gdelt_export') }} e
LEFT JOIN {{ source('seeds', 'country_list') }} c
    ON TRIM(UPPER(e.ACTIONGEO_COUNTRYCODE)) = c.country_code
WHERE GLOBALEVENTID IS NOT NULL