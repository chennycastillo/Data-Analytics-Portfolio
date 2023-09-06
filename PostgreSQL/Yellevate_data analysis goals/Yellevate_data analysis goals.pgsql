--Creating a backup table for incase data cleaning is needed
CREATE TABLE backup_yellevate_invoices AS
SELECT * FROM yellevate_invoices;


--Checking Typographical Errors

SELECT DISTINCT country
FROM backup_yellevate_invoices;

--Checking for Nulls
SELECT * FROM backup_yellevate_invoices
WHERE NOT(backup_yellevate_invoices IS NOT NULL);

--Checking Duplicates
SELECT country, customer_id, invoice_number, invoice_date, due_date,invoice_amount_usd,settled_date
FROM backup_yellevate_invoices
GROUP BY 1, 2, 3, 4, 5, 6, 7
HAVING COUNT(*)>1;

------------------------------------------DATA ANALYSIS GOALS-----------------------------------

--1. The processing time in which invoices are settled (average # of days rounded to a whole number)
/*Based on Yellevate Data Dictionary:
SettledDate and DaystoSettle - Customer paid the invoice or customer does not have to pay*/

SELECT ROUND(AVG(days_to_settle),0) AS avg_settled_days
FROM yellevate_invoices;


--2. The processing time for the company to settle disputes (average # of days rounded to a whole number)
/*Included invoices with disputes*/
SELECT ROUND(AVG(days_to_settle),0) AS avg_settled_days_disputed
FROM yellevate_invoices
WHERE disputed = 1;

--The processing time for the company to settle disputes (average # of days rounded to a whole number) (DISPUTE LOST)
SELECT ROUND(AVG(days_to_settle),0) AS avg_settled_days_disputed
FROM yellevate_invoices
WHERE disputed = 1 AND dispute_lost = 1;


--The processing time for the company to settle disputes (average # of days rounded to a whole number) (DISPUTE NOT LOST)
SELECT ROUND(AVG(days_to_settle),0) AS avg_settled_days_disputed
FROM yellevate_invoices
WHERE disputed = 1 AND dispute_lost = 0;

--3. Percentage of disputes received by the company that were lost (within two decimal places)
SELECT ROUND(SUM(dispute_lost)/SUM(disputed)*100,2) AS disputes_lost
FROM yellevate_invoices;

--4. Percentage of revenue lost from disputes (within two decimal places)
SELECT
ROUND(((SELECT SUM(invoice_amount_usd) 
FROM yellevate_invoices
WHERE dispute_lost = 1) /
SUM(invoice_amount_usd)*100),2) AS percentage_revenue_lost_disputes
FROM yellevate_invoices;



--5.The country where the company reached the highest losses from lost disputes (in USD).

SELECT country, dispute_lost, SUM(invoice_amount_usd)
FROM yellevate_invoices
GROUP BY 1, 2
HAVING dispute_lost = 1
ORDER BY SUM(invoice_amount_usd) DESC;
