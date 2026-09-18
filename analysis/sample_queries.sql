-- Sample Athena queries against the Glue Data Catalog table.
-- Table/column names are placeholders until the ETL schema is finalized.

-- Row count sanity check
SELECT COUNT(*) AS total_rows
FROM labor_market_pipeline_db.processed;

-- Postings by location
SELECT location, COUNT(*) AS postings
FROM labor_market_pipeline_db.processed
GROUP BY location
ORDER BY postings DESC
LIMIT 20;

-- Average salary range by job title (top titles by volume)
SELECT
    job_title,
    COUNT(*)            AS postings,
    AVG(salary_min)      AS avg_salary_min,
    AVG(salary_max)      AS avg_salary_max
FROM labor_market_pipeline_db.processed
GROUP BY job_title
ORDER BY postings DESC
LIMIT 20;

-- Posting volume over time
SELECT
    posted_date,
    COUNT(*) AS postings
FROM labor_market_pipeline_db.processed
GROUP BY posted_date
ORDER BY posted_date;
