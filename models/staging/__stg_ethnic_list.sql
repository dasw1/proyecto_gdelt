with 

source as (

    select * from {{ source('seeds', 'ethnic_list') }}

),

renamed as (

    select
        ethnic_id,
        ethnic_name

    from source

)

select * from renameddbr