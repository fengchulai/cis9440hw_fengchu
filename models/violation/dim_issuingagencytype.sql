{{
    config(
        materialized="table"
    )
}}

with
    raw_data as (
        select issuing_agency
        from violation_raw
        where issuing_agency is not null
    )

select
    row_number() over (order by issuing_agency) as issuingagencytype_id,
    issuing_agency as issuingagencytype
from raw_data
group by issuing_agency
