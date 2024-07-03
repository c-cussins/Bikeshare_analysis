SELECT *
FROM public.santander_stations
;

SELECT *
FROM public.santander_2016
LIMIT 20
;


--what stations are most popular for starting and ending?

--start

SELECT
ss1.name as start_station
--, ss2.name as end_station
, COUNT(*)
FROM public.santander_2016 s1
JOIN public.santander_stations ss1
ON s1.startstationid = ss1.id
JOIN public.santander_stations ss2
ON s1.startstationid = ss2.id
GROUP BY 1
UNION
SELECT
ss1.name as start_station
--, ss2.name as end_station
, COUNT(*)
FROM public.santander_2017 s1
JOIN public.santander_stations ss1
ON s1.startstationid = ss1.id
JOIN public.santander_stations ss2
ON s1.startstationid = ss2.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10

;

--end

SELECT
--ss1.name as start_station
ss2.name as end_station
, COUNT(*)
FROM public.santander_2016 s1
JOIN public.santander_stations ss1
ON s1.startstationid = ss1.id
JOIN public.santander_stations ss2
ON s1.startstationid = ss2.id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1
;




--Average trip time?


WITH av_trip_time AS (SELECT '2016' as year
, AVG(end_date - start_date) as trip_time
FROM public.santander_2016
WHERE (end_date - start_date) IS NOT NULL
UNION
SELECT '2017' as year
, AVG(end_date - start_date) as trip_time
FROM public.santander_2017
WHERE (end_date - start_date) IS NOT NULL
UNION
SELECT '2018' as year
, AVG(end_date - start_date) as trip_time
FROM public.santander_2018
WHERE (end_date - start_date) IS NOT NULL
UNION
SELECT '2019' as year
, AVG(end_date - start_date) as trip_time
FROM public.santander_2019
WHERE (end_date - start_date) IS NOT NULL)


SELECT AVG(trip_time)
FROM av_trip_time
;


--Peak time ? Trend analysis

SELECT 
TO_CHAR(start_date, 'dd-mm-yyyy') as start_date
, COUNT(start_date)
FROM public.santander_2016
GROUP BY 1
ORDER BY 2 DESC
--LIMIT 10
;

SELECT
--HOUR(CAST(start_date as time)) as start_time
DATE_PART('hour',start_date)
, COUNT(start_date)
FROM public.santander_2016
GROUP BY 1
ORDER BY 2 DESC
;

-- TIME of day aggregated over all the years

WITH start_time AS (SELECT
DATE_PART('hour',start_date) as hour
, COUNT(rental_id) as no_rides
FROM public.santander_2016
GROUP BY 1
UNION                 
SELECT
DATE_PART('hour',start_date) as hour
, COUNT(rental_id) as no_rides
FROM public.santander_2017
GROUP BY 1
UNION
SELECT
DATE_PART('hour',start_date) as hour
, COUNT(rental_id) as no_rides
FROM public.santander_2018
GROUP BY 1
UNION
SELECT
DATE_PART('hour',start_date) as hour
, COUNT(rental_id) as no_rides
FROM public.santander_2019
GROUP BY 1)
                    
SELECT hour
, SUM(no_rides)
FROM start_time
GROUP BY 1
ORDER BY 2 DESC
;


--month by year
SELECT 
TO_CHAR(start_date, 'mm-yyyy') as start_date
, COUNT(start_date)
FROM public.santander_2016
GROUP BY 1
ORDER BY 2 DESC
--LIMIT 10
;


-- all months per year

SELECT
TO_CHAR(start_date, 'mm-yyyy') as start_date
, COUNT(start_date)
FROM public.santander_2016
GROUP BY 1
UNION
SELECT
TO_CHAR(start_date, 'mm-yyyy') as start_date
, COUNT(start_date)
FROM public.santander_2017
GROUP BY 1
UNION
SELECT
TO_CHAR(start_date, 'mm-yyyy') as start_date
, COUNT(start_date)
FROM public.santander_2018
GROUP BY 1
UNION
SELECT
TO_CHAR(start_date, 'mm-yyyy') as start_date
, COUNT(start_date)
FROM public.santander_2019
GROUP BY 1
ORDER BY 2 DESC
;



--What bikes are most used/popular?

