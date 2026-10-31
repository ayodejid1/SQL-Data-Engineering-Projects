/* ============================================================
   Lesson 1.10 — Data Modelling
   Exploring the data_jobs star schema
   ============================================================ */


-- ------------------------------------------------------------
-- 1. Preview the job postings fact table
--    A quick look at the key columns and sample records.
-- ------------------------------------------------------------
SELECT
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
FROM job_postings_fact
LIMIT 10;


-- ------------------------------------------------------------
-- 2. Preview the company dimension table
--    Reference data that joins to job postings on company_id.
-- ------------------------------------------------------------
SELECT *
FROM company_dim
LIMIT 10;


-- ------------------------------------------------------------
-- 3. Inspect columns and data types
--    Confirms the schema before deeper analysis.
-- ------------------------------------------------------------
SELECT
    table_name,
    column_name,
    data_type
FROM information_schema.columns
WHERE table_catalog = 'data_jobs'
ORDER BY
    table_name,
    column_name;


-- ------------------------------------------------------------
-- 4. List all tables with expanded metadata
-- ------------------------------------------------------------
PRAGMA show_tables_expanded;


-- ------------------------------------------------------------
-- 5. Describe the job postings fact table
--    Shows column names, types and nullability.
-- ------------------------------------------------------------
DESCRIBE job_postings_fact;
