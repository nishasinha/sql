-- 
SELECT * FROM benn.college_football_players;

-- 9. CASE:  to do if/else logic
  -- CASE 
    -- WHEN <condition on a column value for that row> THEN <value> 
    -- ELSE <else value> END AS <case_result_column_name>
    
  -- CASE is always written in the SELECT statement
  -- CASE, WHEN, THEN, END, ELSE
    
  -- Write a query that includes a column that is flagged "yes" when a player is from California, and sort the results with those players first.
SELECT * 
FROM benn.college_football_players 
WHERE state = 'CA';

SELECT
  player_name,
  state,
  CASE 
    WHEN state = 'CA' THEN 'yes' 
    ELSE NULL 
  END AS "from_california"
FROM benn.college_football_players
ORDER BY from_california;

-- Write a query that includes players' names and a column that classifies them into four categories based on height.
  -- Keep in mind that the answer we provide is only one of many possible answers, since you could divide players' heights in many ways.
  
SELECT MIN(height), MAX(height), AVG(height), COUNT(height) 
FROM  benn.college_football_players;

-- heights (<70, 70-75, 76-80, >80)
SELECT 
  player_name,
  height,
  CASE 
    WHEN height < 70 THEN '<70'
    WHEN height > 70 AND height <= 75 THEN '70-75'
    WHEN height > 75 AND height <= 80 THEN '75-80'
    WHEN height > 80 THEN '>80'
    ELSE 'bad_height_value' 
  END AS height_category
FROM benn.college_football_players;

  -- Write a query that selects all columns from benn.college_football_players 
  -- and adds an additional column that displays the player's name if that player is a junior or senior.
SELECT *, 
  CASE 
    WHEN year = 'JR' OR year = 'SR' THEN player_name 
  END AS player_jr_or_sr
FROM benn.college_football_players;

  -- * CASE + aggregate functions
    -- make categories of data, add category column to each row via multiple cases,
    -- group by the category column to make category' row groups,
    -- apply aggregation on each category.
    
  -- Write a query that counts the number of 300lb+ players for each of the following regions: West Coast (CA, OR, WA), Texas, and Other (Everywhere else).
  
SELECT * FROM benn.college_football_players WHERE state ILIKE '%TX%';

SELECT 
  CASE 
    WHEN state IN ('CA', 'OR', 'WA') THEN 'West Coast'
    WHEN state = 'TX' THEN 'Texas'
    ELSE 'Other'
  END AS region,
  COUNT(*) AS player_in_the_region
FROM benn.college_football_players
WHERE weight > 300
GROUP BY region; -- 1303 + 155 + 164

SELECT COUNT(*) AS count
FROM benn.college_football_players 
WHERE weight > 300; -- 1622


  -- Write a query that calculates the combined weight of all underclass players (FR/SO) in California 
  -- as well as the combined weight of all upperclass players (JR/SR) in California.
  
SELECT
  CASE 
    WHEN year IN ('FR', 'SO') THEN 'underclass'
    WHEN year IN ('JR', 'SR') THEN 'upperclass'
    ELSE NULL
  END AS class_group,
  SUM(weight) as weight_sum_in_class
FROM benn.college_football_players
WHERE state = 'CA'
GROUP BY class_group;
  
  -- Pivoting: 
    -- til now the aggregations were done on categories, aggregation done on each category, result displayed in vertical rows.
    -- showing al aggregate results in ine row for each category is called Pivoting.
    -- achieved by CASE inside aggregate
    
SELECT CASE WHEN year = 'FR' THEN 'FR'
            WHEN year = 'SO' THEN 'SO'
            WHEN year = 'JR' THEN 'JR'
            WHEN year = 'SR' THEN 'SR'
            ELSE 'No Year Data' END AS year_group,
            COUNT(1) AS count
  FROM benn.college_football_players
 GROUP BY year_group;
 
SELECT COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
       COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
       COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
       COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count
  FROM benn.college_football_players
  
  -- Write a query that displays the number of players in each state, 
  -- with FR, SO, JR, and SR players in separate columns and 
  -- another column for the total number of players. Order results such that states with the most players come first.

SELECT 
  state,
  COUNT(*) AS total_players_in_state,
  COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS fr_count,
  COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS so_count,
  COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS jr_count,
  COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS sr_count
FROM benn.college_football_players
GROUP BY state
ORDER BY total_players_in_state DESC;

  -- Write a query that shows the number of players at schools with names that start with A through M, 
  -- and the number at schools with names starting with N - Z.

SELECT 
  COUNT(CASE WHEN school_name ILIKE 'A%' OR school_name ILIKE 'M%' THEN 1 ELSE NULL END) AS a_through_m_count,
  COUNT(CASE WHEN school_name ILIKE 'N%' OR school_name ILIKE 'Z%' THEN 1 ELSE NULL END) AS n_through_z_count
FROM benn.college_football_players;



SELECT * 
FROM tutorial.aapl_historical_stock_price;

-- 10. DISTINCT
  -- distinct values for a column
  -- distinct combination for given columns 
  
  -- Write a query that returns the unique values in the year column, in chronological order.

SELECT DISTINCT year 
FROM tutorial.aapl_historical_stock_price
ORDER BY year;

SELECT DISTINCT year, month
FROM tutorial.aapl_historical_stock_price
ORDER BY year, month;

  -- DISTINCT + aggregations: SUM/AVG/COUNT(DISTINCT col_name)
SELECT COUNT(DISTINCT month) AS unique_months
  FROM tutorial.aapl_historical_stock_price;
  
  -- Write a query that counts the number of unique values in the month column for each year.
SELECT
  year,
  COUNT(DISTINCT month) as distinct_months_count
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year;

  -- Write a query that separately counts the number of unique values in the month column and the number of unique values in the `year` column.
SELECT
  COUNT(DISTINCT month) AS distinct_month_count,
  COUNT(DISTINCT year) AS distinct_year_count
FROM tutorial.aapl_historical_stock_price;

