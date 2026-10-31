/*
Question: What are the most optimal skills for data engineers—balancing both demand and salary?
- Create a ranking column that combines demand count and median salary to identify the most valuable skills.
- Focus only on remote US Data Engineer positions with specified annual salaries.
- Why?
    - This approach highlights skills that balance market demand and financial reward. It weights core skills appropriately instead of letting rare, outlier skills distort the results.
    - The natural log transformation ensures that both high-salary and widely in-demand skills surface as the most practical and valuable to learn for data engineering careers.
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    count(jpf.* ) AS demand_count,
    ROUND(LN(count(jpf.* )), 1) AS ln_demand_count,
    round(MEDIAN(jpf.salary_year_avg) * LN(count(jpf.* ))/1000000, 2) AS optimal_score
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_country = 'United States'
    AND jpf.salary_year_avg IS NOT NULL
    AND jpf.job_work_from_home = True
GROUP BY
    sd.skills
HAVING
    COUNT(jpf.*) >= 100
ORDER BY
    optimal_score DESC
LIMIT 25;

/*
Results (remote US data engineer postings with a yearly salary, skills in 100+ postings)

┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      192750.0 │          146 │             5.0 │          0.96 │
│ python     │      135500.0 │          853 │             6.7 │          0.91 │
│ aws        │      140000.0 │          583 │             6.4 │          0.89 │
│ sql        │      130000.0 │          850 │             6.7 │          0.88 │
│ airflow    │      154000.0 │          298 │             5.7 │          0.88 │
│ spark      │      140000.0 │          369 │             5.9 │          0.83 │
│ snowflake  │      139500.0 │          352 │             5.9 │          0.82 │
│ git        │      150500.0 │          176 │             5.2 │          0.78 │
│ azure      │      130000.0 │          358 │             5.9 │          0.76 │
│ kafka      │      140000.0 │          189 │             5.2 │          0.73 │
│ databricks │      135500.0 │          202 │             5.3 │          0.72 │
│ scala      │      137500.0 │          185 │             5.2 │          0.72 │
│ kubernetes │      155000.0 │          101 │             4.6 │          0.72 │
│ java       │      130000.0 │          214 │             5.4 │           0.7 │
│ redshift   │      130000.0 │          198 │             5.3 │          0.69 │
│ hadoop     │      135000.0 │          144 │             5.0 │          0.67 │
│ nosql      │      135500.0 │          138 │             4.9 │          0.67 │
│ pyspark    │      140000.0 │          120 │             4.8 │          0.67 │
│ gcp        │      136000.0 │          119 │             4.8 │          0.65 │
│ r          │      135290.0 │          116 │             4.8 │          0.64 │
│ power bi   │      120070.0 │          111 │             4.7 │          0.57 │
│ sql server │      120000.0 │          116 │             4.8 │          0.57 │
│ tableau    │      115000.0 │          133 │             4.9 │          0.56 │
├────────────┴───────────────┴──────────────┴─────────────────┴───────────────┤
│ 23 rows                                                           5 columns │
└─────────────────────────────────────────────────────────────────────────────┘

Key Insights:
- Terraform has the highest optimal score (0.96), driven almost entirely by its $192.75K
  median salary. With only 146 postings, it is a high-value specialisation rather than
  a core requirement.
- Python (0.91), AWS (0.89), SQL (0.88), Airflow (0.88), Spark (0.83) and Snowflake (0.82)
  make up the rest of the top 7. These are the core data engineering stack, combining
  solid salaries ($130K-$154K) with the highest demand.
- Python and SQL are the most requested skills (853 and 850 postings) but have some of
  the lower medians ($135.5K and $130K). They are baseline expectations rather than
  salary differentiators.
- Airflow is the strongest all-rounder after Terraform: $154K median with 298 postings.
- AWS leads the cloud platforms on both pay and demand: AWS 0.89 ($140K, 583),
  Azure 0.76 ($130K, 358), GCP 0.65 ($136K, 119).
- Kubernetes has the second-highest median ($155K) but only just meets the 100-posting
  threshold (101), so it ranks mid-table at 0.72.
- BI and analyst-oriented tools (Power BI, SQL Server, Tableau) sit at the bottom with
  the lowest medians ($115K-$120K). They are more common in analyst roles and add
  little salary value for data engineers.

Takeaway: Build the foundation with Python, SQL, AWS, Airflow, Spark and Snowflake,
which offer the best balance of demand and pay, then add infrastructure skills like
Terraform and Kubernetes for the biggest salary upside.

Notes on interpreting the results:
- The natural log compresses demand: Python has nearly 6x Terraform's postings but only
  about 1.3x its ln_demand_count, so salary carries more weight in the score.
- Scores are close together (0.56-0.96) and rounded to 2 decimals, producing ties
  (SQL/Airflow at 0.88; Databricks/Scala/Kubernetes at 0.72), so neighbouring ranks
  are effectively equal.
- demand_count only includes remote US postings with a listed salary, so it is a
  relative measure, not total market demand.
- Salaries are associated with skills, not caused by them; senior roles tend to list
  more advanced tools.
*/