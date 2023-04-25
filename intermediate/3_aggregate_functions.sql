-- Intermediate SQL 
SELECT * 
FROM tutorial.aapl_historical_stock_price;


-- 6. Aggregate Functions
-- The logical operators (LIKE, ILIKE, OR, AND, IN, BETWEEN, ISNULL, NOT) work on one single row data across columns.
-- Aggregate functions (SUM, COUNT, MIN, MAX, AVG) work across rows, get value of a column from many rows to get results.

-- 6a. COUNT: count number of rows vertically, column can have any data type, nulls are not counted in.

  -- COUNT all rows in dataset
SELECT COUNT(*) 
FROM tutorial.aapl_historical_stock_price;

  -- Write a query to count the number of non-null rows in the low column. Column can be of any data type.
SELECT COUNT(low)
FROM tutorial.aapl_historical_stock_price;

SELECT COUNT(*)
FROM tutorial.aapl_historical_stock_price 
WHERE low IS NOT NULL

  -- Write a query that determines counts of every single column. Which column has the most null values?
SELECT  COUNT(*) AS row_count,
        COUNT(date) AS date_count,
        COUNT(year) as year_count, 
        COUNT(month) as month_count, 
        COUNT(open) as open_count, 
        COUNT(high) as high_count, 
        COUNT(low) as low_count,
        COUNT(close) as close_count, 
        COUNT(volume) as volume_count, 
        COUNT(id) as id_count
FROM tutorial.aapl_historical_stock_price;

-- 6b. SUM: to aggregate values of columns vertically, columns should be of number types, nulls are treated as 0.

 -- Write a query to calculate the average opening price (hint: you will need to use both COUNT and SUM, as well as some simple arithmetic.).
  -- avg opening price = this open price / sum(all open price)
SELECT SUM(open) / COUNT(open) as avg_opening_price
FROM tutorial.aapl_historical_stock_price;

-- 6c. MIN/MAX: from all the values of a column find min or max, column could be of non numerical data type too (min number, old date, letter close to A)

  -- What was Apple's lowest stock price (at the time of this data collection)?
SELECT MIN(low)
FROM tutorial.aapl_historical_stock_price;

  -- What was the highest single-day increase in Apple's share value?
SELECT MAX(close - open)
FROM tutorial.aapl_historical_stock_price;

-- 6d. AVG: to get (sum of all values / count of all values) for a column, 
  -- works only on numerical columns, ignores the rows in count where the column is null.
  
  -- Write a query that calculates the average daily trade volume for Apple stock.
SELECT AVG(volume) AS avg_volume
FROM tutorial.aapl_historical_stock_price;



-- 7. GROUP BY
  -- the aggregate functions group the results for all the rows.
  -- to aggregate across row groups use group by. It divides the dataset as groups and then SUM, MAx etc can be done for each group.
  -- columns can be grouped for many columns using comma separator, order of columns in group by have no affect.
  
  -- Calculate the total number of shares traded each month. Order your results chronologically.
SELECT month, SUM(volume) AS shares_for_month
FROM tutorial.aapl_historical_stock_price
GROUP BY month
ORDER BY month;
 
SELECT year,
       month,
       COUNT(*) AS count
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY month, year;

  -- LIMIT on group by cluase works after the aggregates are completed. So, results world be correct.
  -- Write a query to calculate the average daily price change in Apple stock, grouped by year.
SELECT year, AVG(close - open) as avg_daily_price_change
FROM tutorial.aapl_historical_stock_price
GROUP BY year
ORDER BY year;

  -- Write a query that calculates the lowest and highest prices that Apple stock achieved each month.
SELECT 
  year, 
  month, 
  MIN(low) AS lowest_price, 
  MAX(high) AS highest_price
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
ORDER BY year, month;



-- 8. HAVING: once the aggregate is done, and there are rows of result for each group, to filter on those rows, having is used.
  -- where clause cannot filter on aggregated columns, hence having needed.
  
  -- Find every month during which AAPL stock worked its way over $400/share. 
SELECT 
  year, 
  month,
  MAX (high) AS month_high
FROM tutorial.aapl_historical_stock_price
GROUP BY year, month
HAVING MAX(high) > 400
ORDER BY year, month;

  -- Clause order: SELECT -> FROM -> WHERE -> GROUP BY -> HAVING -> ORDER BY