WITH source AS (
    SELECT * FROM {{ source('seeds', 'actor_types_list') }}
),

renamed AS (
    SELECT
        actor_type_id,
        actor_type_name,
        actor_type_desc
    FROM source
)

SELECT * FROM renamed