--Correct mispelled columns
UPDATE cinvestment_subset


--Checking financial services

SELECT DISTINCT market
FROM cinvestment_subset
ORDER by market;

SELECT DISTINCT market
FROM cinvestment_subset
WHERE market = 'Financial Services';

UPDATE cinvestment_subset
SET market = 'Financial Services'
WHERE market = 'FincialServices';

--Create subset table
CREATE TABLE financialservicesfunding
AS SELECT * FROM cinvestment_subset
WHERE market = 'Financial Services';

--Checking for typographical errors
SELECT DISTINCT country_code
FROM financialservicesfunding
ORDER by country_code;

--Checking for NULLS
SELECT * FROM financialservicesfunding
WHERE NOT (financialservicesfunding IS NOT NULL);

--AVG seed funding and Standard Deviation for seed funding both max and min
SELECT ROUND(AVG(Seed),2) FROM financialservicesfunding;

SELECT status, country_code, founded_year, seed,
ROUND((seed-AVG(seed)over())/STDDEV (seed) over (),2) AS STDEV
FROM financialservicesfunding
ORDER BY stdev;

--Start up with  equity_crowdfunding

SELECT country_code,founded_year,status,equity_crowdfunding
FROM financialservicesfunding
WHERE equity_crowdfunding <>0;

--Significant Outliers in total funding
SELECT country_code, status, founded_year, funding_total_usd,
ROUND((funding_total_usd-AVG(funding_total_usd)OVER())/STDDEV (funding_total_usd) over (),2) as zed
FROM financialservicesfunding;

SELECT * FROM
(SELECT country_code, status, founded_year, funding_total_usd,
ROUND((funding_total_usd-AVG(funding_total_usd)OVER())/STDDEV (funding_total_usd) over (),2) as zed
FROM financialservicesfunding) AS outliers
WHERE zed >2.576 OR zed <-2.576;

--Removing the outliers
DELETE FROM financialservicesfunding
WHERE funding_total_usd = 725000000;

--Check all data
SELECT * FROM financialservicesfunding;