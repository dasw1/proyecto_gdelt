with 

source as (

    select * from {{ source('seeds', 'country_list') }}

),

renamed as (

    select
        country_code,
        fips_code,
        iso3_code,
        country_name,
        CASE country_type
            WHEN 'region'    THEN 1
            WHEN 'territory' THEN 2
            WHEN 'country'   THEN 3
        END AS country_type_id
    from source

)

select * from renamed