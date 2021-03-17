-- 11. Joins: Till now, we worked on one table, but the query results may come from more than one table.
  -- joins are used to combine results from many tables.
  -- to alias a table put space and <alias>
  
SELECT * 
FROM benn.college_football_players;

SELECT * 
FROM benn.college_football_teams;

  -- Write a query that selects the school name, player name, position, and weight for every player in Georgia, 
    -- ordered by weight (heaviest to lightest). 
    -- Be sure to make an alias for the table, and to reference all column names in relation to the alias.
SELECT * 
FROM  benn.college_football_players 
WHERE school_name = 'Georgia';

SELECT 
  players.school_name,
  players.player_name,
  players.position,
  players.weight
FROM  benn.college_football_players players
WHERE school_name = 'Georgia'
ORDER BY players.weight DESC;


-- 11a. 
  -- INNER JOIN: JOIN or INNER JOIN keyword
  -- interestion of rows which match the join condition from both tables.
  
  -- which conference has the highest average weight.?
SELECT * FROM benn.college_football_players ;
SELECT * FROM benn.college_football_teams;

SELECT 
  teams.conference,
  AVG(players.weight) AS avg_player_weight
FROM  benn.college_football_players players
JOIN benn.college_football_teams teams
ON players.school_name = teams.school_name
GROUP BY teams.conference
ORDER BY avg_player_weight;

  -- Write a query that displays player names, school names and conferences for schools in the "FBS (Division I-A Teams)" division.
SELECT 
  players.player_name,
  players.school_name,
  teams.conference,
  teams.division
FROM  benn.college_football_players players
JOIN benn.college_football_teams teams
ON players.school_name = teams.school_name
WHERE teams.division = 'FBS (Division I-A Teams)';
  
-- 11b. LEFT JOIN
  -- include matching rows + unmatched rows from the left side table.
  
  -- Write a query that performs an inner join between the tutorial.crunchbase_acquisitions table and the tutorial.crunchbase_companies table, 
  -- but instead of listing individual rows, count the number of non-null rows in each table. 

SELECT * FROM tutorial.crunchbase_companies;
SELECT * FROM tutorial.crunchbase_acquisitions;
  
SELECT 
  COUNT(acquisitions.company_permalink) AS acquisitions_count,
  COUNT(companies.permalink) AS company_count
FROM tutorial.crunchbase_acquisitions acquisitions
JOIN tutorial.crunchbase_companies companies
ON acquisitions.company_permalink = companies.permalink;

  -- Modify the query above to be a LEFT JOIN. Note the difference in results.
SELECT 
  COUNT(acquisitions.company_permalink) AS acquisitions_count,
  COUNT(companies.permalink) AS company_count
