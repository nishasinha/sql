

-- 3. String Wrangling 
SELECT *
  FROM tutorial.sf_crime_incidents_2014_01;
  
  -- To clean the strings, there are some functions like: LEFT, LENGTH, TRIM etc
  -- the functions are operated as column values in select clause.

-- a. SUBSTRING
  -- LEFT, RIGHT, LENGTH
SELECT 
  incident_num,
  date,
  LEFT(date, 10) AS cleaned_date,   -- returns 10 characters from left of date
  RIGHT(date, LENGTH(date - 11)) AS cleaned_time -- returns LENGTH(date) - 11 characters from right of string
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


-- d.CONCAT
SELECT
  CONCAT(first_name, '-', last_name),
  first_name || '-' || last_name
FROM profiles;



  

  -- Concatenate the lat and lon fields to form a field that is equivalent to the location field. 
  -- (Note that the answer will have a different decimal precision.)







