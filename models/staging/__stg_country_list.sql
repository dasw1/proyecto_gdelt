with 

source as (

    select * from {{ source('seeds', 'country_list') }}

),

renamed as (

    select
        trim(upper(country_code)),
        trim(upper(fips_code)),
        trim(upper(iso3_code)),
        initcap(trim(country_name)),
        CASE country_type
            WHEN 'region'    THEN 1
            WHEN 'territory' THEN 2
            WHEN 'country'   THEN 3
        END AS country_type_id
    from source

)

select * from renamed