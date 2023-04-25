-- Intermediate SQL
SELECT * FROM tutorial.aapl_historical_stock_price;
-- id, date, year, month, open, close, high, low, volume


-- 1. Aggregate Fuctions (Column wise)
-- The arithematic operators apply on data within a row.
-- The SQL aggregate functions apply on data in multiple rows, to aggreagte value.
-- EG: SUM, COUNT, MIN, MAX, AVG
-- ** WHERE clause and functions works on a row (Horizonatlly),
  -- aggregates works on group of rows (Vertically) **


-- 1a. COUNT
-- count(*) count all rows in table.
-- count(column_name) - count the rows with non null value in that column.
-- column can be of any data type.

-- Q. Write a query to count the number of non-null rows in the low column.
SELECT COUNT(low)
FROM tutorial.aapl_historical_stock_price;


-- Q. Write a query that determines counts of every single column.
-- With these counts, can you tell which column has the most null values?
SELECT
  COUNT(date) AS date_count,
  COUNT(year) AS year_count,
  COUNT(month) AS month_count,
  COUNT(open) AS open_count,
  COUNT(close) AS close_count,
  COUNT(high) AS high_count,
  COUNT(low) AS low_count,
  COUNT(volume) AS volume_count,
  COUNT(id) AS id_count
FROM tutorial.aapl_historical_stock_price;

SELECT
  COUNT(*) - COUNT(date) AS date_count_nulls,
  COUNT(*) - COUNT(year) AS year_count_nulls,
  COUNT(*) - COUNT(month) AS month_count_nulls,
  COUNT(*) - COUNT(open) AS open_count_nulls,
  COUNT(*) - COUNT(close) AS close_count_nulls,
  COUNT(*) - COUNT(high) AS high_count_nulls,
  COUNT(*) - COUNT(low) AS low_count_nulls,
  COUNT(*) - COUNT(volume) AS volume_count_nulls,
  COUNT(*) - COUNT(id) AS id_count_nulls
FROM tutorial.aapl_historical_stock_price;


-- 1b. SUM
-- sums a column across rows.
-- only on numerical data type.
-- considers null as 0.

-- Q. Write a query to calculate the average opening price
-- (hint: you will need to use both COUNT and SUM, as well as some simple arithmetic.).
SELECT
  AVG(open) AS avg_open
FROM tutorial.aapl_historical_stock_price;

SELECT
  SUM(open)/COUNT(open) AS avg_open
FROM tutorial.aapl_historical_stock_price;


-- 1.c MIN, MAX
-- MIN: select the min number, earliest date or string closest to A in column.
-- MAX: select the max number, latest date or string closest to Z in a column.

-- Q. What was Apple's lowest stock price (at the time of this data collection)?
SELECT MIN(low)
FROM tutorial.aapl_historical_stock_price;

-- Q. What was the highest single-day increase in Apple's share value?
SELECT
  MAX(close - open) AS highest_increase
FROM tutorial.aapl_historical_stock_price;


-- 1.d AVG
-- calculates the avg of column values.
-- on numerical data only.
-- IGNORES NULL, so in some scenarios, we may need to set nulls as 0.

-- Q. Write a query that calculates the average daily trade volume for Apple stock.
SELECT AVG(volume) AS avg_without_nulls
FROM tutorial.aapl_historical_stock_price;
-- 20745814.3454

SELECT SUM(volume)/COUNT(*) AS avg_with_nulls
FROM tutorial.aapl_historical_stock_price;
-- 20699128.9685



-- 2. GROUP BY
-- aggregate functions operate on a column value for the entire table.
-- GROUP BY allows to divide the table into parts vertically on Group By columns.
-- the aggreagte functions can then work on each part of the table.


-- Q. Calculate the total number of shares traded each month. Order your results chronologically.
SELECT month, SUM(volume)
FROM tutorial.aapl_historical_stock_price
GROUP BY month
ORDER BY month;


SELECT year, month, SUM(volume) AS total_shares
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month;

