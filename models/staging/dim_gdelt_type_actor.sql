select distinct 
    actor1_type1_code as actor_type_id
from {{ ref('__stg_gdelt_export') }}

UNION

select distinct 
    actor1_type2_code
from {{ ref('__stg_gdelt_export') }}

UNION

select distinct 
    actor1_type3_code
from {{ ref('__stg_gdelt_export') }}

UNION

select distinct 
    actor2_type1_code
from {{ ref('__stg_gdelt_export') }}

UNION

select distinct 
    actor2_type2_code
from {{ ref('__stg_gdelt_export') }}

UNION

select distinct 
    actor2_type3_code
from {{ ref('__stg_gdelt_export') }}