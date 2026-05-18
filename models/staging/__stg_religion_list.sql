with 

source as (

    select * from {{ source('seeds', 'religion_list') }}

),

renamed as (

    select
        religion_id,
        religion_name,
        parent_id

    from source

)

select * from renamed