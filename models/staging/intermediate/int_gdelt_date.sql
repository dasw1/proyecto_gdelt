{{ config(materialized='table') }}

SELECT DISTINCT
    CAST(TO_CHAR(event_date, 'YYYYMMDD') AS INT)    AS date_id,
    event_date                                       AS full_date,
    YEAR(event_date)                                 AS year,
    MONTH(event_date)                                AS month,
    MONTHNAME(event_date)                            AS month_name,
    QUARTER(event_date)                              AS quarter,
    WEEKOFYEAR(event_date)                           AS week_of_year,
    DAYOFWEEK(event_date)                            AS day_of_week,
    DAYNAME(event_date)                              AS day_name,
    CASE WHEN DAYOFWEEK(event_date) IN (1, 7)
        THEN TRUE ELSE FALSE
    END                                              AS is_weekend
FROM {{ ref('__stg_gdelt_export') }}
WHERE event_date IS NOT NULL