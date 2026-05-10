with 

source as (

    select * from {{ source('seeds', 'country_list') }}

),

renamed as (

    select
        country_code,
        fips_code,
        iso3_code,
        country_name

    from source

)

select * from renamed