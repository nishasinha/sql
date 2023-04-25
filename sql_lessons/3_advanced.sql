-- 1. SQL Data Types
-- The SQL changes the data type as follows:
-- string -> VARCHAR (1024), any character with max field length as 1024
-- boolean -> BOOLEAN, Only TRUE or FALSE values.
-- numbers -> DOUBLE PRECISION, Numnerical with upton 17 significant digits decimal precision
-- date/time -> TIMESTAMP, format YYYY-MM-DD hh:mm:ss

-- CASTING of data type of a column can be done as:
  -- CAST(column_name AS data_type) or
  -- column_name:data_type

-- Q. Convert the funding_total_usd and founded_at_clean columns
-- in the tutorial.crunchbase_companies_clean_date table to strings (varchar format)
-- using a different formatting function for each one.

SELECT
*
FROM tutorial.crunchbase_companies_clean_date;

SELECT
  CAST(funding_total_usd AS VARCHAR), founded_at_clean::varchar
FROM tutorial.crunchbase_companies_clean_date;




-- 2.a Functions on Data Types - DATE
-- Dates are stored as Timestamp in SQL YYYY-MM-DD hh:mm:ss
-- In this format, it is easy to sort the column on date values.

SELECT permalink,
       founded_at
FROM tutorial.crunchbase_companies_clean_date
ORDER BY founded_at;

SELECT permalink,
       founded_at,
       founded_at_clean
FROM tutorial.crunchbase_companies_clean_date
ORDER BY founded_at_clean;


-- 2.b Functions on Data Types - INTERVAL
-- it is the duration of timestamp in SQL, obtained via
-- difference of two timestamps columns or
-- plain english terms like 5 days, 2 months
SELECT companies.permalink,
       companies.founded_at_clean,
       acquisitions.acquired_at_cleaned,
       acquisitions.acquired_at_cleaned -
         companies.founded_at_clean::timestamp AS time_to_acquisition
  FROM tutorial.crunchbase_companies_clean_date companies
  JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
    ON acquisitions.company_permalink = companies.permalink
 WHERE founded_at_clean IS NOT NULL;


-- Adding an interval to a timestamp column makes a new timestamp column
SELECT companies.permalink,
       companies.founded_at_clean,
       companies.founded_at_clean::timestamp +
         INTERVAL '1 week' AS plus_one_week
  FROM tutorial.crunchbase_companies_clean_date companies
 WHERE founded_at_clean IS NOT NULL;

-- Current time obtained via NOW() in column value
SELECT companies.permalink,
       companies.founded_at_clean,
       NOW() - companies.founded_at_clean::timestamp AS founded_time_ago
  FROM tutorial.crunchbase_companies_clean_date companies
 WHERE founded_at_clean IS NOT NULL

-- Q. Write a query that counts the number of companies acquired within
-- 3 years, 5 years, and 10 years of being founded (in 3 separate columns).
-- Include a column for total companies acquired as well.
-- Group by category and limit to only rows with a founding date.

SELECT * FROM tutorial.crunchbase_companies_clean_date; -- founded_at_clean
SELECT * FROM tutorial.crunchbase_acquisitions_clean_date; -- acquired_at_clean

SELECT
  companies.founded_at_clean,
  acquisitions.acquired_at_cleaned,
  acquisitions.acquired_at_cleaned::timestamp - companies.founded_at_clean::timestamp,
  acquisitions.acquired_at_cleaned::timestamp - companies.founded_at_clean::timestamp > INTERVAL '1095 days',
  CASE
    WHEN acquisitions.acquired_at_cleaned::timestamp - companies.founded_at_clean::timestamp > INTERVAL '3 years'
    THEN 1 ELSE NULL
  END AS gt_3
FROM tutorial.crunchbase_companies_clean_date companies
JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
ON companies.permalink = acquisitions.company_permalink
WHERE founded_at_clean IS NOT NULL;

