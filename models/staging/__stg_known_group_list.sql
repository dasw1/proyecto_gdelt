with 

source as (

    select * from {{ source('seeds', 'known_groups_list') }}

),

renamed as (

    select
        known_group_id,
        known_group_name

    from source

)

select * from renamed