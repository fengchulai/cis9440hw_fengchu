{{
    config(
        materialized="table"
    )
}}

WITH raw_data AS (
    SELECT
        license_type
    FROM
        violation_raw
    WHERE
        license_type IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY license_type) AS licensetype_id,
    license_type AS licensetype
FROM
    raw_data
GROUP BY
    license_type

