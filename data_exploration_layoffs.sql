-- Explatory Data Analysis

SELECT *
FROM layoffs_copy2;


SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_copy2;


SELECT *
FROM layoffs_copy2
WHERE percentage_laid_off = 1
ORDER By funds_raised_millions DESC;


SELECT company, SUM(total_laid_off)
FROM layoffs_copy2
GROUP BY company
ORDER BY 2 DESC;


SELECT MIN(`date`), MAX(`date`)
FROM layoffs_copy2;


SELECT industry, SUM(total_laid_off)
FROM layoffs_copy2
GROUP BY industry
ORDER BY 2 DESC;


SELECT country, SUM(total_laid_off)
FROM layoffs_copy2
GROUP BY country
ORDER BY 2 DESC;


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_copy2
GROUP BY YEAR(`date`)
ORDER BY 2 DESC;


SELECT company, SUM(percentage_laid_off)
FROM layoffs_copy2
GROUP BY company
ORDER BY 2  DESC;


SELECT SUBSTRING(`date`,1,7) as `MONTH`, SUM(total_laid_off)
FROM layoffs_copy2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC;

WITH Rolling_Total AS
(
SELECT SUBSTRING(`date`,1,7) as `MONTH`, SUM(total_laid_off) AS total_laid_off
FROM layoffs_copy2
WHERE SUBSTRING(`date`,1,7) IS NOT NULL
GROUP BY `MONTH`
ORDER BY 1 ASC
)
SELECT `MONTH`, total_laid_off,  SUM(total_laid_off) OVER(ORDER BY `MONTH`) as rolling_total
FROM Rolling_total;



SELECT company,  SUBSTRING(`date`, 1, 4) as `Year`, SUM(total_laid_off) as layoffs
FROM layoffs_copy2
GROUP BY company, `Year`
ORDER BY company ASC;




   
WITH company_year_totals (company, years, total_laid_off) AS (
    SELECT 
        company,
        SUBSTRING(`date`, 1, 4),
        SUM(total_laid_off)
    FROM layoffs_copy2
    GROUP BY company, SUBSTRING(`date`, 1, 4)
) , Company_year_rank AS
(
SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid_off DESC) as Ranking
FROM company_year_totals
WHERE years IS NOT NULL
)
SELECT *
FROM Company_year_rank
WHERE Ranking <= 5
;
