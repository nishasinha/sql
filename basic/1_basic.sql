-- SQL tutorial 

-- 1. convention 
  -- table ames, column names are lowercase with underscores
  -- space and case does not matter
  -- use uppercase for keywords
  
SELECT *
  FROM tutorial.us_housing_units;

SELECT west as West_Region, west as "West Region" 
  FROM tutorial.us_housing_units LIMIT 10;
  
-- 2. WHERE clause
-- WHERE 
  -- used to filter the query results
  -- one row is considered one data point and always selected or not selected, nothing in between happens.
  
-- Comparison on numbers: =, <> or !=, <, <=, >, >=
  -- Did the West Region ever produce more than 50,000 housing units in one month?
SELECT *
  FROM tutorial.us_housing_units 
  WHERE west > 50;
  
  -- Did the South Region ever produce 20,000 or fewer housing units in one month?
SELECT *
  FROM tutorial.us_housing_units 
  WHERE south <= 20;
  
-- Comparison on alphabets: 
  -- dictionary order is followed, that is Ja > J, so when > "J" is in query, 
  -- it takes all rows, with column value starting with J or bigger

  -- Write a query that only shows rows for which the month name is February.
SELECT * 
  FROM tutorial.us_housing_units
  WHERE month_name = 'February';
  
  -- Write a query that only shows rows for which the month_name starts with the letter "N" or an earlier letter in the alphabet.
SELECT * 
  FROM tutorial.us_housing_units
  WHERE month_name < 'N';
  
-- 3. Computation can be done on column values in a row. To do computation on column values across rows, use the aggregate functions.
  -- Write a query that returns all rows for which more units were produced in the West region than in the Midwest and Northeast combined. 
SELECT west, (midwest + northeast) AS midwest_northeast, (west > midwest + northeast) AS west_bigger
  FROM tutorial.us_housing_units
  WHERE west > (midwest + northeast);
  
-- Write a query that calculates the percentage of all houses completed in the United States represented by each region. 
-- Only return results from the year 2000 and later.
SELECT *
  FROM tutorial.us_housing_units
  WHERE year >= 2000;
  
SELECT year, month, 
  (south/ south+west+midwest+northeast) * 100 AS south_pct,
  (west/ south+west+midwest+northeast) * 100 AS west_pct,
  (midwest/ south+west+midwest+northeast) * 100 AS midwest_pct,
  (northeast/ south+west+midwest+northeast) * 100 AS northeast_pct
  FROM tutorial.us_housing_units
  WHERE year >= 2000;