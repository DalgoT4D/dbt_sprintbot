WITH source as (
    SELECT * FROM {{ref('int_step_sheet_data')}}
),

team_agg as (
    SELECT 
        date,
        team,
        SUM(steps) as total_steps
    FROM source
    GROUP BY date, team
)

SELECT * FROM team_agg
ORDER BY date, team