SELECT
  companies.category_code,
  COUNT(CASE
    WHEN acquisitions.acquired_at_cleaned::timestamp - companies.founded_at_clean::timestamp > INTERVAL '3 years'
    THEN 1 ELSE NULL END) AS acquired_at_3,
  COUNT(CASE
    WHEN acquisitions.acquired_at_cleaned::timestamp - companies.founded_at_clean::timestamp > INTERVAL '5 years'
    THEN 1 ELSE NULL END) AS acquired_at_5,
  COUNT(CASE
    WHEN acquisitions.acquired_at_cleaned::timestamp - companies.founded_at_clean::timestamp > INTERVAL '10 years'
    THEN 1 ELSE NULL END) AS acquired_at_10,
  COUNT(acquisitions.acquired_at_cleaned) AS total_acquired_companies
FROM tutorial.crunchbase_companies_clean_date companies
JOIN tutorial.crunchbase_acquisitions_clean_date acquisitions
ON companies.permalink = acquisitions.company_permalink
WHERE founded_at_clean IS NOT NULL
GROUP BY category_code
ORDER BY total_acquired_companies;



-- 3. SQL Functions on STRING
-- They work on each row of data! Note this.
-- The function change the result column data type accordingly,
-- and the input column should respect the required data type.


SELECT *
FROM tutorial.sf_crime_incidents_2014_01;

