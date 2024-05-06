{{
    config(
        materialized="table"
    )
}}

WITH raw_data AS (
    SELECT
        violation
    FROM
        violation_raw
    WHERE
        violation IS NOT NULL
)

SELECT
    row_number() OVER (ORDER BY violation) AS violationtype_id,
    violation AS violationtype
FROM
    raw_data
GROUP BY
    violation
