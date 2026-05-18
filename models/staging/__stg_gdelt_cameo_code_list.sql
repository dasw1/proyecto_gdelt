with 

source as (

    select * from {{ source('bronze', 'CAMEO_CODE_LIST') }}

),

renamed as (

    select
        cameo_code_list::varchar(4) as cameo_code_full_id,
        cameo_code_desc

    from source
    order by cameo_code_full_id
)

select * from renamed