-- a. LEFT(column_name, #charcaters): extracts the #chracters from the start of string in column
-- b. RIGHT(column_name, #characters): extracts the #characters from the end of the string in column
-- c. LENGTH(column_name): returns the length of the string in the column
-- One function can be called called other eg: RIGHT(date, LENGTH(date) - 11)


-- Eg: see date, its value is '01/31/2014 08:00:00 AM +0000'
-- 10 characters from start as date,
-- 17 characters from end as time
SELECT incidnt_num,
       date,
       LEFT(date, 10) AS cleaned_date,
       RIGHT(date, 17) AS cleaned_time_direct,
       RIGHT(date, LENGTH(date) - 11) AS cleaned_time_via_length
  FROM tutorial.sf_crime_incidents_2014_01;


-- d. TRIM Function
-- to trim characters from string
-- TRIM(both '()' FROM column_name) : means that remove (, ) characters from both ends of string in column_name
-- TRIM (start/end/both)

SELECT location,
       TRIM(leading '(' FROM location) AS from_start,
       TRIM(trailing ')' FROM location) AS from_end,
       TRIM(both '()' FROM location) AS from_both_ends
  FROM tutorial.sf_crime_incidents_2014_01;

-- e. POSTION/ STRPOS
-- f. LOWER(columnn_name), UPPER(column_name)
SELECT
  descript,
  LOWER(descript),
  UPPER(descript),
  STRPOS(descript, 'S'),
  POSTION('S' in descript)
FROM tutorial.sf_crime_incidents_2014_01;

SELECT
  descript,
  LOWER(descript),
  UPPER(descript),
  POSITION('A' in descript),
  STRPOS(descript, 'A')
FROM tutorial.sf_crime_incidents_2014_01;


-- g. SUBSTR(column_name, start_index, end_index)
-- Q. Write a query that separates the `location` field into separate fields for latitude and longitude.
-- You can compare your results against the actual `lat` and `lon` fields in the table.

SELECT * FROM tutorial.sf_crime_incidents_2014_01;

SELECT
  location,
  lat,
  SUBSTR(location, 2, POSITION(',' in location)-2) AS lat_1,
  lon,
  SUBSTR(location, POSITION(',' in location) + 1, LENGTH(location)-2) AS lon_1
FROM tutorial.sf_crime_incidents_2014_01;


-- h. CONCAT

-- Q. Concatenate the lat and lon fields to form a field that is equivalent to the location field.
-- (Note that the answer will have a different decimal precision.)

SELECT
  location,
  CONCAT('(', lat, ',', lon, ')')
FROM tutorial.sf_crime_incidents_2014_01;

-- Q. Create the same concatenated location field, but using the || syntax instead of CONCAT.
SELECT
  location,
  '(' || lat || ',' || lon || ')'
FROM tutorial.sf_crime_incidents_2014_01;


-- Q. Write a query that creates a date column formatted YYYY-MM-DD.
SELECT
  date,
  SUBSTR(date, 7, 4) || '-' || SUBSTR(date, 4, 2) || '-' || SUBSTR(date, 1, 2)
FROM tutorial.sf_crime_incidents_2014_01;


-- Q. Write a query that returns the `category` field, but with the first letter capitalized
-- and the rest of the letters in lower-case.

SELECT * FROM tutorial.sf_crime_incidents_2014_01;
SELECT
  category,
  CONCAT(UPPER(LEFT(category, 1)), LOWER(RIGHT(category, LENGTH(category) - 1))) AS category_capitalized
  FROM tutorial.sf_crime_incidents_2014_01;

-- Q. Write a query that creates an accurate timestamp using
-- the date and time columns in tutorial.sf_crime_incidents_2014_01.
-- Include a field that is exactly 1 week later as well.
SELECT incidnt_num,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp AS timestamp,
       (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||
        '-' || SUBSTR(date, 4, 2) || ' ' || time || ':00')::timestamp
        + INTERVAL '1 week' AS timestamp_plus_interval
  FROM tutorial.sf_crime_incidents_2014_01;



SELECT cleaned_date,
       EXTRACT('year'   FROM cleaned_date) AS year,
       EXTRACT('month'  FROM cleaned_date) AS month,
       EXTRACT('day'    FROM cleaned_date) AS day,
       EXTRACT('hour'   FROM cleaned_date) AS hour,
       EXTRACT('minute' FROM cleaned_date) AS minute,
       EXTRACT('second' FROM cleaned_date) AS second,
       EXTRACT('decade' FROM cleaned_date) AS decade,
       EXTRACT('dow'    FROM cleaned_date) AS day_of_week
  FROM tutorial.sf_crime_incidents_cleandate;


SELECT cleaned_date,
       DATE_TRUNC('year'   , cleaned_date) AS year,
       DATE_TRUNC('month'  , cleaned_date) AS month,
       DATE_TRUNC('week'   , cleaned_date) AS week,
       DATE_TRUNC('day'    , cleaned_date) AS day,
       DATE_TRUNC('hour'   , cleaned_date) AS hour,
       DATE_TRUNC('minute' , cleaned_date) AS minute,
       DATE_TRUNC('second' , cleaned_date) AS second,
       DATE_TRUNC('decade' , cleaned_date) AS decade
  FROM tutorial.sf_crime_incidents_cleandate;

-- Q. Write a query that counts the number of incidents reported by week.
-- Cast the week as a date to get rid of the hours/minutes/seconds.

SELECT
  DATE_TRUNC('week', cleaned_date) AS week,
  COUNT(*) AS incidents_in_week
FROM tutorial.sf_crime_incidents_cleandate
GROUP BY week
ORDER BY week;


SELECT
  CURRENT_DATE AS date,
  CURRENT_TIME AS time,
  CURRENT_TIME AT TIME ZONE 'IST' AS ist_time,
  CURRENT_TIMESTAMP AS timestamp,
  LOCALTIME AS local_time,
  LOCALTIMESTAMP AS local_timestamp,
  NOW() AS now;

-- Q. Write a query that shows exactly how long ago each indicent was reported.
-- Assume that the dataset is in Pacific Standard Time (UTC - 8).
SELECT * FROM tutorial.sf_crime_incidents_cleandate;

SELECT
  incidnt_num,
  cleaned_date,
  NOW() AT TIME ZONE 'PST' AS pst_now,
  NOW() AT TIME ZONE 'PST' - cleaned_date AS diff
FROM tutorial.sf_crime_incidents_cleandate;

-- i. COALESCE
-- to set some default value for a column with nulls

SELECT incidnt_num,
       descript,
       COALESCE(descript, 'No Description')
  FROM tutorial.sf_crime_incidents_cleandate
 ORDER BY descript DESC




-- 3. Subqueries
-- The subquery must be an independent query and the result dataset is like a table to the query wrapping it.

-- Subquery in FROM clause:
-- Q. Write a query that selects all Warrant Arrests from the tutorial.sf_crime_incidents_2014_01 dataset,
-- then wrap it in an outer query that only displays unresolved incidents.


SELECT * FROM tutorial.sf_crime_incidents_2014_01 dataset ;
SELECT distinct resolution FROM tutorial.sf_crime_incidents_2014_01 dataset ;

SELECT sub.*
FROM (
  SELECT
    *
  FROM tutorial.sf_crime_incidents_2014_01 dataset
  WHERE descript = 'WARRANT ARREST'
) sub
WHERE sub.resolution = 'NONE';


-- Using subqueries to aggregate in multiple stages
-- Q. Write a query that displays the average number of monthly incidents for each category.
-- Hint: use tutorial.sf_crime_incidents_cleandate to make your life a little easier.

SELECT * FROM tutorial.sf_crime_incidents_cleandate;

SELECT
  sub.category,
  AVG(sub.cataegory_month_incidents) AS avg_monthly_incidents
FROM (
  SELECT
    category,
    LEFT(date, 2) AS month,
    COUNT(*) AS cataegory_month_incidents
  FROM tutorial.sf_crime_incidents_cleandate
  GROUP BY category, month
) sub
GROUP BY sub.category;


SELECT sub.category,
       AVG(sub.incidents) AS avg_incidents_per_month
  FROM (
        SELECT EXTRACT('month' FROM cleaned_date) AS month,
               category,
               COUNT(1) AS incidents
          FROM tutorial.sf_crime_incidents_cleandate
         GROUP BY 1,2
       ) sub
 GROUP BY 1


-- Subqueries in conditional logic
-- no alias needed, it is considered as a value
-- the subquery eveluates toa value ,not a table.

SELECT *
  FROM tutorial.sf_crime_incidents_2014_01
 WHERE Date = (SELECT MIN(date)
                 FROM tutorial.sf_crime_incidents_2014_01
              )


-- Joining subqueries
-- Q. ranks all of the results according to how many incidents were reported in a given day

SELECT incidents.*,
       sub.incidents AS incidents_that_day
  FROM tutorial.sf_crime_incidents_2014_01 incidents
  JOIN ( SELECT date,
          COUNT(incidnt_num) AS incidents
           FROM tutorial.sf_crime_incidents_2014_01
          GROUP BY 1
       ) sub
    ON incidents.date = sub.date
 ORDER BY sub.incidents DESC, time




-- 4. Windows
-- Window functions are used to perform aggregations over group of rows,
-- but unlike aggregate functions they do not combine combine rows and produce one row as result,
-- instead each rows has its identity maintained with one agg col added.

SELECT * FROM tutorial.dc_bikeshare_q1_2012;


-- SUM(col_1) OVER (ORDER BY col_2)
-- would run the sum over col1, with rows sorted by col2
SELECT
  start_time,
  duration_seconds,
  SUM(duration_seconds) OVER (ORDER BY start_time) AS running_total
FROM tutorial.dc_bikeshare_q1_2012;

-- SUM(col1) OVER (PARTITION_BY col2 ORDER BY col3)
-- would run the sum function over col1, in groups of col2 rows, with rows sorted by col3.
SELECT
  start_terminal,
  duration_seconds,
  SUM(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY start_time) AS partitioned_running_total
FROM tutorial.dc_bikeshare_q1_2012;

-- OVER (PARTITION BY col1 ORDER BY col2)
  -- defines the window to partition by and order the rows by to get aggregates
-- WINDOW and GROUP BY cannot be used together

-- Q. Write a query modification of the above example query
-- that shows the duration of each ride as a percentage of the total time accrued by riders from each start_terminal

SELECT
  start_terminal,
  duration_seconds,
  SUM(duration_seconds) OVER(PARTITION BY start_terminal ORDER BY start_time) AS duration_sum_by_terminal,
  (duration_seconds / SUM(duration_seconds) OVER(PARTITION BY start_terminal ORDER BY start_time)) * 100 AS duration_percent_by_terminal
FROM tutorial.dc_bikeshare_q1_2012;


-- Other agg functions
SELECT
  start_terminal,
  duration_seconds,
  SUM(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS sum_agg,
  AVG(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS avg_agg,
  COUNT(duration_seconds) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS count_agg
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08';

-- Q. Write a query that shows a running total of the duration of bike rides (similar to the last example),
-- but grouped by end_terminal, and with ride duration sorted in descending order.
SELECT
  end_terminal,
  duration_seconds,
  SUM(duration_seconds) OVER(PARTITION BY end_terminal ORDER BY duration_seconds desc) AS running_total
FROM tutorial.dc_bikeshare_q1_2012;


-- ROW_NUMBER()
-- to get the row number for the given row in the dataset.


-- ROW_NUMBER() OVER (PARTITION BY col1 ORDER BY col2)
-- count row number as 1 for each partition
SELECT
  start_terminal,
  start_time,
  duration_seconds,
  ROW_NUMBER() OVER (PARTITION BY start_terminal ORDER BY start_time) AS row_number
FROM tutorial.dc_bikeshare_q1_2012;

-- count row number over table
SELECT
  start_terminal,
  start_time,
  duration_seconds,
  ROW_NUMBER() OVER (ORDER BY start_terminal, start_time) AS row_number_unparted
FROM tutorial.dc_bikeshare_q1_2012;

-- RANK()
  -- gives the rows with same value of order by column the same rank but skips the rank from the table.
-- DENSE_RANK()
  -- gives the rows with same value of order by column the same rank but DOES NOT skip the rank from the table.
SELECT
  start_terminal,
  start_time,
  RANK() OVER (PARTITION BY start_terminal ORDER BY start_time) AS row_rank,
  DENSE_RANK() OVER (PARTITION BY start_terminal ORDER BY start_time) AS row_rank_dense
FROM tutorial.dc_bikeshare_q1_2012;

-- Q. Write a query that shows the 5 longest rides from each starting terminal,
-- ordered by terminal, and longest to shortest rides within each terminal.
-- Limit to rides that occurred before Jan. 8, 2012.
SELECT
  start_time,
  duration_seconds,
  start_terminal,
  RANK() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS rank_result
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08' AND rank_result < 5;


-- NOTE: WINDOW FUNCTION result cannot be used in where clause.
SELECT *
  FROM (
        SELECT start_terminal,
               start_time,
               duration_seconds,
               RANK() OVER (PARTITION BY start_terminal ORDER BY duration_seconds DESC) AS rank
          FROM tutorial.dc_bikeshare_q1_2012
         WHERE start_time < '2012-01-08'
               ) sub
 WHERE sub.rank <= 5;

-- NTILE(#buckets) OVER (WINDOW)
-- to determine what ntile a rows falls into
SELECT start_terminal,
       duration_seconds,
       NTILE(4) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
          AS quartile,
       NTILE(5) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS quintile,
       NTILE(100) OVER
         (PARTITION BY start_terminal ORDER BY duration_seconds)
         AS percentile
  FROM tutorial.dc_bikeshare_q1_2012
 WHERE start_time < '2012-01-08'
 ORDER BY start_terminal, duration_seconds;


-- Q. Write a query that shows only the duration of the trip
-- and the percentile into which that duration falls
-- (across the entire dataset—not partitioned by terminal).
SELECT
  duration_seconds,
  NTILE(100) OVER (ORDER BY duration_seconds)
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
ORDER BY duration_seconds;

-- LAG and LEAD: to pull values from other rows in the given row

-- LAG(col, row_number) OVER (window)
-- LAG to pull values from previous rows.

-- LEAD(col, row_number) OVER (window)
-- LEAD to pull values from next rows.

SELECT
  start_terminal,
  duration_seconds,
  LAG(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag1,
  LAG(duration_seconds, 2) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag2,
  LAG(duration_seconds, 3) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lag3,
  LEAD(duration_seconds, 1) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead1,
  LEAD(duration_seconds, 2) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead2,
  LEAD(duration_seconds, 3) OVER (PARTITION BY start_terminal ORDER BY duration_seconds) AS lead3
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
ORDER BY start_terminal, duration_seconds;

-- using lag to calculate diff from the value on last 2nd row
SELECT start_terminal, duration_seconds,
  LAG(duration_seconds, 2) OVER my_window AS lag,
  duration_seconds - LAG(duration_seconds, 2) OVER my_window AS diff
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
WINDOW my_window AS (PARTITION BY start_terminal ORDER BY duration_seconds)
ORDER BY start_terminal, duration_seconds;

-- to avoid nulls in starting or ending rows due to lag or lead, we can use filter.
-- but the filter can be done on subquery, direct agg column of window function cannot be used in where clause
SELECT sub.* FROM (
  SELECT start_terminal, duration_seconds,
    LAG(duration_seconds, 2) OVER my_window AS lag,
    duration_seconds - LAG(duration_seconds, 2) OVER my_window AS diff
  FROM tutorial.dc_bikeshare_q1_2012
  WHERE start_time < '2012-01-08'
  WINDOW my_window AS (PARTITION BY start_terminal ORDER BY duration_seconds)
  ORDER BY start_terminal, duration_seconds
) sub
WHERE sub.diff IS NOT NULL;


-- Other window functions:

-- percent_rank(): relative rank of the current row: (rank - 1) / (total rows - 1)
-- cume_dist(): relative rank of the current row: (number of rows preceding or peer with current row) / (total rows)
SELECT
  start_terminal,
  duration_seconds,
  RANK() OVER my_window,
  DENSE_RANK() OVER my_window,
  PERCENT_RANK() OVER my_window,
  CUME_DIST() OVER my_window
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
WINDOW my_window AS (PARTITION BY start_terminal ORDER BY duration_seconds)
ORDER BY start_terminal, duration_seconds;

-- FIRST_VALUE(col) OVER (window)
-- returns value evaluated at the row that is the first row of the window frame

-- LAST_VALUE(col) OVER (window)
-- returns value evaluated at the row that is the last row of the window frame

-- NTH_VALUE(col, n) OVER (window)
-- returns value evaluated at the row that is the nth row of the window frame
-- returns value evaluated at the row that is the nth row of the window frame (counting from 1); null if no such row
SELECT
  start_terminal,
  duration_seconds,
  FIRST_VALUE(duration_seconds) OVER my_window,
  LAST_VALUE(duration_seconds) OVER my_window,
  NTH_VALUE(duration_seconds, 3) OVER my_window
FROM tutorial.dc_bikeshare_q1_2012
WHERE start_time < '2012-01-08'
WINDOW my_window AS (PARTITION BY start_terminal ORDER BY duration_seconds)
ORDER BY start_terminal, duration_seconds;


-- SQL Performance tuning
-- 1. Query on small datasets.
-- 2. before join, do agg on tables and then join on agg result set.
-- 3. Use EXPLAIN to see the cost of the query.



-- PIVOTING -- To convert rows to columns
-- Steps: collect result, convert to subquery, convert to required columns
SELECT teams.conference AS conference,
       players.year,
       COUNT(1) AS players
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name
 GROUP BY 1,2
 ORDER BY 1,2;

SELECT *
  FROM (
        SELECT teams.conference AS conference,
               players.year,
               COUNT(1) AS players
          FROM benn.college_football_players players
          JOIN benn.college_football_teams teams
            ON teams.school_name = players.school_name
         GROUP BY 1,2
       ) sub;

SELECT conference,
       SUM(players) AS total_players,
       SUM(CASE WHEN year = 'FR' THEN players ELSE NULL END) AS fr,
       SUM(CASE WHEN year = 'SO' THEN players ELSE NULL END) AS so,
       SUM(CASE WHEN year = 'JR' THEN players ELSE NULL END) AS jr,
       SUM(CASE WHEN year = 'SR' THEN players ELSE NULL END) AS sr
  FROM (
        SELECT teams.conference AS conference,
               players.year,
               COUNT(1) AS players
          FROM benn.college_football_players players
          JOIN benn.college_football_teams teams
            ON teams.school_name = players.school_name
         GROUP BY 1,2
       ) sub
 GROUP BY 1
 ORDER BY 2 DESC;

-- PIVOTING : columns to rows
SELECT *
  FROM tutorial.worldwide_earthquakes;

SELECT year
  FROM (VALUES (2000),(2001),(2002),(2003),(2004),(2005),(2006),
               (2007),(2008),(2009),(2010),(2011),(2012)) v(year);

SELECT years.*,
       earthquakes.magnitude,
       CASE year
         WHEN 2000 THEN year_2000
         WHEN 2001 THEN year_2001
         WHEN 2002 THEN year_2002
         WHEN 2003 THEN year_2003
         WHEN 2004 THEN year_2004
         WHEN 2005 THEN year_2005
         WHEN 2006 THEN year_2006
         WHEN 2007 THEN year_2007
         WHEN 2008 THEN year_2008
         WHEN 2009 THEN year_2009
         WHEN 2010 THEN year_2010
         WHEN 2011 THEN year_2011
         WHEN 2012 THEN year_2012
         ELSE NULL END
         AS number_of_earthquakes
  FROM tutorial.worldwide_earthquakes earthquakes
 CROSS JOIN (
       SELECT year
         FROM (VALUES (2000),(2001),(2002),(2003),(2004),(2005),(2006),
                      (2007),(2008),(2009),(2010),(2011),(2012)) v(year)
       ) years