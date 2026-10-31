
EXPLAIN ANALYZE
select
    cd.name as company_name,
    count(jpf.job_id) as job_postings_count
from job_postings_fact as jpf
left join company_dim as cd
on jpf.company_id = cd.company_id
where jpf.job_country = 'United States'
group by cd.name
having count(jpf.job_id) > 3000
order by job_postings_count desc
limit 10;  