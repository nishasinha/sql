-- Advacned SQl tutorial

-- 14. Data types
  
-- SQL server data types
  -- STRING : CHAR(n), VARCHAR(n), TEXT, BINARY, VARBINARY, IMAGE
  -- INTEGER: BIT, TINYINT, SMALLINT, INT, BIGINT, FLOAT(p), DECIMAP(p,s), NUMERIC(p,s), MONEY, SMALLMONEY, REAL
  -- DATE/ TIME: DATE, DATETIME, DATETIME2, TIME, TIMESTAMP, DATETIMEOFFSET
  -- UNIQUEIDENTIFIER, XML
  
  -- Data can be casted to a type using the CAST operator
  -- Convert the funding_total_usd and founded_at_clean columns in the tutorial.crunchbase_companies_clean_date table to strings (varchar format) 
    -- using a different formatting function for each one.
    
SELECT CAST(funding_total_usd AS VARCHAR(20)), founded_at_clean::VARCHAR(10)
FROM tutorial.crunchbase_companies_clean_date;

-- 15. DATE Types
SELECT permalink,
       founded_at,
       founded_at_clean
FROM tutorial.crunchbase_companies_clean_date
ORDER BY founded_at_clean;

-- DATE, DATETIME, INTERVAL are data types for reprsenting dates.
-- DATE1 - DATE2 = INTERVAL, 
-- The interval is defined using plain-English terms like '10 seconds' or '5 months'

  -- Write a query that counts the number of companies acquired within 3 years, 5 years, and 10 years of being founded (in 3 separate columns). 
  -- Include a column for total companies acquired as well. Group by category and limit to only rows with a founding date.

SELECT * FROM tutorial.crunchbase_companies_clean_date;
SELECT * FROM tutorial.crunchbase_acquisitions_clean_date;

SELECT 
  companies.category_code,
  COUNT(CASE 
    WHEN acq.acquired_at_cleaned - companies.founded_at_clean::timestamp < '3 years' THEN 1 ELSE NULL END) 
  AS within_3_years,
  COUNT(CASE 
    WHEN acq.acquired_at_cleaned - companies.founded_at_clean::timestamp > '3 years' AND acq.acquired_at_cleaned - companies.founded_at_clean::timestamp < '5 years' 
    THEN 1 ELSE NULL END) 
  AS within_5_years,
  COUNT(CASE 
    WHEN acq.acquired_at_cleaned = companies.founded_at_clean::timestamp + INTERVAL '10 years' 
    THEN 1 ELSE NULL END) 
  AS within_10_years,
  COUNT(1) AS all_acquired_companies
FROM tutorial.crunchbase_companies_clean_date companies
JOIN tutorial.crunchbase_acquisitions_clean_date acq
ON companies.permalink = acq.company_permalink
AND founded_at_clean IS NOT NULL
GROUP BY companies.category_code;
