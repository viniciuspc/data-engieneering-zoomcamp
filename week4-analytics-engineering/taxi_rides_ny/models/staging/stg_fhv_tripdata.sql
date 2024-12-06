{{ config(materialized='view') }}
 
with tripdata as 
(
  select *,
  from {{ source('staging','fhv_tripdata') }}
  where pickup_datetime BETWEEN '2019-01-01' AND '2019-12-31'
)
select
   -- identifiers
   cast(dispatching_base_num as string) as dispatching_base_num,
    {{ dbt.safe_cast("pulocationid", api.Column.translate_type("integer")) }} as pickup_locationid,
    {{ dbt.safe_cast("dolocationid", api.Column.translate_type("integer")) }} as dropoff_locationid,

    -- timestamps
    cast(pickup_datetime as timestamp) as pickup_datetime,
    cast(dropoff_datetime as timestamp) as dropoff_datetime,

    cast(SR_Flag as integer) as sr_flag,
    cast(affiliated_base_number as string) as affiliated_base_number
    
from tripdata

-- dbt build --select stg_fhv_tripdata.sql --vars '{'is_test_run': 'false'}'
{% if var('is_test_run', default=true) %}

  limit 100

{% endif %}