-- Aggregations are performed before LIMIT clause so results are always correct.
-- Q. Write a query to calculate the average daily price change in Apple stock, grouped by year.
SELECT year, AVG(close-open) AS avg_daily_price_change
FROM tutorial.aapl_historical_stock_price
GROUP BY year;

-- Write a query that calculates the lowest and highest prices that Apple stock achieved each month.
SELECT
  year,
  month,
  MAX(high) AS highest_price, MIN(low) AS lowest_price
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month;


-- 3. HAVING
-- when aggregations are done, the new columns are created.
-- if there is any filtering on the aggregated data, where clause cannot do it,
-- because the schema columns are not present.
-- HAVING is used to filter the aggregated columns.

-- Q. find every month during which AAPL stock high was greater than 400
SELECT
  year,
  month,
  MAX(high) AS month_high
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
HAVING MAX(high) > 400
ORDER BY year DESC, month DESC;

-- ** Query cluase order **
-- SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY.


-- 4. CASE
-- for if else logic, use case clause
-- always written inside the SELECT as a column
-- CASE WHEN (condition) THEN (value) ELSE (another value) END AS new_column_name
-- ELSE is optional
-- case adds a new column, and works on 1 row at a time, like arithematic operators.

SELECT * FROM benn.college_football_players;

-- Q. Write a query that includes a column that is flagged "yes"
-- when a player is from California, and sort the results with those players first.

SELECT
  state,
  CASE WHEN state = 'CA' THEN 'yes' ELSE NULL END AS "from_california"
FROM benn.college_football_players
ORDER BY from_california;


-- 4.a CASE with multiple cluases
-- There can be multiple WHEN AND THEN clauses,
-- which are evaluated one by one and break at first match.

-- Q. Write a query that includes players' names and
-- a column that classifies them into four categories based on height.
-- Keep in mind that the answer we provide is only one of many possible answers,
-- since you could divide players' heights in many ways.

SELECT
 height,
 CASE
  WHEN height > 75 THEN '> 75'
  WHEN height BETWEEN 50 AND 75 THEN '50-75'
  WHEN height BETWEEN 25 AND 50 THEN '25-50'
  ELSE '< 25'
 END AS "height_group"
FROM benn.college_football_players
ORDER BY height_group;
-- Remember single quotes for column values, double quotes for column names.


-- Q. Write a query that selects all columns from benn.college_football_players
-- and adds an additional column that displays the player's name if that player is a junior or senior.
SELECT
  player_name,
  year,
  CASE
    WHEN year IN ('JR', 'SR') THEN player_name
    ELSE NULL
    END AS jr_sr_player_name
FROM benn.college_football_players;


-- 4b. CASE with aggregate functions, count, sum, max, min, avg
-- Q. Count the number of players in each year group.
SELECT
  COUNT(year)
FROM benn.college_football_players
WHERE year = 'SO';

-- WHERE allows to filter and count on only one value.
SELECT DISTINCT(year) from benn.college_football_players;

SELECT
  year,
  COUNT(*)
FROM benn.college_football_players
GROUP BY year;

-- 4c. CASE to create categories
-- Q. Write a query that counts the number of 300lb+ players for each of the following regions:
-- West Coast (CA, OR, WA), Texas, and Other (everywhere else).
SELECT DISTINCT(state) from benn.college_football_players;
SELECT * FROM benn.college_football_players WHERE hometown ILIKE '%Texas%';

SELECT
  CASE
    WHEN state IN ('CA', 'OR', 'WA') THEN 'West Coast'
    WHEN state =  'TX' THEN 'Texas'
    ELSE 'Other'
  END AS region,
  count(*) AS player_count
FROM benn.college_football_players
WHERE weight > 300
GROUP BY region;


-- Q. Write a query that calculates the combined weight of all underclass players (FR/SO)
-- in California as well as the combined weight of all upperclass players (JR/SR) in California.
SELECT *
FROM benn.college_football_players
WHERE state = 'CA';