FROM tutorial.crunchbase_acquisitions acquisitions
LEFT JOIN tutorial.crunchbase_companies companies
ON acquisitions.company_permalink = companies.permalink;

  -- Count the number of unique companies (don't double-count companies) and unique acquired companies by state. 
    -- Do not include results for which there is no state data, 
    -- and order by the number of acquired companies from highest to lowest.
SELECT 
  companies.state_code,
  COUNT(DISTINCT companies.permalink) AS state_company_count
FROM tutorial.crunchbase_companies companies
GROUP BY companies.state_code;

SELECT 
  companies.state_code AS state_code,
  COUNT(DISTINCT companies.permalink) AS state_company_count,
  COUNT(DISTINCT acquisitions.company_permalink) AS state_acquired_company_count
FROM tutorial.crunchbase_companies companies
LEFT JOIN tutorial.crunchbase_acquisitions acquisitions
ON companies.permalink = acquisitions.company_permalink
WHERE companies.state_code IS NOT NULL
GROUP BY state_code
ORDER BY state_acquired_company_count DESC;

-- 11c. RIGHT JOIN 
  -- returns matched rows + all rows from right table.
  -- rarely used, as reversing the join tables will produce right join result.
  
  -- Count the number of unique companies (don't double-count companies) and unique acquired companies by state. 
    -- Do not include results for which there is no state data, 
    -- and order by the number of acquired companies from highest to lowest. using RUGHT JOIN now!
    
SELECT 
  companies.state_code AS state_code,
  COUNT(DISTINCT companies.permalink) AS state_company_count,
  COUNT(DISTINCT acquisitions.company_permalink) AS state_acquired_company_count
FROM tutorial.crunchbase_acquisitions acquisitions
RIGHT JOIN tutorial.crunchbase_companies companies
ON acquisitions.company_permalink = companies.permalink
WHERE companies.state_code IS NOT NULL
GROUP BY state_code
ORDER BY state_acquired_company_count DESC;

-- 11d. JOIN with filters
  -- To filter the tables before join use the AND clause after the ON statement.
  -- To filter the rows after the join has happened use the WHERE clause.

  -- Write a query that shows a company's name, "status" (found in the Companies table), and the number of unique investors in that company. 
    -- Order by the number of investors from most to fewest. Limit to only companies in the state of New York.
    
    -- Sol: LEFT JOIN, to have comapnies with zero investors
SELECT * FROM tutorial.crunchbase_companies WHERE name = '121cast';
SELECT * FROM tutorial.crunchbase_investments WHERE company_name ='121cast';

SELECT
  companies.name AS company_name,
  companies.status AS company_status,
  COUNT(DISTINCT investments.investor_name) AS investor_count
FROM tutorial.crunchbase_companies companies 
LEFT JOIN tutorial.crunchbase_investments investments
ON companies.permalink = investments.company_permalink
WHERE companies.state_code = 'NY'
GROUP BY companies.name, companies.status
ORDER BY investor_count DESC;

  -- Write a query that lists investors based on the number of companies in which they are invested. 
    -- Include a row for companies with no investor, and order from most companies to least.
    -- sol: to get comapnies with no investors need to left join from comapnies to investments
SELECT 
  CASE 
    WHEN investments.investor_name IS NULL THEN 'No Investor'
    ELSE investments.investor_name 
  END AS investor_name,
  COUNT(DISTINCT companies.name) AS companies_invested_in
FROM tutorial.crunchbase_companies companies 
LEFT JOIN tutorial.crunchbase_investments investments
ON companies.permalink = investments.company_permalink
GROUP BY investor_name
ORDER BY companies_invested_in DESC;


-- 11 e. FULL JOIN or FULL OUTER JOIN
  -- used to fin overlap of data between the two tables.
  
  -- Write a query that joins tutorial.crunchbase_companies and tutorial.crunchbase_investments_part1 using a FULL JOIN. 
    -- Count up the number of rows that are matched/unmatched.
SELECT 
  COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments_p1.company_permalink IS NOT NULL THEN 1 ELSE NULL END) AS both_tables,
  COUNT(CASE WHEN companies.permalink IS NOT NULL AND investments_p1.company_permalink IS NULL THEN 1 ELSE NULL END) AS companies_only,
  COUNT(CASE WHEN companies.permalink IS NULL AND investments_p1.company_permalink IS NOT NULL THEN 1 ELSE NULL END) AS investments_only,
  COUNT(CASE WHEN companies.permalink IS NULL AND investments_p1.company_permalink IS NULL THEN 1 ELSE NULL END) AS none_tables
FROM tutorial.crunchbase_companies AS companies
FULL JOIN tutorial.crunchbase_investments_part1 AS investments_p1
ON companies.permalink = investments_p1.company_permalink;



-- 12. UNION
  -- JOIN allows to combine two tables horizontally, left to right, each row has all columns from first table then second table.
  -- UNION allows to stack the tables vertically, all rows from first tables then all rows from secnd table.
  -- UNION removes duplicates.
  -- UNION ALL to append duplicates.
  -- UNION needs
    -- both tables must have same number of columns
    -- the columns must have the same data types in same order
    
  -- Write a query that appends the two crunchbase_investments datasets above (including duplicate values). 
    -- Filter the first dataset to only companies with names that start with the letter "T", 
    -- and filter the second to companies with names starting with "M" (both not case-sensitive). 
    -- Only include the company_permalink, company_name, and investor_name columns.
SELECT company_permalink, company_name, investor_name
FROM tutorial.crunchbase_investments_part1
WHERE company_name ILIKE 'T%'

UNION ALL

SELECT company_permalink, company_name, investor_name
FROM tutorial.crunchbase_investments_part2
WHERE company_name ILIKE 'M%'
;

  -- Write a query that shows 3 columns. 
    -- The first indicates which dataset (part 1 or 2) the data comes from, 
    -- the second shows company status, and the third is a count of the number of investors.

SELECT DISTINCT status FROM tutorial.crunchbase_companies;

SELECT 
  'part_1' AS part_name, companies.status AS company_status, COUNT(DISTINCT investments_p1.investor_name) AS investors_count
FROM tutorial.crunchbase_investments_part1 investments_p1
JOIN tutorial.crunchbase_companies companies
ON investments_p1.company_permalink = companies.permalink
GROUP BY part_name, company_status

UNION ALL

SELECT 
  'part_2' AS part_name, companies.status AS company_status, COUNT(DISTINCT investments_p2.investor_name) AS investors_count
FROM tutorial.crunchbase_investments_part1 investments_p2
JOIN tutorial.crunchbase_companies companies
ON investments_p2.company_permalink = companies.permalink
GROUP BY part_name, company_status;

--
SELECT 
  companies.status AS company_status,
  inv.part_name AS part_name,
  COUNT(DISTINCT inv.investor_name) AS investors_count
FROM tutorial.crunchbase_companies companies
JOIN 
(
  SELECT 'part_1' AS part_name, investor_name, company_permalink
  FROM tutorial.crunchbase_investments_part1 inv_p1

  UNION ALL
    
  SELECT 'part_2' AS part_name, investor_name, company_permalink
  FROM tutorial.crunchbase_investments_part1 inv_p1
) AS inv
ON companies.permalink = inv.company_permalink
GROUP BY company_status, part_name;


-- 13. JOINS ++  with mutiple queries. 
  -- Currently, we have joined using ON and match equals, we may use more conditionals, '>/</=/!= ' to enrich query. 
  -- Also, instead of just one condition, we may add more conditions via AND/ OR clause.
    -- this makes query faster and more accurate
    
-- 14. SELF JOINS
  -- Scenarios: When we want to combine the rows in the same table, have columns from two rows stacked left to right based on condition.
  -- JOIN the same tables, by giving aliases. 

  -- Identify companies that received an investment from Great Britain following an investment from Japan.
  
SELECT 
  DISTINCT japan_inv.company_name
FROM tutorial.crunchbase_investments_part1 japan_inv
JOIN tutorial.crunchbase_investments_part1 gb_inv
ON japan_inv.company_permalink = gb_inv.company_permalink
AND japan_inv.investor_country_code ='JPN'
AND gb_inv.investor_country_code = 'GBR'
AND gb_inv.funded_at > japan_inv.funded_at;

