-- 11. Joins: Till ow, we worked on one table, but the query results may come from more than one table.
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