SELECT
  CASE
    WHEN (year = 'SO' OR year = 'FR') THEN 'underclass'
    WHEN (year = 'JR' OR year = 'SR') THEN 'upperclass'
    ELSE NULL
  END AS class,
  sum(weight) AS total_weight
FROM benn.college_football_players
WHERE state = 'CA'
GROUP BY class;


-- 4d. CASE for pivoting
-- Pivoting can also be done
SELECT
  COUNT(CASE WHEN year = 'SO' OR year = 'FR' THEN 1 ELSE NULL END) AS under_class_count,
  COUNT(CASE WHEN year = 'JR' OR year = 'SR' THEN 1 ELSE NULL END) AS upper_class_count
FROM benn.college_football_players;


-- Q. Write a query that displays the number of players in each state,
-- with FR, SO, JR, and SR players in separate columns and
-- another column for the total number of players.
-- Order results such that states with the most players come first.
SELECT *
FROM benn.college_football_players;

SELECT state, count(*)
FROM benn.college_football_players
GROUP BY state;

SELECT
  COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS "so_player_count",
  COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS "fr_player_count",
  COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS "jr_player_count",
  COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS "sr_player_count",
  COUNT(*) AS "total_player_count"
FROM benn.college_football_players;

SELECT
  state,
  COUNT(CASE WHEN year = 'SO' THEN 1 ELSE NULL END) AS "so_player_count",
  COUNT(CASE WHEN year = 'FR' THEN 1 ELSE NULL END) AS "fr_player_count",
  COUNT(CASE WHEN year = 'JR' THEN 1 ELSE NULL END) AS "jr_player_count",
  COUNT(CASE WHEN year = 'SR' THEN 1 ELSE NULL END) AS "sr_player_count",
  COUNT(*) AS "total_player_count"
FROM benn.college_football_players
GROUP BY state
ORDER BY total_player_count DESC;

-- Q. Write a query that shows the number of players at schools
-- with names that start with A through M, and
-- the number at schools with names starting with N - Z.

SELECT COUNT(*)
FROM benn.college_football_players
WHERE player_name < 'N'; --names that start with A through M

SELECT COUNT(*)
FROM benn.college_football_players
WHERE player_name >= 'N'; --names starting with N - Z.

SELECT
  COUNT(CASE WHEN player_name < 'N' THEN 1 ELSE NULL END) AS count_a_to_m,
  COUNT(CASE WHEN player_name >= 'N' THEN 1 ELSE NULL END) AS count_n_to_z
FROM benn.college_football_players;



-- 5. DISTINCT
-- to collect unique values in a column, use DISTINCT in SELECT
-- when done on many columns, collects unique value pairs or triplets.

-- Q. Write a query that returns the unique values in the year column, in chronological order.
SELECT *
FROM tutorial.aapl_historical_stock_price;

SELECT DISTINCT(year) AS years
FROM tutorial.aapl_historical_stock_price
ORDER BY years;


-- DISTINCT can be used inside aggregations.
-- eg: SUM(DISTINCT column)

-- Q. Write a query that counts the number of unique values in the month column for each year.
SELECT
  year,
  COUNT(DISTINCT month) AS distinct_months
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year;

-- Q. Write a query that separately counts the number of unique values in the month column
-- and the number of unique values in the `year` column.
SELECT
  COUNT(DISTINCT month) AS distinct_month,
  COUNT(DISTINCT year) AS distinct_year
FROM tutorial.aapl_historical_stock_price;



-- 5. JOINS
-- In RDBMS, there are multiple tables which are related to each other based on common colums.
-- JOINS is a mechanism to collect data from two tables together and perform operations.
-- Joins of column incraeses the number columns in the joined output,
-- the number of rows may increase or decrease based on join condition.


-- Q. Write a query that selects the
-- school name, player name, position, and weight for every player in Georgia,
-- ordered by weight (heaviest to lightest).
-- Be sure to make an alias for the table, and to reference all column names in relation to the alias.


