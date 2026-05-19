{% snapshot snap_bilateral_relations %}

{{
    config(
        target_schema='SNAPSHOTS',
        target_database=env_var('DBT_GOLD_DB', 'GDELT_GOLD_DEV'),
        unique_key="country_from || '|' || country_to",
        strategy='check',
        check_cols=[
            'avg_goldstein',
            'avg_tone',
            'narrative_vs_reality',
            'cooperation_rate',
            'dominant_cameo_root'
        ]
    )
}}

SELECT
    country_from,
    country_to,
    avg_goldstein,
    avg_tone,
    narrative_vs_reality,
    cooperation_rate,
    dominant_cameo_root,
    total_events,
    cooperation_events,
    conflict_events
FROM {{ ref('fact_bilateral_relations') }}

{% endsnapshot %}