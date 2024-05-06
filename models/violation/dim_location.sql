{{ config(
    materialized="table"
) }}

WITH filtered_data AS (
    SELECT
        TRIM(state) AS state,  -- Remove leading/trailing spaces
        CASE
            WHEN LOWER(TRIM(county)) LIKE 'q%' THEN 'QN'
            WHEN LOWER(TRIM(county)) LIKE '%k%' OR LOWER(TRIM(county)) LIKE '%bk%' THEN 'BK'
            WHEN LOWER(TRIM(county)) LIKE 's%' THEN 'ST'
            WHEN LOWER(TRIM(county)) LIKE 'm%' OR LOWER(TRIM(county)) LIKE '%ny%' THEN 'MN'
            WHEN LOWER(TRIM(county)) LIKE '%b%x%' THEN 'BX'
            ELSE 'Unknown'
        END AS county_abbreviation,
        CASE
            WHEN REGEXP_LIKE(TRIM(precinct), '^[0-9]+(\.[0-9]+)?$') THEN FLOOR(precinct::numeric)
            ELSE NULL
        END AS precinct
    FROM
        violation_raw
    WHERE
        NOT REGEXP_LIKE(state, '^[0-9]+$') AND
        state NOT IN ('88', '99')
)

SELECT
    ROW_NUMBER() OVER (ORDER BY state, county_abbreviation, precinct) AS location_id,
    state,
    county_abbreviation AS county,
    precinct
FROM
    filtered_data
GROUP BY
    state, county_abbreviation, precinct
ORDER BY location_id