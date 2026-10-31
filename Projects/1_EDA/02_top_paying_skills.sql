/*
Question: What are the highest-paying skills for data engineers in the United States?
- Calculate the median salary for each skill required in data engineer positions
- Focus on United States positions with specified salaries
- Include skill frequency to identify both salary and demand
- Why? Helps identify which skills command the highest compensation while also showing
    how common those skills are, providing a more complete picture for skill development priorities
*/

SELECT
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
    COUNT(jpf.*) AS demand_count
FROM job_postings_fact jpf
INNER JOIN skills_job_dim sjd ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim sd ON sjd.skill_id = sd.skill_id
WHERE
    jpf.job_title_short = 'Data Engineer'
    AND jpf.job_country = 'United States'
    AND jpf.salary_year_avg IS NOT NULL
GROUP BY
    sd.skills
HAVING
    COUNT(sd.skills) >= 100
ORDER BY
    median_salary DESC,
    demand_count DESC
LIMIT 25;


/*
Results (US data engineer postings with a yearly salary, skills in 100+ postings)

┌───────────────┬───────────────┬──────────────┐
│    skills     │ median_salary │ demand_count │
│    varchar    │    double     │    int64     │
├───────────────┼───────────────┼──────────────┤
│ mongo         │      207000.0 │          203 │
│ ansible       │      157500.0 │          140 │
│ kafka         │      150000.0 │         1492 │
│ kubernetes    │      150000.0 │          669 │
│ cassandra     │      150000.0 │          421 │
│ ruby          │      150000.0 │          132 │
│ pytorch       │      150000.0 │          113 │
│ airflow       │      147500.0 │         1159 │
│ c             │      146325.0 │          158 │
│ terraform     │      145000.0 │          487 │
│ elasticsearch │      141420.0 │          173 │
│ scala         │      140500.0 │         1473 │
│ jira          │      140500.0 │          352 │
│ spark         │      140000.0 │         2544 │
│ hadoop        │      140000.0 │         1419 │
│ docker        │      140000.0 │          641 │
│ javascript    │      140000.0 │          405 │
│ tensorflow    │      140000.0 │          168 │
│ pyspark       │      139000.0 │          657 │
│ java          │      138100.0 │         1789 │
│ redshift      │      138100.0 │         1348 │
│ looker        │      138000.0 │          239 │
│ aws           │      137500.0 │         3292 │
│ nosql         │      137500.0 │         1211 │
│ mysql         │      137500.0 │          664 │
├───────────────┴───────────────┴──────────────┤
│ 25 rows                            3 columns │
└──────────────────────────────────────────────┘


Top 10 US skills by median salary (scale: 0 to $210K, each █ = $5K)

  skill        median salary                                          postings
  mongo        █████████████████████████████████████████▍  $207,000      203
  ansible      ███████████████████████████████▌            $157,500      140
  kafka        ██████████████████████████████              $150,000    1,492
  kubernetes   ██████████████████████████████              $150,000      669
  cassandra    ██████████████████████████████              $150,000      421
  ruby         ██████████████████████████████              $150,000      132
  pytorch      ██████████████████████████████              $150,000      113
  airflow      █████████████████████████████▌              $147,500    1,159
  c            █████████████████████████████▎              $146,325      158
  terraform    █████████████████████████████               $145,000      487

Key Insights:
- Mongo stands out at a $207K median, about $50K above every other skill, but it is
  based on only 203 postings, so it likely reflects a few high-paying employers or
  senior roles rather than a market-wide premium.
- Outside of Mongo, pay is tightly clustered: ranks 2-25 all fall between $137.5K and
  $157.5K, so the choice of skill moves salary less than the ranking suggests.
- Kafka ($150K, 1,492 postings) and Airflow ($147.5K, 1,159 postings) offer the best
  balance of pay and demand. Streaming and orchestration are core data engineering
  skills that sit at the top of the pay range.
- Infrastructure / DevOps skills pay well but appear in fewer postings:
  Kubernetes ($150K, 669), Terraform ($145K, 487), Ansible ($157.5K, 140).
- PyTorch and TensorFlow make the top 25, showing that data engineer roles supporting
  machine learning pay near the top of the range.
- The most in-demand skills pay slightly less: AWS ($137.5K, 3,292), Spark ($140K, 2,544)
  and Java ($138.1K, 1,789).

Takeaway: AWS, Spark and Java are the foundation. Adding Kafka,
Airflow and Kubernetes on top gives the best combination of salary and marketability.

Notes on interpreting the results:
- Salaries are associated with skills, not caused by them. Senior and specialised
  roles list more advanced tools, and seniority drives much of the pay.
- Each posting counts toward every skill it lists, which is why unrelated skills
  (Kafka, Ruby, PyTorch) can share the exact same median.
- Five skills tie at exactly $150K because posted salaries cluster at round numbers;
  their order is set by demand_count, not pay.
- demand_count only includes postings with a yearly salary. See
  01_top_demanded_skills.sql for overall demand.
- The chart uses a $0 baseline so the gaps between skills are not exaggerated.
- Median is used instead of average so a few extreme salaries don't skew the results.
*/