SELECT * FROM benn.college_football_players;
-- full_school_name,, height, hometown, id, player_name, position,
-- school_name, state, weight, year
SELECT * FROM benn.college_football_teams;
-- conference, division, id, roaster url, school_name


SELECT
  players.school_name, players.player_name, players.position, players.weight
FROM benn.college_football_players players
WHERE players.state = 'GA'
ORDER BY players.weight DESC;


-- JOIN adds duplicate columns in the result.
SELECT *
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name;

-- Instead of SELECT *, we may SELECt only the required columns from each table using the alias.


-- 5a. INNER JOIN or JOIN
-- to seelect the rows in the final where the join condition is true in both the lefta nd the right table.

SELECT players.*,
       teams.*
  FROM benn.college_football_players players
  JOIN benn.college_football_teams teams
    ON teams.school_name = players.school_name;

-- school_name_duplicate_column_1 and school_name are two columns
-- since the column name in the joined table has to be unique


-- Q. Write a query that displays player names, school names and conferences for schools
-- in the "FBS (Division I-A Teams)" division.

SELECT * FROM benn.college_football_players;
-- full_school_name,, height, hometown, id, player_name, position,
-- school_name, state, weight, year
SELECT * FROM benn.college_football_teams;
-- conference, division, id, roaster url, school_name



SELECT
  players.player_name, players.school_name, teams.conference
FROM
  benn.college_football_players players
JOIN
  benn.college_football_teams teams
ON players.school_name = teams.school_name
WHERE teams.division = 'FBS (Division I-A Teams)';



-- INNER JOIN
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;


-- LEFT JOIN
-- LEFT JOIN command tells the database to return all rows in the table in the FROM clause,
-- regardless of whether or not they have matches in the table in the LEFT JOIN clause.
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink;


-- Q. Write a query that performs an inner join between the
-- tutorial.crunchbase_acquisitions table and the tutorial.crunchbase_companies table,
-- but instead of listing individual rows, count the number of non-null rows in each table.
SELECT
  COUNT(companies.permalink) AS companies_non_null_row_count,
  COUNT(acquisitions.company_permalink) AS acquisitions_non_null_row_count
FROM tutorial.crunchbase_companies companies
JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink;
-- companies_non_null_row_count = acquisitions_non_null_row_count,
-- since inner join selects the rows which have join keys in both tables.



-- Q. Modify the query above to be a LEFT JOIN. Note the difference in results.
SELECT
  COUNT(companies.permalink) AS companies_non_null_row_count,
  COUNT(acquisitions.company_permalink) AS acquisitions_non_null_row_count
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink;
-- companies_non_null_row_count > acquisitions_non_null_row_count
-- since left join selects all rows of left tables which match or dont match.


