--CREATE TABLE DUPLICATE

SELECT * FROM serv2
WHERE sched = '072020' OR sched = '082018';

CREATE TABLE cserv2 AS
SELECT * FROM serv2
WHERE record BETWEEN '302' AND '398';

--CONVERT TEXT TO DATE

SELECT * FROM cserv2;

UPDATE cserv2
SET sched = TO_DATE(sched,'mmyyyy');

ALTER TABLE cserv2
ALTER COLUMN sched TYPE DATE USING (sched::DATE);

--ERRORS IN COLUMNS

SELECT DISTINCT branch, service FROM cserv2;

UPDATE cserv2
SET service = 'Convenience Store'
WHERE service = 'Conviinience Store';

UPDATE cserv2
SET service = 'Restaurant'
WHERE service = 'Restorant';

--DUPLICATES
SELECT branch, service,cos,revenue, gross_profit FROM cserv2
GROUP BY  branch, service,cos,revenue, gross_profit
HAVING COUNT(*)>1;

SELECT * FROM cserv2
WHERE cos = 122 AND revenue = 441 AND gross_profit = 319;

DELETE from cserv2
WHERE record = 339;

--CHECKING NULLS
SELECT * FROM cserv2
WHERE NOT (cserv2 IS NOT NULL);

-- Replacing null with values that are good estimates
UPDATE cserv2
SET gross_profit = 200-192
WHERE record = 342
;

--Detecting outliers using the zscores


SELECT record, service, revenue, cos, gross_profit,
(gross_profit-AVG(gross_profit) over())/STDDEV(gross_profit) over() AS zed
FROM cserv2;


SELECT*FROM
(SELECT record, service, revenue, cos, gross_profit,
(gross_profit-AVG(gross_profit) over())/STDDEV(gross_profit) over() AS zed
FROM cserv2) AS Zed
WHERE ZED >2.576 OR Zed <-2.576;


--Dealing with Outliers
SELECT * FROM cprodsales
WHERE revenue = 355 AND cogs = 186 AND gross_profit = 5172;

UPDATE cprodsales
SET gross_profit = 355-186
WHERE ref = 343;

SELECT * FROM cserv2
WHERE revenue = 200 AND cos = 180 AND gross_profit = 20000;

UPDATE cserv2
SET gross_profit = 200-180
WHERE record = 364;

SELECT * FROM cserv2;