-- DATA CLEANING --
SELECT * 
FROM layoffs_data;

-- staging

CREATE TABLE layoffs_staging
LIKE layoffs_data;

SELECT * 
FROM layoffs_staging; 

# Remove duplicates
SELECT * , 
ROW_NUMBER() 
OVER(PARTITION BY company, industry, laid_Off_count,percentage, `date`) AS row_num
FROM layoffs_staging;

WITH duplicate_cte AS
(
SELECT * , 
ROW_NUMBER() 
OVER(PARTITION BY company, location_HQ, industry,stage, laid_Off_count,percentage,`date`, country, Funds_Raised) AS row_num
FROM layoffs_staging
)
SELECT * 
FROM duplicate_cte 
WHERE row_num > 1;

SELECT * FROM layoffs_staging
WHERE Company = 'cazoo';

 # DELETING DUPLICATES
/*WITH duplicate_cte AS
(
SELECT * , 
ROW_NUMBER() 
OVER(PARTITION BY company, location_HQ, industry,stage, laid_Off_count,percentage,`date`, country, Funds_Raised) AS row_num
FROM layoffs_staging
)
DELETE 
FROM duplicate_cte 
WHERE row_num > 1;

SELECT * FROM layoffs_staging
WHERE Company = 'cazoo'; */ -- not gonna work cus DELETE is li eupdat eand that cant 

CREATE TABLE `layoffs_staging2` (
  `Company` text,
  `Location_HQ` text,
  `Industry` text,
  `Laid_Off_Count` bigint DEFAULT NULL,
  `Date` text,
  `Source` text,
  `Funds_Raised` bigint DEFAULT NULL,
  `Stage` text,
  `Date_Added` text,
  `Country` text,
  `Percentage` text,
  `List_of_Employees_Laid_Off` text,
  `row_num` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM layoffs_staging;
INSERT INTO layoffs_staging2
SELECT * , 
ROW_NUMBER() 
OVER(PARTITION BY company, location_HQ, industry,stage, laid_Off_count,percentage,`date`, country, Funds_Raised) AS row_num
FROM layoffs_staging;

DELETE 
FROM layoffs_staging2
WHERE row_num >1;

-- standardizing data
SELECT company, TRIM(company)
FROM layoffs_staging2;
 
UPDATE layoffs_staging2
SET company = TRIM(company);
 
SELECT DISTINCT industry
FROM layoffs_staging2
ORDER BY 1;
 
SELECT* 
FROM layoffs_staging2;
SELECT DISTINCT country
FROM layoffs_staging2
ORDER BY 1;
 --
SELECT `date` ,
 str_to_date (`date`, '%Y-%m-%d' )
 FROM layoffs_staging2;
 
 UPDATE layoffs_staging2
 SET `date` = str_to_date (`date`, '%Y-%m-%d' ) ; 
 
-- changing into date column
ALTER TABLE layoffs_staging2
MODIFY COLUMN `date` DATE;

SELECT* 
FROM layoffs_staging2;

#STEP 3 (NULL VALUES)
SELECT * FROM layoffs_staging2
WHERE percentage IS NULL
OR percentage = '';  
 -- missing val
SELECT * FROM layoffs_staging2
WHERE industry = '';

SELECT * FROM layoffs_staging2
WHERE industry = '';

-- Changing Blank space into NULL values
UPDATE layoffs_staging2
SET percentage = NULL
WHERE percentage = ' ';

SELECT * 
FROM layoffs_staging2
WHERE percentage IS NULL OR percentage = ' ';
-- Unimportant columns removed

ALTER TABLE layoffs_staging2
DROP COLUMN row_num;

ALTER TABLE layoffs_staging2
DROP COLUMN `source`;

ALTER TABLE layoffs_staging2
DROP COLUMN `date_added`;

ALTER TABLE layoffs_staging2
DROP COLUMN `list_of_employees_laid_off`;


SELECT * FROM layoffs_data;
SELECT * FROM layoffs_staging2;

-- EXPLORATORY DATA ANALYSIS --

-- Correcting inconsistent data 
UPDATE layoffs_staging2
SET company = UPPER(company);

SELECT  * 
FROM layoffs_staging2;

SELECT MAX(laid_off_count)
FROM layoffs_staging2;

SELECT *
FROM layoffs_staging2
WHERE percentage = 1
ORDER BY Funds_Raised DESC;

-- TOTAL LAYOFFS FOR EACH COMPANY
SELECT company, SUM(laid_off_count)
FROM layoffs_staging2
GROUP BY company
ORDER BY 2 DESC;

-- TOTAL LAYOFFS COUNTRY WISE
SELECT country, SUM(laid_off_count)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- TOTAL LAYOFFS INDUSTRY WISE
SELECT industry, SUM(laid_off_count)
FROM layoffs_staging2
GROUP BY industry
ORDER BY 2 DESC;

-- TOTAL LAYOFFS FOR EACH YEAR 
SELECT YEAR(`date`), SUM(laid_off_count)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- To use Month 
SELECT SUBSTRING(`date`,6,2) AS `Month`, SUM(laid_off_count)
FROM layoffs_staging2
GROUP BY `Month`;

-- ROLLING TOTAL YEAR WISE
WITH Rolling_total_year AS
(
SELECT YEAR(`date`) AS years, SUM(laid_off_count) AS total_laid
FROM layoffs_staging2
GROUP BY years
ORDER BY 1 ASC
)

SELECT years, total_laid, SUM(total_laid) OVER (ORDER BY years ASC) AS Rolling_total
FROM Rolling_total_year;

-- COMPANY & YEAR WISE TOTAL LAY OFFS ROLLING TOTAL
WITH company_year(company,years,total_laid) AS
(
	SELECT company, YEAR(`date`), SUM(laid_off_count) 
	FROM layoffs_staging2
	GROUP BY company, YEAR(`date`)
), company_year_rank AS
(
	SELECT *, DENSE_RANK() OVER(PARTITION BY years ORDER BY total_laid DESC) AS Ranking
	FROM company_year
)
SELECT *
FROM company_year_rank
WHERE Ranking <=5;

























