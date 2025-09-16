with step_flow as (
SELECT
	t.id,
	CAST(t.contact_id as INTEGER) as contact_id,
	CAST(t.results::json->'actual_steps'->>'input' as INTEGER) AS steps,
	CAST(t.completed_at::timestamp as DATE) as completed_date,
	TO_CHAR(t.completed_at::timestamp, 'HH24:MI:SS') as completed_time

FROM {{ source('staging_sprintbot', 'flow_contexts') }} t
where t.flow_uuid = '8503b0a8-43f1-4ea8-a0ce-d98015154caa'
and t.inserted_at::timestamp BETWEEN '2025-09-15'::timestamp AND '2025-09-20'::timestamp
and t.results::json->'actual_steps'->>'input' is not null
and t.completed_at is not NULL
),

contact_details as (
SELECT DISTINCT
	p.id as contact_id,
	p.phone as contact_phone,
	p.name,
	(raw_fields::jsonb -> 'steps_team' ->> 'value') AS steps_team
FROM {{ source('staging_sprintbot', 'contacts') }} p inner join step_flow t on p.id=t.contact_id
WHERE (raw_fields::jsonb -> 'steps_team' ->> 'value') in ('Team A', 'Team B', 'Team C', 'Team D')
)


SELECT DISTINCT
	p.contact_phone,
	p.name,
	p.steps_team,
	t.steps,
	t.completed_date,
	t.completed_time
	
FROM step_flow t INNER JOIN contact_details p on t.contact_id=p.contact_id 