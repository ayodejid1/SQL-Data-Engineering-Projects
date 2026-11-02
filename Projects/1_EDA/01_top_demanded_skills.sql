/*
Question: What are the most in-demand skills for data engineers?
- Join job postings to inner join table similar to query 2
- Identify the top 10 in-demand skills for data engineers
- Focus on remote job postings in the United States
- Why? Retrieves the top 10 skills with the highest demand in the remote US job market,
    providing insights into the most valuable skills for data engineers seeking remote work
*/
SELECT
    sd.skills,
    count(jpf.job_id) as demand_count
FROM job_postings_fact as jpf
inner join skills_job_dim as sjd
on jpf.job_id = sjd.job_id
inner join skills_dim as sd
on sjd.skill_id = sd.skill_id
where jpf.job_title_short = 'Data Engineer'
    and jpf.job_work_from_home = True
    and job_country = 'United States'
group by sd.skills
order by demand_count desc
limit 10;



/*
Here's the breakdown of the most demanded skills for data engineers:
SQL (8,665 postings) and Python (8,118) are by far the most in-demand skills, about 1.6x the next closest skill.
Cloud platforms come next, with AWS leading at 5,269 postings, followed by Azure at 4,419.
Apache Spark completes the top 5 with 3,766 postings, highlighting the importance of big data processing skills.

Key takeaways:
- SQL and Python remain the foundational skills for data engineers
- Cloud platforms (AWS, Azure) are critical for modern data engineering
- Big data tools like Spark continue to be highly valued
- Modern data platforms and pipeline tools (Snowflake, Databricks, Airflow) are in strong demand
- Java and Kafka round out the top 10 most requested skills

┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │         8665 │
│ python     │         8118 │
│ aws        │         5269 │
│ azure      │         4419 │
│ spark      │         3766 │
│ snowflake  │         2974 │
│ databricks │         2650 │
│ java       │         2507 │
│ airflow    │         2110 │
│ kafka      │         2018 │
├────────────┴──────────────┤
│ 10 rows         2 columns │
└───────────────────────────┘
*/