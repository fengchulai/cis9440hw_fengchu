{{
    config(
        materialized="table"
    )
}}

WITH recursive date_series AS (
    SELECT
        '2000-01-01T00:00:00'::TIMESTAMP as date -- Start datetime with explicit timestamp
    UNION ALL
    SELECT
        DATEADD(hour, 1, date) -- Increment by one hour
    FROM date_series
    WHERE DATEADD(hour, 1, date) <= '2024-05-01T23:00:00' -- End datetime
),

date_parts AS (
    SELECT
        -- Combine year, month, day, and hour into a single ID
        CAST(
            EXTRACT(YEAR FROM date) * 1000000 
            + EXTRACT(MONTH FROM date) * 10000 
            + EXTRACT(DAY FROM date) * 100 
            + EXTRACT(HOUR FROM date) AS INT
        ) AS datetime_id,
        EXTRACT(YEAR FROM date) AS year,
        EXTRACT(QUARTER FROM date) AS quarter,
        EXTRACT(MONTH FROM date) AS month,
        EXTRACT(DAY FROM date) AS day,
        LEFT(TO_CHAR(date, 'Month'), 3) AS monthname, -- Month name abbreviated to three letters
        CASE
            WHEN DAYOFWEEK(date) = 0 THEN 'sunday'
            WHEN DAYOFWEEK(date) = 1 THEN 'monday'
            WHEN DAYOFWEEK(date) = 2 THEN 'tuesday'
            WHEN DAYOFWEEK(date) = 3 THEN 'wednesday'
            WHEN DAYOFWEEK(date) = 4 THEN 'thursday'
            WHEN DAYOFWEEK(date) = 5 THEN 'friday'
            WHEN DAYOFWEEK(date) = 6 THEN 'saturday'
        END AS dayname,
        EXTRACT(WEEK FROM date) AS weekofyear,
        FLOOR((EXTRACT(DAY FROM date) - 1) / 7 + 1) AS weekofmonth, -- Calculating week of month
        EXTRACT(HOUR FROM date) AS hour
    FROM date_series
)

SELECT
    datetime_id,
    year,
    quarter,
    month,
    day,
    monthname,
    dayname,
    CAST(weekofmonth AS INT) AS weekofmonth, -- Ensuring week of month is integer
    weekofyear,
    hour
FROM date_parts
