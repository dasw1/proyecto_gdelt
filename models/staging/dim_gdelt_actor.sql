{{ config(materialized='table') }}

with actor_union as (
    select distinct
        actor1_id as actor_id
    from {{ ref('__stg_gdelt_export') }}
    where actor1_id is not null

    union
    select distinct
        actor2_id
    from {{ ref('__stg_gdelt_export') }}
    where actor2_id is not null
)

select distinct
    a.actor_id,
    e.actor1_code,
    e.actor1_name
from {{ ref('__stg_gdelt_export') }} e 
    inner join actor_union a 
        on e.actor1_id = a.actor_id

union 

select distinct
    a.actor_id,
    e.actor2_code,
    e.actor2_name
from {{ ref('__stg_gdelt_export') }} e 
    inner join actor_union a 
        on e.actor2_id = a.actor_id