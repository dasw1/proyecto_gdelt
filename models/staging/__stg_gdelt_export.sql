{{ config(materialized='view') }}

SELECT
    -- Identificación
    GLOBALEVENTID::BIGINT                           AS event_id,
    TRY_TO_DATE(SQLDATE, 'YYYYMMDD')                AS event_date,
    DATEADDED::VARCHAR                              AS date_added,
    SOURCEURL                                       AS source_url,

    -- Actor 1
    ACTOR1CODE                                      AS actor1_code,
    ACTOR1NAME                                      AS actor1_name,
    MD5(CONCAT(COALESCE(TRIM(UPPER(ACTOR1CODE)), ''), '|', COALESCE(TRIM(ACTOR1NAME), ''))) AS actor1_id,
    ACTOR1COUNTRYCODE                               AS actor1_country_code,
    ACTOR1KNOWNGROUPCODE                            AS actor1_known_group_code,
    ACTOR1ETHNICCODE                                AS actor1_ethnic_code,
    ACTOR1RELIGION1CODE                             AS actor1_religion1_code,
    ACTOR1RELIGION2CODE                             AS actor1_religion2_code,
    ACTOR1TYPE1CODE                                 AS actor1_type1_code,
    ACTOR1TYPE2CODE                                 AS actor1_type2_code,
    ACTOR1TYPE3CODE                                 AS actor1_type3_code,

    -- Actor 2
    ACTOR2CODE                                      AS actor2_code,
    ACTOR2NAME                                      AS actor2_name,
    MD5(CONCAT(COALESCE(TRIM(UPPER(ACTOR2CODE)), ''), '|', COALESCE(TRIM(ACTOR2NAME), ''))) AS actor2_id,
    ACTOR2COUNTRYCODE                               AS actor2_country_code,
    ACTOR2KNOWNGROUPCODE                            AS actor2_known_group_code,
    ACTOR2ETHNICCODE                                AS actor2_ethnic_code,
    ACTOR2RELIGION1CODE                             AS actor2_religion1_code,
    ACTOR2RELIGION2CODE                             AS actor2_religion2_code,
    ACTOR2TYPE1CODE                                 AS actor2_type1_code,
    ACTOR2TYPE2CODE                                 AS actor2_type2_code,
    ACTOR2TYPE3CODE                                 AS actor2_type3_code,

    -- Clasificación del evento
    ISROOTEVENT::BOOLEAN                            AS is_root_event,
    MD5(CONCAT(COALESCE(TRIM(UPPER(EVENTROOTCODE)), ''), '|', COALESCE(TRIM(SUBSTR(EVENTCODE, 3)), ''))) AS cameo_event_id,
    EVENTCODE                                       AS event_code,
    SUBSTR(EVENTCODE, 3)                            AS event_subcode,
    EVENTBASECODE                                   AS event_base_code,
    EVENTROOTCODE                                   AS event_root_code,
    QUADCLASS::INT                                  AS quad_class_id,
    GOLDSTEINSCALE::FLOAT                           AS goldstein_scale,

    -- Métricas
    NUMMENTIONS::INT                                AS num_mentions,
    NUMSOURCES::INT                                 AS num_sources,
    NUMARTICLES::INT                                AS num_articles,
    AVGTONE::FLOAT                                  AS avg_tone,

    -- Geo acción
    MD5(CONCAT(COALESCE(TRIM(ACTIONGEO_FULLNAME), ''), '|',COALESCE(TRIM(ACTIONGEO_COUNTRYCODE), ''), '|',COALESCE(TRIM(ACTIONGEO_TYPE::VARCHAR), ''))) AS geo_locations_id,
    ACTIONGEO_TYPE::INT                             AS action_geo_type,
    ACTIONGEO_FULLNAME                              AS action_geo_fullname,
    ACTIONGEO_COUNTRYCODE                           AS action_geo_country_code,
    ACTIONGEO_ADM1CODE                              AS action_geo_adm1_code,
    ACTIONGEO_ADM2CODE                              AS action_geo_adm2_code,
    TRY_TO_DOUBLE(ACTIONGEO_LAT)                    AS action_geo_lat,
    TRY_TO_DOUBLE(ACTIONGEO_LONG)                   AS action_geo_long,

    -- Metadatos
    _LOADED_AT                                      AS loaded_at,
    _SOURCE_FILE                                    AS source_file

FROM {{ source('bronze', 'gdelt_export') }}
WHERE GLOBALEVENTID IS NOT NULL