-- Q. Count the number of unique companies (don't double-count companies)
-- and unique acquired companies by state.
-- Do not include results for which there is no state data,
-- and order by the number of acquired companies from highest to lowest.

SELECT * FROM tutorial.crunchbase_acquisitions;
SELECT * FROM tutorial.crunchbase_companies;


SELECT
-- companies.permalink, companies.state_code, acquisitions.company_permalink
  COUNT(DISTINCT companies.permalink) AS unique_companies,
  COUNT(DISTINCT acquisitions.company_permalink) AS unique_acquired_companies,
  companies.state_code
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
WHERE companies.state_code IS NOT NULL
GROUP BY companies.state_code
ORDER BY unique_acquired_companies DESC;


-- RIGHT JOIN
-- Similar to left joins except they return all rows from the table in the RIGHT JOIN clause
-- and only matching rows from the table in the FROM clause.

-- Q. Rewrite the previous practice query in which you counted total and acquired companies by state,
-- but with a RIGHT JOIN instead of a LEFT JOIN. The goal is to produce the exact same results.
SELECT
  -- companies.state_code, companies.permalink, acquisitions.company_permalink
  companies.state_code,
  COUNT(DISTINCT companies.permalink) AS unique_companies,
  COUNT(DISTINCT acquisitions.company_permalink) AS unique_acquired_companies
FROM tutorial.crunchbase_acquisitions acquisitions
RIGHT JOIN tutorial.crunchbase_companies companies
ON acquisitions.company_permalink = companies.permalink
WHERE companies.state_code IS NOT NULL
GROUP BY companies.state_code
ORDER BY unique_acquired_companies DESC;


-- The WHERE clause filter can be applied before or after the join process.
-- It is good to do it before joining the table so that join works on less dataset. Eg:
SELECT companies.permalink AS companies_permalink,
       companies.name AS companies_name,
       acquisitions.company_permalink AS acquisitions_permalink,
       acquisitions.acquired_at AS acquired_date
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
    ON companies.permalink = acquisitions.company_permalink
 WHERE acquisitions.company_permalink != '/company/1000memories'
    OR acquisitions.company_permalink IS NULL
 ORDER BY 1;


-- Q. Write a query that shows a company's name,
-- "status" (found in the Companies table), and the number of unique investors in that company.
-- Order by the number of investors from most to fewest.
-- Limit to only companies in the state of New York.

SELECT * FROM tutorial.crunchbase_investments;

SELECT
  companies.name AS company_name,
  companies.status AS company_status,
  COUNT(DISTINCT investments.investor_name) AS unique_investor_count
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments investments
ON companies.permalink = investments.company_permalink
WHERE companies.state_code = 'NY'
GROUP BY companies.name,companies.status
ORDER BY unique_investor_count DESC;


SELECT companies.name AS company_name,
       companies.status,
       COUNT(DISTINCT investments.investor_name) AS unqiue_investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
 WHERE companies.state_code = 'NY'
 GROUP BY 1,2
 ORDER BY 3 DESC

-- Q. Write a query that lists investors based on the number of companies in which they are invested.
-- Include a row for companies with no investor, and order from most companies to least.
SELECT
  CASE
    WHEN investments.investor_name IS NULL THEN 'No Investor'
    ELSE investments.investor_name
  END AS investor_name,
  COUNT(DISTINCT companies.permalink) AS companies_invested_in
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments investments
ON companies.permalink = investments.company_permalink
GROUP BY investor_name
ORDER BY companies_invested_in DESC;

SELECT CASE WHEN investments.investor_name IS NULL THEN 'No Investors'
            ELSE investments.investor_name END AS investor,
       COUNT(DISTINCT companies.permalink) AS companies_invested_in
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments investments
    ON companies.permalink = investments.company_permalink
 GROUP BY 1
 ORDER BY 2 DESC;


-- FULL JOIN
-- Returns cross join of all rows in first table with all rows in second table
-- so, 5 rows, 3 rows, result will have 15 rows.
SELECT COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NULL
                THEN companies.permalink ELSE NULL END) AS companies_only,
     COUNT(CASE WHEN companies.permalink IS NOT NULL AND acquisitions.company_permalink IS NOT NULL
                THEN companies.permalink ELSE NULL END) AS both_tables,
     COUNT(CASE WHEN companies.permalink IS NULL AND acquisitions.company_permalink IS NOT NULL
                THEN acquisitions.company_permalink ELSE NULL END) AS acquisitions_only
FROM tutorial.crunchbase_companies companies
FULL JOIN tutorial.crunchbase_acquisitions acquisitions
  ON companies.permalink = acquisitions.company_permalink;

-- Q. Write a query that joins tutorial.crunchbase_companies and tutorial.crunchbase_investments_part1
-- using a FULL JOIN. Count up the number of rows that are matched/unmatched as in the example above.

