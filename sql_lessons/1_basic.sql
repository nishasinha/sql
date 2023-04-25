/*
Topics:
1. SELECT, FROM
2. WHERE
3. Aggregate the column values across a row via: (+, -, *, /)
4. Apply logical operators to enrich filter in WHERE clause
LIKE, ILIKE, IN, BETWEEN, AND, OR, NOT, IS NULL
5. ORDER BY and DESC


*/
-- 1. SELECT and FROM commands
SELECT
  *
FROM tutorial.us_housing_units;

SELECT
  year, month, month_name, south, west, midwest, northeast
FROM tutorial.us_housing_units;

-- The column names are not capitalized
SELECT west AS West_Region,
       south AS South_Region
FROM tutorial.us_housing_units;


-- Q: Write a query to select all of the columns in tutorial.us_housing_units
-- and rename them so that their first letters are capitalized.
SELECT
  year AS "Year",
  month AS "Month",
  month_name AS "Month name",
  south AS "South",
  west AS "West",
  midwest AS "Mid west",
  northeast AS "Noth east"
FROM tutorial.us_housing_units;

-- Q.Write a query that uses the LIMIT command to restrict the result set to only 15 rows.
SELECT *
FROM tutorial.us_housing_units
LIMIT 15;




-- 2. WHERE
-- to filter the rows from the table data, one row is one data point and it will be either selected or not selected.
-- comparison operators: =, !=, >, <, >=, <=

-- Q. Did the West Region ever produce more than 50,000 housing units in one month?
SELECT *
FROM tutorial.us_housing_units
WHERE west > 50;

-- Q. Did the South Region ever produce 20,000 or fewer housing units in one month?
SELECT *
FROM tutorial.us_housing_units
WHERE south <= 20;

-- comparison operators also work on non numeric columns, it compares alphabetically then
-- Ja > J, dictionary order is followed in comparison where Ja will come after J.
-- column value will alwys be in single quotes ('')

-- Q. Write a query that only shows rows for which the month name is February.
SELECT *
FROM tutorial.us_housing_units
WHERE month_name = 'February';

-- Q. Write a query that only shows rows for which
-- the month_name starts with the letter "N" or an earlier letter in the alphabet.
SELECT DISTINCT(month_name)
FROM tutorial.us_housing_units
WHERE month_name < 'O';


-- 3. Row wise Aggregates allows using running +, -, *, / operation on columns.
-- These can be done on one row data only.
-- The new columns are created by running some function on existing columns in the row,
-- the new column is called Dervied Column.

-- Q. Write a query that calculates the sum of all four regions in a separate column.
SELECT
  *,
  south + west + midwest + northeast AS "sum_of_all_regions"
FROM tutorial.us_housing_units;

-- Q. Write a query that returns all rows for which
-- more units were produced in the West region than in the Midwest and Northeast combined.

SELECT
  west,
  midwest,
  northeast
FROM tutorial.us_housing_units
WHERE west > (midwest + northeast);

-- Column alias could not be used in other column calculations and in where clause!
SELECT
  west,
  (midwest + northeast) AS "midwest_plus_northeast",
  west > (midwest + northeast) AS "result"
FROM tutorial.us_housing_units
WHERE west > (midwest + northeast);

-- Q. Write a query that calculates the percentage of all houses completed in the United States
-- represented by each region. Only return results from the year 2000 and later.

SELECT
  west + south + midwest + northeast AS "all",
  (west * 100) / (west + south + midwest + northeast) AS "west_percentage",
  (south * 100) / (west + south + midwest + northeast) AS "south_percentage",
  (midwest * 100) / (west + south + midwest + northeast) AS "midwest_percentage",
  (northeast * 100) / (west + south + midwest + northeast) AS "northeast_percentage"
FROM tutorial.us_housing_units
WHERE year >= 2000;




-- 4. Logical operators
-- allow running filters of WHERE clause on multiple conditions.
-- LIKE, IN, ISNULL, BETWEEN, AND, OR, NOT

-- LIKE = values matching a pattern, ILIKE to ignore case.
-- IN = values in a list
-- ISNULL = values where a column value is null
-- BETWEEN = values between a range. Both ends are included in result range.
-- AND = values satisfy two conditions
-- OR = values satisfy either one condition
-- NOT = values does not satisfy the condition

SELECT * FROM tutorial.billboard_top_100_year_end;

SELECT *
  FROM tutorial.billboard_top_100_year_end
 ORDER BY year DESC, year_rank;

