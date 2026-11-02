-- Task:
--Input the data
-- Split the Transaction Code to extract the letters at the start of the transaction code. These identify the bank who processes the transaction
-- Rename the new field with the Bank code 'Bank'. 
-- Rename the values in the Online or In-person field, Online of the 1 values and In-Person for the 2 values. 
-- Change the date to be the day of the week
-- Different levels of detail are required in the outputs. You will need to sum up the values of the transactions in three ways:
-- 1. Total Values of Transactions by each bank
-- 2. Total Values by Bank, Day of the Week and Type of Transaction (Online or In-Person)
-- 3. Total Values by Bank and Customer Code
-- Output each data file 

SELECT 
SPLIT_PART(transaction_code,'-',1) as bank,
CASE
WHEN online_or_in_person=1 THEN 'Online'
WHEN online_or_in_person=2 THEN 'In-Person'
END as online_or_in_person,
DAYNAME(DATE(LEFT(transaction_date,10), 'dd/MM/yyyy'))||'day' as transaction_day
FROM PD2023_WK01;

-- Output 1: Total Values of Transactions by each bank
SELECT 
SPLIT_PART(transaction_code,'-',1) as bank,
SUM(value) as value
FROM PD2023_WK01
GROUP BY SPLIT_PART(transaction_code,'-',1);

-- Output 2: Total Values by Bank, Day of the Week and Type of Transaction
SELECT
SPLIT_PART(transaction_code,'-',1) as bank,
DAYNAME(DATE(LEFT(transaction_date,10), 'dd/MM/yyyy')) as transaction_day,
CASE
WHEN online_or_in_person=1 THEN 'Online'
WHEN online_or_in_person=2 THEN 'In-Person'
END as online_or_in_person,
SUM(value) as value
FROM PD2023_WK01
--groups by 1st, 2nd and 3rd columns without having to write out the transformation functions for the columns in the query
GROUP BY 1, 2, 3;

--Output 3: Total Values by Bank and Customer Code
SELECT SPLIT_PART(transaction_code,'-',1) as bank,
customer_code,
SUM(value) as value
GROUP BY SPLIT_PART(transaction_code,'-',1), customer_code;
