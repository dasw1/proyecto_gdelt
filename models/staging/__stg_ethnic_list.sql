with 

source as (

    select * from {{ source('seeds', 'ethnic_list') }}

),

renamed as (

    select
        trim(upper(ethnic_id)),
        upper(trim(ethnic_name))

    from source

)

select * from renamed