SELECT *
FROM dirty_cafe_sales;


CREATE TABLE cafe_staging
LIKE dirty_cafe_sales;


INSERT INTO cafe_staging
SELECT * 
FROM dirty_cafe_sales;


SELECT *
FROM cafe_staging;


SELECT *, ROW_NUMBER() OVER (PARTITION BY `TRANSACTION ID`, item, Quantity, "Price Per Unit", "Total Spent", "Payment Method", Location, `Transaction Date`) as row_num
FROM cafe_staging;


WITH duplicates AS
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY `TRANSACTION ID`, item, Quantity, "Price Per Unit", "Total Spent", "Payment Method", Location, `Transaction Date`) as row_num
FROM cafe_staging
)
SELECT *
FROM duplicates
WHERE row_num > 1;

-- NO DUPLICATES, LET'S TREAT BLANK AND NULL VALUES


SELECT *
FROM cafe_staging;


-- First, Let's Fix the column names


ALTER TABLE cafe_staging
RENAME COLUMN  `Transaction ID` TO Transaction_id;
ALTER TABLE cafe_staging
RENAME COLUMN  `Price Per Unit` TO price_per_unit;
ALTER TABLE cafe_staging
RENAME COLUMN  `Total Spent` TO total_spent;
ALTER TABLE cafe_staging
RENAME COLUMN  `Payment Method` TO payment_method;
ALTER TABLE cafe_staging
RENAME COLUMN  `Transaction Date` TO transaction_date;


SET SQL_SAFE_UPDATES = 0;

UPDATE cafe_staging
SET total_spent = CAST(Quantity * price_per_unit AS CHAR)
WHERE total_spent = 'ERROR'
OR total_spent = 'UNKNOWN'
OR total_spent = '';


SELECT *
FROM cafe_staging
WHERE total_spent = '';


-- NO EMPTY ROWS, LET's CONVERT THE COLUMN FROM TEXT TO DOUBLE


ALTER TABLE cafe_staging
MODIFY total_spent DOUBLE;


SELECT *
FROM cafe_staging;


UPDATE cafe_staging
SET item = 'UNKNOWN'
WHERE item = 'ERROR'
OR item = '';


UPDATE cafe_staging
SET payment_method = 'UNKNOWN'
WHERE payment_method = 'ERROR'
OR payment_method = '';


UPDATE cafe_staging
SET Location = 'UNKNOWN'
WHERE Location = 'ERROR'
OR Location = '';


UPDATE cafe_staging
SET transaction_date = 'UNKNOWN'
WHERE transaction_date = 'ERROR'
OR transaction_date = '';


SELECT *
FROM cafe_staging;


DELETE 
FROM cafe_staging
WHERE item = 'UNKNOWN' AND
payment_method = 'UNKNOWN' AND
location = 'UNKNOWN' AND
transaction_date = 'UNKNOWN';


-- DATA CLEANING DONE. LET'S EXPORT THIS INTO A CSV

SELECT *
FROM cafe_staging;

