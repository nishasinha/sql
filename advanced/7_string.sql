-- 16. String Wrangling 
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01 LIMIT 10;
  
  -- To clean the strings, there are some functions like: LEFT, LENGTH, TRIM etc
  -- the functions are operated as column values in select clause.

-- a. SUBSTRING
  -- LEFT, RIGHT, LENGTH
SELECT 
  incidnt_num,
  date,
  LEFT(date, 10) AS cleaned_date,   -- returns 10 characters from left of date
  RIGHT(date, LENGTH(date)- 11) AS cleaned_time -- returns LENGTH(date) - 11 characters from right of string
FROM tutorial.sf_crime_incidents_2014_01;


-- b. TRIM
  -- TRIM(leading/ trailing/ both 'characters_to_trim' FROM 'column/ data to trim from')
  -- will remive the characters_to_trim from the position
SELECT 
  location,
  TRIM(both '()' FROM location) AS cleaned_location, -- remove '(' or ')' from start and end both
  TRIM(leading ' a' FROM name), -- remove 'space' and 'a' from start
  TRIM(trailing ';' FROM name), -- remove ';' from end
FROM tutorial.sf_crime_incidents_2014_01;


-- c. SUBSTRING
SELECT 
  POSITION('A' IN name_col) AS A_position, -- position of 'A' in name_col
  STROPS(name_col, 'B') AS B_poistion, -- position of 'B' in name_col
  POSITION('c' IN LOWER(name_col)) AS C_position -- position of 'C' or 'c' in name_col
  SUBSTR(date, 4, 2) AS day -- extract substring of date, characters 4,5 

  -- Write a query that separates the `location` field into separate fields for latitude and longitude. 
  -- You can compare your results against the actual `lat` and `lon` fields in the table.
SELECT 
  location,
  lat,
  SUBSTR(TRIM(both ' ()' FROM location), 0, POSITION(',' IN location)-1) AS extracted_lat,
  lon,
  SUBSTR(TRIM(both ' ()' FROM location), POSITION(',' IN location)+1, LENGTH(location)-1) as extracted_lon
FROM tutorial.sf_crime_incidents_2014_01
LIMIT 5;


-- d.CONCAT
  -- CONCAT using CONCAT(v1, v2, v3) or via || operator
SELECT
  CONCAT(first_name, '-', last_name),
  first_name || '-' || last_name
FROM profiles;

  -- Concatenate the lat and lon fields to form a field that is equivalent to the location field. 
    -- (Note that the answer will have a different decimal precision.)
SELECT 
  location,
  CONCAT('(', lat, ', ', lon, ')') as loc_1,
  '(' || lat || ', ' || lon || ')' as loc_2
FROM tutorial.sf_crime_incidents_2014_01;

  -- Write a query that creates a date column formatted YYYY-MM-DD.
SELECT
  date,
  SUBSTR(date, 7, 4) || '-' ||  SUBSTR(date, 4, 2) || '-' || SUBSTR(date, 1, 2) as cleaned_date
FROM tutorial.sf_crime_incidents_2014_01;


-- e. LOWER(), UPPER()
  -- Write a query that returns the `category` field, but with the first letter capitalized and the rest of the letters in lower-case.
SELECT
  category,
  UPPER(LEFT(category, 1)) || LOWER(RIGHT(category, LENGTH(category) - 1)) AS cased_column
FROM tutorial.sf_crime_incidents_2014_01
LIMIT 10;


-- f. Date wrangling
  -- Write a query that creates an accurate timestamp using the date and time columns in tutorial.sf_crime_incidents_2014_01. 
    -- Include a field that is exactly 1 week later as well. 
SELECT 
  date,
  time,
  (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||'-' || SUBSTR(date, 4, 2) || ' ' || time)::timestamp AS ts,
  (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) ||'-' || SUBSTR(date, 4, 2) || ' ' || time)::timestamp + '1 week' AS ts_plus_1_week
FROM tutorial.sf_crime_incidents_2014_01
LIMIT 10;

SELECT *
FROM tutorial.sf_crime_incidents_cleandate LIMIT 10;

-- g. EXTRACT('x' FROM date) AS date_extracted_part
    -- x can be year/ month/ day/ dow/ week/ hour/ minute/ second
SELECT
  DISTINCT EXTRACT('year' FROM cleaned_date) AS year
FROM tutorial.sf_crime_incidents_cleandate
LIMIT 10;


-- h.DATE_TRUNC('x', date) AS date_truncated_to_start_of_x
    -- x can be year/ month/ day/ dow/ week/ hour/ minute/ second
SELECT
  DATE_TRUNC('year', cleaned_date) AS year_start
FROM tutorial.sf_crime_incidents_cleandate
LIMIT 10;

  -- Write a query that counts the number of incidents reported by week. 
    -- Cast the week asincidnt_num a date to get rid of the hours/minutes/seconds. 
SELECT
  COUNT(incidnt_num) AS incident_count,
  EXTRACT('week' FROM cleaned_date) AS week
FROM tutorial.sf_crime_incidents_cleandate
GROUP BY week;

-- i. Some DATE Functions

SELECT CURRENT_DATE AS date,
       CURRENT_TIME AS time,
       CURRENT_TIME AT TIME ZONE 'PST' AS my_time,
       CURRENT_TIMESTAMP AS timestamp,
       LOCALTIME AS localtime,
       LOCALTIMESTAMP AS localtimestamp,
       NOW() AS now
       
  -- Write a query that shows exactly how long ago each indicent was reported. Assume that the dataset is in Pacific Standard Time (UTC - 8).
SELECT 
  incidnt_num,
  cleaned_date,
  NOW() - cleaned_date AS how_long_ago,
  EXTRACT('year' FROM NOW()) - EXTRACT('year' FROM cleaned_date) AS years_ago
FROM tutorial.sf_crime_incidents_cleandate
LIMIT 10;

-- j. COALESCE
  -- used to put default values when reading datasets with nulls
SELECT incidnt_num,
       descript,
       COALESCE(descript, 'No Description') AS descript_with_default
FROM tutorial.sf_crime_incidents_cleandate
ORDER BY descript DESC;

