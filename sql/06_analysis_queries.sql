-- ==================================================================
-- Analysis Queries
-- ==================================================================

-- ==================================================================
-- Section 1: Sanity/Exploratory Queries
-- ==================================================================
/* -- How Many jobs are in the fact table?
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
order by average_salary desc; */

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


-- Which job titles most often require Python?


-- Which countries have the highest demand for SQL skills?


-- What is the average salary for jobs requiring Machine Learning skills?


-- ==================================================================
-- Section 4: Multi-Table Analytical Queries
-- ==================================================================
-- Top-paying job titles by country


-- Average salary by experience level and remote type


-- Which industries hire hte most for Python-heavy roles?


-- Which combinations of role + skill + location are most common?


-- ==================================================================
-- Section 5: Advanced/Portfolio-level Queries
-- ==================================================================
-- Rank job titles by average salary within each country


-- Find jobs that pay above the average for their country


-- Monthly hiring trends over time


-- Rolling averages by posting month


-- Top 5 industries by hiring urgency
