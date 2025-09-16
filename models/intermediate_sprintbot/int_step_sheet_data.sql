with source as (
	select 
        TO_DATE(t."Date",'DD/MM/YYYY') as date,
        trim(t."Name") as name, 
        trim(t."Team") as team,
        Cast(REPLACE(t."Steps",',','') as INTEGER) as steps

    from {{ source('staging_sprintbot', 'Sheet1') }} t
)

SELECT * FROM source
WHERE date BETWEEN TO_DATE('15/09/2025','DD/MM/YYYY') AND TO_DATE('20/09/2025','DD/MM/YYYY')
and team in ('Team A', 'Team B', 'Team C', 'Team D')