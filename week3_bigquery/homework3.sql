-- Creating external table referring to gcs path
CREATE OR REPLACE EXTERNAL TABLE `de-zoomcamp-viniciuspc.nytaxi.external_green_tripdata`
OPTIONS (
  format = 'parquet',
  uris = ['gs://mage-zoomcamp-viniciuspc/nyc_taxi_data/green_tripdata_2022-*.parquet']
);

-- Check green trip data
SELECT count(1) FROM de-zoomcamp-viniciuspc.nytaxi.external_green_tripdata;

-- Create a non partitioned table from external table
CREATE OR REPLACE TABLE de-zoomcamp-viniciuspc.nytaxi.green_tripdata_non_partitoned AS
SELECT * FROM de-zoomcamp-viniciuspc.nytaxi.external_green_tripdata;

-- Question 2
SELECT COUNT(DISTINCT(PULocationID)) FROM de-zoomcamp-viniciuspc.nytaxi.external_green_tripdata;

SELECT COUNT(DISTINCT(PULocationID)) FROM de-zoomcamp-viniciuspc.nytaxi.green_tripdata_non_partitoned;

-- Question 3
SELECT count(1) FROM de-zoomcamp-viniciuspc.nytaxi.external_green_tripdata WHERE fare_amount = 0;

-- Question 4
-- Creating a partition and cluster table
CREATE OR REPLACE TABLE de-zoomcamp-viniciuspc.nytaxi.green_tripdata_partitoned_clustered
PARTITION BY DATE(lpep_pickup_datetime)
CLUSTER BY PUlocationID AS
SELECT * FROM de-zoomcamp-viniciuspc.nytaxi.external_green_tripdata;

-- Question 5
SELECT DISTINCT(PULocationID) 
  FROM de-zoomcamp-viniciuspc.nytaxi.green_tripdata_non_partitoned
  WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30'
;

SELECT DISTINCT(PULocationID) 
  FROM de-zoomcamp-viniciuspc.nytaxi.external_green_tripdata
  WHERE DATE(lpep_pickup_datetime) BETWEEN '2022-06-01' AND '2022-06-30'
;