-- 4.a LIKE
-- LIKE: similar values, not exact
-- ILIKE, ignore case in LIKE.
-- '%'' is wildcard for 1 or many characters.
-- '_' is wildcard for 1 character.

SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE "group" LIKE 'Snoop%'
-- Group is a keyword, so use double quotes to indicate the column name.
-- Putting double quotes around a word makes it column name.
-- Putting single column around a word makes it column value.
  -- All non numerical values are always written inside single quotes.


-- Q. Write a query that returns all rows for which Ludacris was a member of the group.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group" ILIKE '%ludacris%';

-- Q. Write a query that returns all rows for which the first artist listed in the group
-- has a name that begins with "DJ".
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group" LIKE 'DJ%';

-- Q. Write a query that shows all of the entries for Elvis and M.C. Hammer.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group" ILIKE '%Elvis%' OR "group" ILIKE '%Hammer%';


-- 4.b IN allows list of values to compare for.
-- Q. Write a query to get rank 1, 3, 5 songs of all years;
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank IN (1,3,5);


-- 4.c BETWEEN takes the range with start and end included.
-- Q. Write a query that shows all top 100 songs from January 1, 1985 through December 31, 1990.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year BETWEEN 1985 AND 1990;


-- 4.d ISNULL to get rwos with a column value as null or no value.
-- Q. Write a query that shows all of the rows for which song_name is null.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name IS NULL;

SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name ISNULL;

-- Arithematic on NULL is not allowed. Bad query :-
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name = NULL;


-- 4.e AND for multiple conditions to be true.
-- Q. Write a query that surfaces all rows for top-10 hits for which Ludacris is part of the Group.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank <= 10 AND "group" ILIKE '%ludacris%';

-- Q. Write a query that surfaces the top-ranked records in 1990, 2000, and 2010.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank = 1 AND year IN (1990, 2000, 2010);

-- Q. Write a query that lists all songs from the 1960s with "love" in the title.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 1960 AND song_name ILIKE '%love%';

-- 4.f OR is used to statify either condition or all conditions.
-- Q. Write a query that returns all rows for top-10 songs that featured either Katy Perry or Bon Jovi.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank <= 10 AND ("group" ILIKE '%katy Perry%' OR "group" ILIKE '%Bon Jovi%');

-- Q. Write a query that returns all songs with titles
-- that contain the word "California" in either the 1970s or 1990s.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE song_name LIKE '%California%' AND
  (year BETWEEN 1970 AND 1979 OR year BETWEEN 1990 AND 1999);

-- Q. Write a query that lists all top-100 recordings that feature Dr. Dre before 2001 or after 2009.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year_rank <= 100 AND
  "group" ILIKE '%Dr. Dre%' AND
  (year < 2001 OR year > 2009);


-- 4.g NOT to collect the rows where condition is false.
-- generally used with LIKE,

-- Q. Write a query that returns all rows for songs that were on the charts in 2013
-- and do not contain the letter "a".
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2013 AND
  song_name NOT ILIKE '%a%';



-- 5. ORDER BY to sort the rows by column values.
-- default is ascending order of the column values like 1,2,3 or a,b,c...
-- To sort in descending order use DESC.

-- Q. Write a query that returns all rows from 2012, ordered by song title from Z to A.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2012
ORDER BY song_name DESC;

-- OODER BY on multiple columns creates categories for one column and then sort for next column within each categroy.
-- ORDER and LIMIT both in query
  -- will run ORDER first, sort the rows and then apply LIMIT to select the limioted values as output.

-- Q. Write a query that returns all rows from 2010 ordered by rank,
-- with artists ordered alphabetically for each song.
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE year = 2010
ORDER BY year_rank, artist;


-- Q. Write a query that shows all rows for which T-Pain was a group member,
-- ordered by rank on the charts, from lowest to highest rank (from 100 to 1).
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE "group" ILIKE '%T-Pain%'
ORDER BY year_rank DESC;


-- Q. Write a query that returns songs that
-- ranked between 10 and 20 (inclusive) in 1993, 2003, or 2013.
-- Order the results by year and rank, and
-- leave a comment on each line of the WHERE clause to indicate what that line does
SELECT *
FROM tutorial.billboard_top_100_year_end
WHERE
  -- year rank between 10 to 20
  (year_rank BETWEEN 10 AND 20) AND
  -- year in (1993, 2003, 2013)
  year IN (1993, 2003, 2013)
ORDER BY year, year_rank;