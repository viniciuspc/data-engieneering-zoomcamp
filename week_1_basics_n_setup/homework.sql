SELECT * FROM zones;

SELECT 
	COUNT(1) 
FROM 
	green_taxi_trips 
WHERE 
	CAST(lpep_pickup_datetime AS DATE) = '2019-09-18' 
	AND 
	CAST(lpep_dropoff_datetime AS DATE) = '2019-09-18';

SELECT 
	CAST(lpep_pickup_datetime AS DATE) as "pickup_day",
	MAX(trip_distance) as "max_trip_distance"
FROM 
	green_taxi_trips 
GROUP BY
	"pickup_day"
ORDER BY
	"max_trip_distance" DESC
LIMIT 1

SELECT
	z."Borough"
FROM
	green_taxi_trips t JOIN zones z
		ON t."PULocationID" = z."LocationID"
WHERE 
	z."Borough" IS NOT NULL
	AND
	z."Borough" != 'Unknown'
GROUP BY
	z."Borough"
HAVING
	SUM(t.total_amount) > 50000
ORDER BY
	SUM(t.total_amount) DESC
LIMIT 3;

SELECT
	zdo."Zone" as "dropoff_zone"
FROM
	green_taxi_trips t JOIN zones zpu
		ON t."PULocationID" = zpu."LocationID"
	JOIN zones zdo
		ON t."DOLocationID" = zdo."LocationID"
WHERE
	zpu."Zone" = 'Astoria' 
	AND
	(CAST(t.lpep_pickup_datetime AS DATE) >= '2019-09-01' AND CAST(t.lpep_pickup_datetime AS DATE) < '2019-10-01')
ORDER BY 
	t.tip_amount DESC
LIMIT 1