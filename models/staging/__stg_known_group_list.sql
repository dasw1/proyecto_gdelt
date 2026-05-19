with 

source as (

    select * from {{ source('seeds', 'known_groups_list') }}

),

renamed as (

    select
        trim(upper(known_group_id::varchar(3))) as known_group_id,
        initcap(trim(known_group_name)) as known_group_name

    from source

)

select * from renamed