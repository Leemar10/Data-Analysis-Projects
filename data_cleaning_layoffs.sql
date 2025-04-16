-- 1. Remove Duplicates
-- 2. Standardize the Data
-- 3. Null Values or blank Values
-- 4. Remove Any Columns or Rows


SELECT *
FROM layoffs;

-- REMOVOING DUPLICATES
CREATE TABLE layoffs_copy
LIKE layoffs;

INSERT INTO layoffs_copy
SELECT *
FROM layoffs;

SELECT *
FROM layoffs_copy;

SELECT count(company)
FROM layoffs_copy;

SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_copy;

WITH duplicate_cte AS
(
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_copy
) 
SELECT *
FROM duplicate_cte
WHERE row_num > 1;



CREATE TABLE `layoffs_copy2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT *
FROM layoffs_copy2;

INSERT INTO layoffs_copy2
SELECT *, 
ROW_NUMBER() OVER(PARTITION BY company, location, industry, total_laid_off, percentage_laid_off,
`date`, stage, country, funds_raised_millions) as row_num
FROM layoffs_copy;


SELECT *
FROM layoffs_copy2
WHERE row_num > 1;

DELETE
FROM layoffs_copy2
WHERE row_num > 1;

SET SQL_SAFE_UPDATES = 0;

SELECT *
FROM layoffs_copy2;

-- STANDARDISING DATA

SELECT company, TRIM(company)
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET company = TRIM(company);

SELECT *
FROM layoffs_copy2
WHERE industry LIKE 'Crypto%';


UPDATE layoffs_copy2
SET industry  = 'Crypto'
WHERE industry LIKE 'Crypto%';

SELECT DISTINCT country
FROM layoffs_copy2
ORDER BY 1;


SELECT DISTINCT country, TRIM(TRAILING '.' FROM country)
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

SELECT `date`,
STR_TO_DATE(`date`, '%m/%d/%Y')
FROM layoffs_copy2;

UPDATE layoffs_copy2
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');


SELECT `date`
FROM layoffs_copy2;


ALTER TABLE layoffs_copy2
MODIFY COLUMN `date` DATE;

SELECT *
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

UPDATE layoffs_copy2
SET industry = NULL 
WHERE industry = '';


SELECT *
FROM layoffs_copy2
WHERE industry IS NULL
OR industry = '';


SELECT *
FROM layoffs_copy2
where company = 'Airbnb';


SELECT t1.industry, t2.industry
FROM layoffs_copy2 t1
JOIN layoffs_copy2 t2
	ON t1.company = t2.company
WHERE (t1.industry IS NULL OR t1.industry = '') 
AND t2.industry IS NOT NULL;


UPDATE layoffs_copy2 t1
JOIN layoffs_copy2 t2
	ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE (t1.industry IS NULL OR t1.industry = '') 
AND t2.industry IS NOT NULL;


SELECT *
FROM layoffs_copy2
WHERE industry IS NULL
OR industry = '';

SELECT *
FROM layoffs_copy2
where company = 'Bally''s Interactive';

SELECT *
FROM layoffs_copy2;

SELECT *
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SET SQL_SAFE_UPDATES = 0;


DELETE 
FROM layoffs_copy2
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;


SELECT *
FROM layoffs_copy2;


ALTER TABLE layoffs_copy2
DROP COLUMN row_num;


-- Data Cleaning Done. Let's Move onto Explatory Data Analysis.
