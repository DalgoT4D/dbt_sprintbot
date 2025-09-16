WITH source as (
    SELECT * FROM {{ref('int_step_sheet_data')}}
),

total_step_per_name as (
    SELECT 
        name,
        sum(steps) as total_steps
    FROM source
    GROUP BY name
),

top_contributors as (
    SELECT 
        name,
        total_steps
    FROM total_step_per_name
    ORDER BY total_steps DESC
    LIMIT 5
)

SELECT * FROM top_contributors
ORDER BY total_steps DESC
