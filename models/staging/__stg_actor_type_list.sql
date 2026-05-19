WITH source AS (
    SELECT * FROM {{ source('seeds', 'actor_types_list') }}
),

renamed AS (
    SELECT
        upper(trim(actor_type_id))::varchar(3),
        initcap(trim(actor_type_name)),
        initcap(trim(actor_type_desc))
    FROM source
)

SELECT * FROM renamed