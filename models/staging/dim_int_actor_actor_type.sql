select actor_type_id
from {{ ref('dim_gdelt_type_actor') }}