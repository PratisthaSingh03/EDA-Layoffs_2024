# EDA-Layoffs_2024
This project focuses on performing Exploratory Data Analysis (EDA) using SQL on a dataset related to company layoffs. The analysis aims to extract insights, identify trends, and summarize key metrics, such as the distribution of layoffs across different companies and years. 

Key Highlights:
Summarized total layoffs by year and company.
Performed rolling total calculations to observe cumulative layoffs over time.
Identified top 5 companies with the highest layoffs per year using DENSE_RANK().
Analyzed layoff trends over multiple years to detect patterns and spikes.


Techniques Used:
Aggregation using GROUP BY and SUM()
Window functions (SUM() and DENSE_RANK()) for rolling totals and ranking
Common Table Expressions (CTEs) for step-by-step data processing
Filtering and ordering for relevant insights


SQL Concepts Covered:
Aggregations
Window Functions (Ranking & Rolling Totals)
Subqueries and CTEs
Data Grouping & Filtering


Dataset:
The dataset consists of company layoff records with information such as:

Company name
Year of layoff
Number of employees laid off
