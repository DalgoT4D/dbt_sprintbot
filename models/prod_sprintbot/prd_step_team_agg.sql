WITH source as (
    SELECT * FROM {{ref('int_step_sheet_data')}}
),

team_agg as (
    SELECT 
        name,
        team,
        SUM(steps) as total_steps
    FROM source
    GROUP BY name, team
)

SELECT * FROM team_agg
ORDER BY team