-- 17. Subqueries
  -- queries that are nested under some query.
  -- each subquery should be independent in execution.
  
  -- a. Nested subqueries under FROM clause
    -- they are like another table on which parent query works
    -- alias should be given
  
  -- Write a query that selects all Warrant Arrests from the tutorial.sf_crime_incidents_2014_01 dataset, 
    -- then wrap it in an outer query that only displays unresolved incidents.
SELECT descript, resolution
FROM tutorial.sf_crime_incidents_2014_01
WHERE descript = 'WARRANT ARREST'
AND resolution ILIKE 'None';

SELECT sub.incidnt_num, sub.descript, sub.resolution
FROM (
  SELECT * 
  FROM tutorial.sf_crime_incidents_2014_01
  WHERE descript = 'WARRANT ARREST'
) sub
WHERE sub.resolution = 'NONE';

  -- b: Nested subquery in FROM clause for multiple aggregates
  -- Write a query that displays the average number of monthly incidents for each category. 
    -- Hint: use tutorial.sf_crime_incidents_cleandate to make your life a little easier.
    -- Step 1: category 1 -> 12 months -> each month has incident count 
    -- Step 2: group by category, avg the incidnt count (this is avg on month)
    
SELECT 
  category,
  EXTRACT('month' FROM cleaned_date) AS month,
  COUNT(incidnt_num) AS incidnt_count
FROM tutorial.sf_crime_incidents_cleandate
GROUP BY category, month;


SELECT 
  sub.category,
  AVG(sub.incidnt_count) AS avg_inc_count
FROM (
  SELECT 
    category,
    EXTRACT('month' FROM cleaned_date) AS month,
    COUNT(incidnt_num) AS incidnt_count
  FROM tutorial.sf_crime_incidents_cleandate
  GROUP BY category, month;
) sub
GROUP BY category;

  -- c. Subquery in WHERE cluase
    -- WHERE x = (subquery) 
      -- subquery result in one value mostly, if multiple values, use 'IN' clause
    -- no alias to be given
SELECT *
FROM tutorial.sf_crime_incidents_2014_01
WHERE Date IN 
  (SELECT date FROM tutorial.sf_crime_incidents_2014_01 ORDER BY date LIMIT 5)
  
  
  -- d. Subquery in JOIN clause 
    -- as another table, using alias
    -- JOIN (subquery) alias
    
    -- Write a query that displays all rows from the three categories with the fewest incidents reported.
SELECT 
  category,
  COUNT(incidnt_num) AS incidnt_num_count
FROM tutorial.sf_crime_incidents_2014_01
GROUP BY category
ORDER BY incidnt_num_count
LIMIT 3;

SELECT inc.*
FROM tutorial.sf_crime_incidents_2014_01 inc
JOIN (
  SELECT 
    category,
    COUNT(incidnt_num) AS incidnt_num_count
  FROM tutorial.sf_crime_incidents_2014_01
  GROUP BY category
  ORDER BY incidnt_num_count
  LIMIT 3
) sub
ON inc.category = sub.category;

  -- Write a query that counts the number of companies founded and acquired by quarter starting in Q1 2012. 
    -- Create the aggregations in two separate queries, then join them.

SELECT 
  founded_quarter,
  COUNT(DISTINCT permalink) AS founded_count
FROM tutorial.crunchbase_companies
WHERE founded_year >= 2012
GROUP BY founded_quarter;


SELECT 
  acquired_quarter,
  COUNT(DISTINCT company_permalink) AS acquired_count
FROM tutorial.crunchbase_acquisitions
WHERE acquired_year >=  2012
GROUP BY acquired_quarter;

SELECT 
  COALESCE(companies.founded_quarter, acquisitions.acquired_quarter) AS quarter,
  companies.founded_count,
  acquisitions.acquired_count
FROM
  (SELECT 
    founded_quarter,
    COUNT(DISTINCT permalink) AS founded_count
  FROM tutorial.crunchbase_companies
  WHERE founded_year >= 2012
  GROUP BY founded_quarter
  ) AS companies
LEFT JOIN 
  (
  SELECT 
    acquired_quarter,
    COUNT(DISTINCT company_permalink) AS acquired_count
  FROM tutorial.crunchbase_acquisitions
  WHERE acquired_year >=  2012
  GROUP BY acquired_quarter
  ) AS acquisitions
ON companies.founded_quarter = acquisitions.acquired_quarter;
  
  
  -- e. Subquery with UNION clause
    -- when dataset is divided into parts, union them and then use them for aggregations on the whole dataset.
    
    -- Write a query that ranks investors from the combined dataset above by the total number of investments they have made.
SELECT 
  inv.investor_permalink,
  COUNT(*) AS investments_count
FROM 
(
  SELECT * FROM tutorial.crunchbase_investments_part1
  UNION ALL
  SELECT * FROM tutorial.crunchbase_investments_part2
) AS inv
GROUP BY inv.investor_permalink
ORDER BY investments_count DESC;

  -- Write a query that does the same thing as in the previous problem, except only for companies that are still operating. 
    -- Hint: operating status is in tutorial.crunchbase_companies.
SELECT * FROM tutorial.crunchbase_companies;

SELECT 
  inv.investor_permalink,
  COUNT(inv.*) AS investments_count
FROM tutorial.crunchbase_companies companies
JOIN (
  SELECT * FROM tutorial.crunchbase_investments_part1
  UNION ALL
  SELECT * FROM tutorial.crunchbase_investments_part2
) inv
ON companies.permalink = inv.company_permalink
WHERE companies.status = 'operating'
GROUP BY inv.investor_permalink
ORDER BY investments_count DESC;