SELECT
  COUNT(CASE WHEN companies.permalink is NOT NULL AND investments.company_permalink is NULL
    THEN companies.permalink ELSE NULL END) AS comapnies_only,
  COUNT(CASE WHEN companies.permalink is NULL AND investments.company_permalink is NOT NULL
    THEN investments.company_permalink ELSE NULL END) AS investments_only,
  COUNT(CASE WHEN companies.permalink is NOT NULL AND investments.company_permalink is NOT NULL
    THEN companies.permalink ELSE NULL END) AS both
FROM tutorial.crunchbase_companies companies
FULL JOIN tutorial.crunchbase_investments_part1 investments
ON companies.permalink = investments.company_permalink;



-- 6. UNION
-- JOINS allows to combine two tables horizontally, the number of columns increases.
-- But UNION allows to stack the two tables on each other vertically.
-- Result of UNION would have same number of columns as in parent tables and row count would grow.

-- Both tables should have the same number of columns, the columns must be in same sequence and data types.
-- Column names may differ.

-- UNION: will drop the duplicate rows from the second table.
-- UNION ALL: would keep the duplicate rows also.
-- Each table in UNION is independent and have SQL functions on them separately.


-- Q. Write a query that appends the two crunchbase_investments datasets above (including duplicate values).
-- Filter the first dataset to only companies with names that start with the letter "T",
-- and filter the second to companies with names starting with "M" (both not case-sensitive).
-- Only include the company_permalink, company_name, and investor_name columns.


SELECT
  part1.company_permalink, part1.company_name, part1.investor_name
FROM tutorial.crunchbase_investments_part1 part1

UNION ALL

SELECT
  part2.company_permalink, part2.company_name, part2.investor_name
FROM tutorial.crunchbase_investments_part2 part2;

-- Q. Write a query that shows 3 columns.
-- The first indicates which dataset (part 1 or 2) the data comes from,
-- the second shows company status, and the third is a count of the number of investors.
-- Hint: you will have to use the tutorial.crunchbase_companies table as well as the investments tables.
-- And you'll want to group by status and dataset.

SELECT * FROM tutorial.crunchbase_investments_part1;
SELECT * FROM tutorial.crunchbase_companies;


SELECT
  'investments_part1' AS dataset_name,
  companies.status AS company_status,
  COUNT(DISTINCT investments.investor_permalink) AS investor_count
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments_part1 investments
ON companies.permalink = investments.company_permalink
GROUP BY dataset_name,company_status

UNION ALL

SELECT
  'investments_part2' AS dataset_name,
  companies.status AS company_status,
  COUNT(DISTINCT investments.investor_permalink) AS investor_count
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_investments_part1 investments
ON companies.permalink = investments.company_permalink
GROUP BY dataset_name,company_status;


-- 7. JOINS can also be done on multiple conditions and use >, >=, != etc. Eg:

-- JOIN only investments that occurred more than 5 years after each company's founding year
SELECT companies.permalink,
       companies.name,
       companies.status,
       COUNT(investments.investor_permalink) AS investors
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
   AND investments.funded_year > companies.founded_year + 5
 GROUP BY 1,2, 3

-- 8. Joining on multiple keys
-- to make query fast and sometimes there is need.

SELECT companies.permalink,
       companies.name,
       investments.company_name,
       investments.company_permalink
  FROM tutorial.crunchbase_companies companies
  LEFT JOIN tutorial.crunchbase_investments_part1 investments
    ON companies.permalink = investments.company_permalink
   AND companies.name = investments.company_name;
-- last line just makes query faster.


-- 9. SELF JOIN tables
-- Identify companies that received an investment from Great Britain following an investment from Japan.
SELECT DISTINCT japan_investments.company_name,
	   japan_investments.company_permalink
  FROM tutorial.crunchbase_investments_part1 japan_investments
  JOIN tutorial.crunchbase_investments_part1 gb_investments
    ON japan_investments.company_name = gb_investments.company_name
   AND gb_investments.investor_country_code = 'GBR'
   AND gb_investments.funded_at > japan_investments.funded_at
 WHERE japan_investments.investor_country_code = 'JPN'
 ORDER BY 1
