{{
    config(
        materialized="table"
    )
}}

WITH corrected_table AS (
    SELECT
        summons_number,
        fine_amount,
        penalty_amount,
        interest_amount,
        reduction_amount,
        payment_amount,
        issue_date,
        license_type,
        issuing_agency,
        CASE
            WHEN REGEXP_LIKE(TRIM(precinct), '^[0-9]+(\.[0-9]+)?$') THEN FLOOR(precinct::numeric)
            ELSE NULL
        END AS precinct,
        CASE
            WHEN LOWER(TRIM(county)) LIKE 'q%' THEN 'QN'
            WHEN LOWER(TRIM(county)) LIKE '%k%' OR LOWER(TRIM(county)) LIKE '%bk%' THEN 'BK'
            WHEN LOWER(TRIM(county)) LIKE 's%' THEN 'ST'
            WHEN LOWER(TRIM(county)) LIKE 'm%' OR LOWER(TRIM(county)) LIKE '%ny%' THEN 'MN'
            WHEN LOWER(TRIM(county)) LIKE '%b%x%' THEN 'BX'
            ELSE 'Unknown'
        END AS county,
        TRIM(state) AS state,
        violation,
        -- Add 'M' to 'A'/'P' to form a valid AM/PM string and then convert to timestamp
        TRY_TO_TIMESTAMP(violation_time || 'M', 'HH12:MIPM') AS violation_time_corrected
    FROM violation_raw
),

fact_violations AS (
    SELECT
        ct.summons_number AS fact_id,  -- Unique identifier
        ct.fine_amount,
        ct.penalty_amount,
        ct.interest_amount,
        ct.reduction_amount,
        ct.payment_amount,
        dt.datetime_id,
        ia.issuingagencytype_id,
        lt.licensetype_id,
        lc.location_id,
        vt.violationtype_id
    FROM corrected_table ct
    LEFT JOIN dim_datetime dt
        ON ct.issue_date = TO_DATE(dt.year || '-' || LPAD(dt.month::text, 2, '0') || '-' || LPAD(dt.day::text, 2, '0'), 'YYYY-MM-DD')
        AND EXTRACT(HOUR FROM ct.violation_time_corrected) = dt.hour  -- Ensure hour matches
    LEFT JOIN dim_issuingagencytype ia
        ON ct.issuing_agency = ia.issuingagencytype
    LEFT JOIN dim_licensetype lt
        ON ct.license_type = lt.licensetype
    LEFT JOIN dim_location lc
        ON ct.precinct::text = lc.precinct::text AND LOWER(ct.county) = LOWER(lc.county) AND LOWER(ct.state) = LOWER(lc.state)
    LEFT JOIN dim_violationtype vt
        ON ct.violation = vt.violationtype
)

SELECT
    fact_id,
    fine_amount,
    penalty_amount,
    interest_amount,
    reduction_amount,
    payment_amount,
    datetime_id,
    issuingagencytype_id,
    licensetype_id,
    location_id,
    violationtype_id
FROM
    fact_violations
