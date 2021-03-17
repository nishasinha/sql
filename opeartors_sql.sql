SELECT * FROM tutorial.billboard_top_100_year_end;

SELECT *
  FROM tutorial.billboard_top_100_year_end
 ORDER BY year DESC, year_rank;
 
-- Logical operators

-- 1. LIKE
  -- used to match rows where column matches a pattern, case sensitive 
  -- % = any characters, _ = one character only
  -- ILIKE to ignore case
  
  -- Write a query that returns all rows for which Ludacris was a member of the group.
SELECT * 
  FROM tutorial.billboard_top_100_year_end
  WHERE artist ILIKE 'Ludacris'
  
  -- Write a query that returns all rows for which the first artist listed in the group has a name that begins with "DJ".
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ILIKE 'DJ%'
  
-- 2. IN
  -- select the rows where the values for a column is in a given list.
  
  -- Write a query that shows all of the entries for Elvis and M.C. Hammer.
SELECT distinct "group", artist
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" LIKE '%Elvis%';
  
SELECT distinct "group", artist
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" LIKE '%Hammer%';
  
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" IN ('Elvis Presley', 'M.C. Hammer', 'Hammer');
  
-- 3. BETWEEN
  -- includes both ends in range
  -- Write a query that shows all top 100 songs from January 1, 1985 through December 31, 1990.
  
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year BETWEEN 1985 AND 1990;
  
-- 4. IS NULL
  -- rows where a column is null
  -- Write a query that shows all of the rows for which song_name is null.
  
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE song_name ISNULL;

-- 5. AND 
  -- to apply two or more conditions in one query
  
  -- Write a query that surfaces all rows for top-10 hits for which Ludacris is part of the Group.
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank <= 10
  AND artist ILIKE 'Ludacris';
  
  -- Write a query that surfaces the top-ranked records in 1990, 2000, and 2010.
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank = 1
  AND year in (1990, 2000, 2010);
  
  -- Write a query that lists all songs from the 1960s with "love" in the title.
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year >= 1960
  AND song_name ILIKE '%love%';
  
-- 6. OR
  -- to select rows with any of the given conditions satisfied.
  
  -- Write a query that returns all rows for top-10 songs that featured either Katy Perry or Bon Jovi.
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank <= 10
  AND (artist = 'Katy Perry' OR artist = 'Bon Jovi');
  
  -- Write a query that returns all songs with titles that contain the word "California" in either the 1970s or 1990s.
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE song_name LIKE '%California%'
  AND (year >= 1970 AND year < 1980) 
  OR (year >= 1990 AND year < 2000)
  
  -- Write a query that lists all top-100 recordings that feature Dr. Dre before 2001 or after 2009.
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE artist LIKE '%Dr. Dre%'
  AND (year < 2001 OR year > 2008);
  
-- 7. NOT
  -- to select rows that do not satisfy the given condition
  -- Write a query that returns all rows for songs that were on the charts in 2013 and do not contain the letter "a".
  
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2013
  AND song_name NOT ILIKE '%a%';
  
-- 8. ORDER BY
  -- sort the rows on a column value
  
  -- Write a query that returns all rows from 2012, ordered by song title from Z to A.
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year = 2012
  ORDER BY song_name
  
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank <= 3
 ORDER BY year DESC, year_rank;
 
SELECT *
  FROM tutorial.billboard_top_100_year_end
 WHERE year_rank <= 3
 ORDER BY year_rank, year DESC;
 
-- Write a query that shows all rows for which T-Pain was a group member, ordered by rank on the charts, from lowest to highest rank (from 100 to 1).
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE "group" ILIKE '%T-Pain%'
  ORDER BY year_rank DESC;
  
-- Write a query that returns songs that ranked between 10 and 20 (inclusive) in 1993, 2003, or 2013. 
-- Order the results by year and rank, and leave a comment on each line of the WHERE clause to indicate what that line does
SELECT *
  FROM tutorial.billboard_top_100_year_end
  WHERE year_rank BETWEEN 10 AND 20
  AND year in (1993, 2003, 2013)
  ORDER BY year, year_rank;
    