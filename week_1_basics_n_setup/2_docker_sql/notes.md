## Create a network to connect postgrees database with pgadmin
docker network create pg-network

## Docker for postgress database
docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    --network=pg-network \
    --name pg-database \
    postgres:13

pgcli -h localhost -p 5432 -u root -d ny_taxi

## More about pandas
More about pandas https://github.com/DataTalksClub/machine-learning-zoomcamp/blob/master/01-intro/09-pandas.md

## Docker for pg admin
docker run -it \
  -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
  -e PGADMIN_DEFAULT_PASSWORD="root" \
  -p 8080:80 \
  --network=pg-network \
  --name pgadmin \
  dpage/pgadmin4

## Run the ingest
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2021-01.csv.gz"

### Command line
python3 ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=yellow_taxi_trips \
  --url=${URL}

### With docker
docker buildx build -t taxi_ingest:v001 .

docker run -it \
  --network=pg-network \
  taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name=yellow_taxi_trips \
    --url=${URL}

## Ingest for green taxi
## Run the ingest
URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2019-09.csv.gz"

### Command line
python3 green_ingest_data.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --table_name=green_taxi_trips \
  --url=${URL}

## Docker compose
docker compose up
docker compose up -d
docker compose down

## Make pgadmin confi persistant
mkdir data_pgadmin
sudo chown 5050:5050 data_pgadmin
volumes:
  - ./data_pgadmin:/var/lib/pgadmin

## SQL

### Ingest extra data for zones and parquet
URL=https://d37ci6vzurychx.cloudfront.net/misc/taxi+_zone_lookup.csv

python3 data-loading-parquet.py \
  --user=root \
  --password=root \
  --host=localhost \
  --port=5432 \
  --db=ny_taxi \
  --tb=zones \
  --url=${URL}

### (Inner) Join using where
SELECT
	t.tpep_pickup_datetime,
	t.tpep_dropoff_datetime,
	t.total_amount,
	CONCAT(zpu."Borough", ' / ', zpu."Zone") AS "pickup_loc",
	CONCAT(zdo."Borough", ' / ', zdo."Zone") AS "dropoff_loc"
FROM 
	yellow_taxi_trips t, 
	zones zpu, 
	zones zdo 
WHERE 
	t."PULocationID" = zpu."LocationID" AND
	t."DOLocationID" = zdo."LocationID"
LIMIT 100;

### Inner Join
SELECT
	t.tpep_pickup_datetime,
	t.tpep_dropoff_datetime,
	t.total_amount,
	CONCAT(zpu."Borough", ' / ', zpu."Zone") AS "pickup_loc",
	CONCAT(zdo."Borough", ' / ', zdo."Zone") AS "dropoff_loc"
FROM 
	yellow_taxi_trips t JOIN  zones zpu
		ON t."PULocationID" = zpu."LocationID"
	JOIN zones zdo
		ON t."DOLocationID" = zdo."LocationID"
LIMIT 100;

### Check if there a trip whitout DOLocationID
SELECT
	t.tpep_pickup_datetime,
	t.tpep_dropoff_datetime,
	t.total_amount,
	t."PULocationID",
	t."DOLocationID"
FROM 
	yellow_taxi_trips as t
WHERE
	t."DOLocationID" IS NULL
LIMIT 100;

### Check if there is any trip that has a DOLocationID that is not in the zones table
SELECT
	t.tpep_pickup_datetime,
	t.tpep_dropoff_datetime,
	t.total_amount,
	t."PULocationID",
	t."DOLocationID"
FROM 
	yellow_taxi_trips as t
WHERE
	t."DOLocationID" NOT IN ( SELECT "LocationID" from zones)
LIMIT 100;

### Left join, used to when you want to show the record on the left even if there is no record on right for it
SELECT
	t.tpep_pickup_datetime,
	t.tpep_dropoff_datetime,
	t.total_amount,
	CONCAT(zpu."Borough", ' / ', zpu."Zone") AS "pickup_loc",
	CONCAT(zdo."Borough", ' / ', zdo."Zone") AS "dropoff_loc"
FROM 
	yellow_taxi_trips t LEFT JOIN  zones zpu
		ON t."PULocationID" = zpu."LocationID"
	LEFT JOIN zones zdo
		ON t."DOLocationID" = zdo."LocationID"
LIMIT 100;

### Group by
SELECT
	CAST(t.tpep_pickup_datetime AS DATE) as day,
	COUNT(1) as "count",
	MAX(t.total_amount),
	MAX(t.passenger_count)
FROM 
	yellow_taxi_trips t
GROUP BY
	day
ORDER BY "count" DESC;

### Group by multiple fields (group by day and DOLocationID)
SELECT
	CAST(t.tpep_pickup_datetime AS DATE) as "day",
	t."DOLocationID",
	COUNT(1) as "count",
	MAX(t.total_amount),
	MAX(t.passenger_count)
FROM 
	yellow_taxi_trips t
GROUP BY
	1, 2
ORDER BY "day" ASC, t."DOLocationID" ASC;