WITH bike_usage AS (SELECT bike_id
, COUNT(rental_id) as total_rides
FROM public.santander_2016
GROUP BY 1
UNION
SELECT bike_id
, COUNT(rental_id) as total_rides
FROM public.santander_2017
GROUP BY 1
UNION
SELECT bike_id
, COUNT(rental_id) as total_rides
FROM public.santander_2018
GROUP BY 1
UNION
SELECT bike_id
, COUNT(rental_id) as total_rides
FROM public.santander_2019
GROUP BY 1)

SELECT bike_id
, SUM(total_rides)
FROM bike_usage
GROUP BY 1
ORDER BY 2 DESC
;

--What docks are most and least popular?






--Different user types for various stations, 
--are there any correlations between the users of different stations?





--Total stations
--Total capacity
--Total capacity by area
--Average duration

WITH av_trip_time AS (SELECT '2016' as year
, AVG(end_date - start_date) as trip_time
FROM public.santander_2016
WHERE (end_date - start_date) IS NOT NULL
UNION
SELECT '2017' as year
, AVG(end_date - start_date) as trip_time
FROM public.santander_2017
WHERE (end_date - start_date) IS NOT NULL
UNION
SELECT '2018' as year
, AVG(end_date - start_date) as trip_time
FROM public.santander_2018
WHERE (end_date - start_date) IS NOT NULL
UNION
SELECT '2019' as year
, AVG(end_date - start_date) as trip_time
FROM public.santander_2019
WHERE (end_date - start_date) IS NOT NULL)


SELECT AVG(trip_time)
FROM av_trip_time
;

--Longest duration

WITH av_trip_time AS (SELECT '2016' as year
, MAX(end_date - start_date) as MAX_trip_time
, MIN (end_date - start_date) as min_trip_time
FROM public.santander_2016
UNION
SELECT '2017' as year
, MAX(end_date - start_date) as max_trip_time
, MIN (end_date - start_date) as min_trip_time
FROM public.santander_2017
WHERE (end_date - start_date) IS NOT NULL
UNION
SELECT '2018' as year
, MAX(end_date - start_date) as MAX_trip_time
, MIN (end_date - start_date) as min_trip_time
FROM public.santander_2018
WHERE (end_date - start_date) IS NOT NULL
UNION
SELECT '2019' as year
, MAX(end_date - start_date) as MAX_trip_time
, MIN (end_date - start_date) as min_trip_time
FROM public.santander_2019
WHERE (end_date - start_date) IS NOT NULL)


SELECT MAX(max_trip_time)
, MIN(min_trip_time)
FROM av_trip_time
;

--Shortest duration
--Busiest station
-- Peak times


WITH start_time AS (SELECT
DATE_PART('hour',start_date) as hour
, COUNT(rental_id) as no_rides
FROM public.santander_2016
GROUP BY 1
UNION                 
SELECT
DATE_PART('hour',start_date) as hour
, COUNT(rental_id) as no_rides
FROM public.santander_2017
GROUP BY 1
UNION
SELECT
DATE_PART('hour',start_date) as hour
, COUNT(rental_id) as no_rides
FROM public.santander_2018
GROUP BY 1
UNION
SELECT
DATE_PART('hour',start_date) as hour
, COUNT(rental_id) as no_rides
FROM public.santander_2019
GROUP BY 1)
                    
SELECT hour
, SUM(no_rides)
FROM start_time
GROUP BY 1
ORDER BY 2 DESC
;





-- locations at peak times 

WITH all_journeys AS (Select * FROM public.santander_2016
                     UNION
                     Select * FROM public.santander_2017
                     UNION
                     Select * FROM public.santander_2018
                     UNION
                     Select * FROM public.santander_2019
                     ) 
                     
SELECT
SPLIT_PART(ss1.name, ',', 2) as start_station 
, COUNT (rental_id) as total_rides
, AVG(end_date - start_date)
FROM all_journeys aj
JOIN public.santander_stations ss1
ON aj.startstationid = ss1.id
--WHERE DATE_PART('hour',start_date) IN (8, 17)
WHERE (end_date - start_date) < INTERVAL '2 hours'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
;




-- no of docks per location 

SELECT SPLIT_PART(name, ',', 2)
, SUM(docks)
FROM public.santander_stations
GROUP BY 1
ORDER BY 2 DESC;








--Most common user type
--Share of riders by gender
--Share of riders by age/ age group / generation
--Capacity of docks by station
--Frequency by age / gender / customer type
--Recommendation for new stations