/*
Comparison: REMOTE data engineer jobs (all countries)
Same query with jpf.job_work_from_home = True in place of the country and salary filters

┌────────────┬───────────────┬─────────────┐
│   skills   │ median_salary │ skill_count │
│  varchar   │    double     │    int64    │
├────────────┼───────────────┼─────────────┤
│ rust       │      210000.0 │         232 │
│ terraform  │      184000.0 │        3248 │
│ golang     │      184000.0 │         912 │
│ spring     │      175500.0 │         364 │
│ neo4j      │      170000.0 │         277 │
│ gdpr       │      169616.0 │         582 │
│ zoom       │      168438.0 │         127 │
│ graphql    │      167500.0 │         445 │
│ mongo      │      162250.0 │         265 │
│ fastapi    │      157500.0 │         204 │
│ django     │      155000.0 │         265 │
│ bitbucket  │      155000.0 │         478 │
│ crystal    │      154224.0 │         129 │
│ atlassian  │      151500.0 │         249 │
│ c          │      151500.0 │         444 │
│ typescript │      151000.0 │         388 │
│ kubernetes │      150500.0 │        4202 │
│ node       │      150000.0 │         179 │
│ ruby       │      150000.0 │         736 │
│ airflow    │      150000.0 │        9996 │
│ css        │      150000.0 │         262 │
│ redis      │      149000.0 │         605 │
│ ansible    │      148798.0 │         475 │
│ vmware     │      148798.0 │         136 │
│ jupyter    │      147500.0 │         400 │
├────────────┴───────────────┴─────────────┤
│ 25 rows                        3 columns │
└──────────────────────────────────────────┘

Key Insights (remote):
- Rust is the top-paying remote skill at $210K median, but demand is limited (232 postings).
- Terraform and Golang both have $184K medians, with strong demand (3,248 and 912 postings).
- Other skills with both high pay and moderate-to-high frequency: Spring $175.5K (364),
  Neo4j $170K (277), GDPR $169.6K (582), GraphQL $167.5K (445),
  Kubernetes $150.5K (4,202), Airflow $150K (9,996).
- Bitbucket, Ruby, Redis, Ansible and Jupyter all make the top 25, each with hundreds of postings.
- skill_count here includes postings without a salary, so it reflects total remote demand
  (e.g. Airflow's 9,996), while the median comes only from postings that list a salary.
- Zoom, CSS, Crystal and VMware appear because they are listed on high-paying postings,
  not because they are core data engineering skills.

Remote vs US:
- Kubernetes ($150.5K remote, $150K US), Airflow ($150K / $147.5K) and Ruby ($150K both)
  are consistent across both lists, making them the most reliable pay signals.
- Terraform is much higher for remote roles ($184K vs $145K US), while Mongo is higher
  in the US ($207K vs $162K remote), so those medians depend heavily on the job mix.
- The remote list leans toward software-engineering skills (Rust, Golang, Spring,
  GraphQL, FastAPI); the US list leans toward the classic data stack (Kafka, Spark,
  Hadoop, Scala, Redshift, AWS).
- Posting counts aren't directly comparable: the remote counts include postings
  without a salary, the US counts don't.
*/


-- Top 10 chart rendered directly in DuckDB
WITH top_paying AS (
    SELECT
        sd.skills,
        ROUND(MEDIAN(jpf.salary_year_avg), 0) AS median_salary,
        COUNT(jpf.*) AS demand_count
    FROM job_postings_fact AS jpf
    INNER JOIN skills_job_dim AS sjd
        ON jpf.job_id = sjd.job_id
    INNER JOIN skills_dim AS sd
        ON sjd.skill_id = sd.skill_id
    WHERE
        jpf.job_title_short = 'Data Engineer'
        AND jpf.salary_year_avg IS NOT NULL
        AND jpf.job_country = 'United States'
    GROUP BY
        sd.skills
    HAVING
        COUNT(sd.skills) >= 100
)
SELECT
    skills,
    median_salary,
    demand_count,
    BAR(median_salary, 0, 210000, 42) AS salary_chart
FROM top_paying
ORDER BY
    median_salary DESC,
    demand_count DESC
LIMIT 10;


/*
┌────────────┬───────────────┬──────────────┬──────────────────────────────────┐
│   skills   │ median_salary │ demand_count │           salary_chart           │
│  varchar   │    double     │    int64     │             varchar              │
├────────────┼───────────────┼──────────────┼──────────────────────────────────┤
│ mongo      │      207000.0 │          203 │ ██████████████████████████████.  │
│ ansible    │      157500.0 │          140 │ ██████████████████████████████.  │
│ kafka      │      150000.0 │         1492 │ ██████████████████████████████.  │
│ kubernetes │      150000.0 │          669 │ ██████████████████████████████.  │
│ cassandra  │      150000.0 │          421 │ ██████████████████████████████.  │
│ ruby       │      150000.0 │          132 │ ██████████████████████████████.  │
│ pytorch    │      150000.0 │          113 │ ██████████████████████████████.  │
│ airflow    │      147500.0 │         1159 │ █████████████████████████████▌.  │
│ c          │      146325.0 │          158 │ █████████████████████████████?.  │
│ terraform  │      145000.0 │          487 │ █████████████████████████████ .  │
├────────────┴───────────────┴──────────────┴──────────────────────────────────┤
│ 10 rows                                                            4 columns │
└─────────────────────────────────────────────────────────────────────────────────────────────┘
*/