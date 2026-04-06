-- ==================================================================
-- Analysis Queries
-- ==================================================================

-- ==================================================================
-- Section 1: Sanity/Exploratory Queries
-- ==================================================================
-- How Many jobs are in the fact table?
select count(*)
from jobs;

-- How many distinct job titles are there?
select count(job_title_name)
from job_titles;

-- How many job-skill relationships exist?
select count(*)
from job_skill_requirements;

-- How many jobs per country?
select
  c.country_name,
  count(j.job_id) as number_of_jobs
from jobs j
inner join countries c
  on j.country_id = c.country_id
group by c.country_name
order by c.country_name asc;

-- How many job openings are their per country
select
  c.country_name,
  sum(j.job_openings) as number_of_jobs_openings
from jobs j
inner join countries c
  on j.country_id = c.country_id
group by c.country_name
order by c.country_name asc; */

-- ==================================================================
-- Section 2: Descriptive Business Queries
-- ==================================================================
/* -- Which job titles appear most often?
select
  jt.job_title_name,
  count(j.job_id) as number_of_job_titles
  from jobs j
  inner join job_titles jt
    on j.job_title_id = jt.job_title_id
group by jt.job_title_name
order by number_of_job_titles desc;

-- Which countries have the most job postings?
select
  c.country_name,
  count(j.job_id) as number_of_jobs
from jobs j
inner join countries c
  on j.country_id = c.country_id
group by c.country_name
order by number_of_jobs desc;

-- Which industries have the highest average salary?
select
  i.industry_name,
  round(avg(j.salary), 2) as average_salary
from jobs j
inner join industries i
  on j.industry_id = i.industry_id
group by i.industry_name
order by average_salary desc;

-- Which remote type is most common?
select
  rt.remote_type_name,
  count(j.job_id) as number_of_jobs
from jobs j
inner join remote_types rt
  on j.remote_type_id = rt.remote_type_id
group by rt.remote_type_name
order by number_of_jobs desc;

-- ==================================================================
-- Section 3: Skill-Demand Queries
-- ==================================================================
-- Which skills are most frequently required?
with total_jobs as (
  select count(*) as total_job_count
  from jobs
)
select
  s.skill_name,
  count(distinct jsr.job_id) as jobs_requiring_skill,
  round(
    100.0 * count(distinct jsr.job_id) / tj.total_job_count,
    2
  ) as pct_of_all_jobs
from job_skill_requirements jsr
inner join skills s
  on jsr.skill_id = s.skill_id
cross join total_jobs tj
group by
  s.skill_name,
  tj.total_job_count
order by jobs_requiring_skill desc, s.skill_name;

-- Which job titles most often require Python?
select 
  jt.job_title_name,
  count(distinct jsr.job_id) as jobs_requiring_python
from job_skill_requirements jsr
inner join skills s
  on jsr.skill_id = s.skill_id
inner join jobs j
  on jsr.job_id = j.job_id
inner join job_titles jt
  on j.job_title_id = jt.job_title_id
where s.skill_name = 'Python'
group by jt.job_title_name
order by jobs_requiring_python desc, jt.job_title_name;

-- Which countries have the highest demand for SQL skills?
select
  c.country_name,
  count(distinct jsr.job_id) as jobs_requiring_sql
from job_skill_requirements jsr
inner join skills s
  on jsr.skill_id = s.skill_id
inner join jobs j
  on jsr.job_id = j.job_id
inner join countries c
  on j.country_id = c.country_id
where s.skill_name = 'SQL'
group by c.country_name
order by jobs_requiring_sql desc, c.country_name;

-- What is the average salary for jobs requiring each skills?
select
  s.skill_name,
  round(avg(j.salary), 2) as average_salary
from jobs j
inner join job_skill_requirements jsr
  on j.job_id = jsr.job_id
inner join skills s
  on jsr.skill_id = s.skill_id
where s.skill_name in ('Machine Learning', 'Python', 'SQL', 'Cloud', 'Deep Learning')
group by s.skill_name
order by average_salary desc, s.skill_name;

-- ==================================================================
-- Section 4: Multi-Table Analytical Queries
-- ==================================================================
-- Top-paying job titles by country
  -- CTE_1 Grouped Salary Table
with top_paying_job_titles as (
  select
    c.country_name,
    jt.job_title_name,
    round(max(j.salary), 2) as max_salary
  from jobs j
  inner join countries c
    on j.country_id = c.country_id
  inner join job_titles jt
    on j.job_title_id = jt.job_title_id
  group by 
    c.country_name,
    jt.job_title_name
),
  -- CTE_2 Ranking Table
ranking_top_salaries as (
  select
    tpjt.country_name,
    tpjt.job_title_name,
    tpjt.max_salary,
    dense_rank() over (
      partition by tpjt.country_name
      order by tpjt.max_salary desc
    ) as salary_rank
  from top_paying_job_titles tpjt
)
  -- Final Selection
select
  rts.country_name,
  rts.job_title_name,
  rts.max_salary
from ranking_top_salaries rts
where rts.salary_rank = 1
order by
  rts.country_name,
  rts.job_title_name;

-- Average salary by experience level and remote type
select
  exp.experience_level_name,
  rt.remote_type_name,
  round(avg(j.salary), 2) as average_salary
from jobs j
inner join experience_levels exp
  on j.experience_level_id = exp.experience_level_id
inner join remote_types rt
  on j.remote_type_id = rt.remote_type_id
group by
  exp.experience_level_name,
  rt.remote_type_name
order by
  exp.experience_level_name,
  rt.remote_type_name,
  average_salary desc;

-- Which industries hire the most for roles requiring Python?
with total_jobs as (
  select count(*) as total_job_count
  from jobs
),
python_jobs as (
  select
    i.industry_name,
    count(distinct j.job_id) as jobs_requiring_python
  from jobs j
  inner join job_skill_requirements jsr
    on j.job_id = jsr.job_id
  inner join skills s
    on jsr.skill_id = s.skill_id
  inner join industries i
    on j.industry_id = i.industry_id
  where s.skill_name = 'Python'
  group by i.industry_name
),
ranking_industries as(
  select
    pj.industry_name,
    pj.jobs_requiring_python,
    dense_rank() over (
      order by pj.jobs_requiring_python desc
    ) as industry_rank
  from python_jobs pj
  cross join total_jobs tj
)

select
  ri.industry_name,
  ri.jobs_requiring_python
from ranking_industries ri
order by ri.industry_rank asc;

-- Which combinations of role + skill + location are most common?
select
  jt.job_title_name,
  s.skill_name,
  c.country_name,
  count(distinct j.job_id) as combo_count
from jobs j
inner join job_titles jt
  on j.job_title_id = jt.job_title_id
inner join job_skill_requirements jsr
  on j.job_id = jsr.job_id
inner join skills s
  on jsr.skill_id = s.skill_id
inner join countries c
  on j.country_id = c.country_id
group by
  jt.job_title_name,
  s.skill_name,
  c.country_name
order by
  combo_count desc;

-- ==================================================================
-- Section 5: Advanced/Portfolio-level Queries
-- ==================================================================
-- Rank job titles by average salary within each country
with avg_salary as (
  select
    c.country_name,
    jt.job_title_name,
    round(avg(j.salary), 2) as average_salary
  from jobs j
  inner join countries c
    on j.country_id = c.country_id
  inner join job_titles jt
    on j.job_title_id = jt.job_title_id
  group by 
    c.country_name,
    jt.job_title_name
),
ranked_salaries as (
  select
    avs.country_name,
    avs.job_title_name,
    avs.average_salary,
    dense_rank() over (
      partition by avs.country_name
      order by avs.average_salary desc
    ) as salary_rank
  from avg_salary avs
)
select
  rs.country_name,
  rs.job_title_name,
  rs.average_salary,
  rs.salary_rank
from ranked_salaries rs
where rs.salary_rank <= 3
order by
  rs.country_name,
  rs.salary_rank,
  rs.job_title_name;

-- Find jobs that pay above the average for their country
with avg_country_salary as (
  select
    j.country_id,
    round(avg(j.salary), 2) as average_salary
  from jobs j
  group by j.country_id
)
select
  c.country_name,
  jt.job_title_name,
  j.salary
from jobs j
inner join avg_country_salary acs
  on j.country_id = acs.country_id
inner join countries c
  on j.country_id = c.country_id
inner join job_titles jt
  on j.job_title_id = jt.job_title_id
where l.salary > acs.average_salary
order by
  jt.job_title_name,
  c.country_name,
  j.salary asc;

-- Monthly hiring trends over time: job postings and total openings by month
select
  j.job_posting_year,
  j.job_posting_month,
  count(*) as job_postings,
  sum(job_opening) as total_openings
from jobs j
group by
  j.job_posting_year,
  j.job_posting_month
order by
  j.job_posting_year,
  j_job_posting_month,
  job_posting,
  total_openings;

-- Rolling averages by posting month
with monthly_postings as (
  select
    j.job_posting_year,
    j.job_posting_month,
    count(*) as monthly_job_postings
  from jobs j
  group by 
    j.job_posting_year,
    j.job_posting_month
),
rolling_monthly_average as (
  select
    mp.job_posting_year,
    mp.job_posting_month,
    mp.monthly_job_postings,
    round(avg(mp.monthly_job_postings) over (
      order by mp.job_posting_year, mp.job_posting_month
      rows between 2 preceding and current row
    ), 2) as rolling_avg_monthly_job_postings
  from monthly_postings mp
)
select *
from rolling_monthly_average rma
order by
  rma.job_posting_year asc,
  rma.job_posting_month asc;

-- Top 5 industries by hiring urgency
select
  i.industry_name,
  hu.hiring_urgency_name,
  count(*) as job_count
from jobs j
inner join industries i
  on j.industry_id = i.industry_id
inner join hiring_urgencies hu
  on j.hiring_urgency_id = hu.hiring_urgency_id
where hu.hiring_urgency_id = 1
group by
  i.industry_name,
  hu.hiring_urgency_name
order by
  job_count desc
  limit 5;