-- =============================================
-- AI Job Market SQL Project - Dimensions Tables
-- =============================================
drop table if exists job_titles cascade;
drop table if exists industries cascade;
drop table if exists countries cascade;
drop table if exists remote_types cascade;
drop table if exists experience_levels cascade;
drop table if exists education_levels cascade;
drop table if exists hiring_urgencies cascade;
drop table if exists skills cascade;

-- =============================
-- Job_Titles Dimension Table
-- =============================

insert into job_titles(job_title_name)
select distinct job_title
from staging_ai_jobs
where job_title is not null and job_title != '' and job_title != '    '
order by job_title;

-- =============================
-- Industries Dimension Table
-- =============================

insert into industries(industry_name)
select distinct company_industry
from staging_ai_jobs
where company_industry is not null and company_industry != '' and company_industry != '    '
order by company_industry;

-- =============================
-- Countries Dimension Table
-- =============================

insert into countries(country_name)
select distinct country
from staging_ai_jobs
where country is not null and country != '' and country != '    '
order by country;

-- =============================
-- Remote_Types Dimension Table
-- =============================

insert into remote_types(remote_type_name)
select distinct remote_type
from staging_ai_jobs
where remote_type is not null and remote_type != '' and remote_type != '    '
order by remote_type;

-- =============================
-- Experience_Levels Dimension Table
-- =============================

insert into experience_levels(experience_level_name)
select distinct experience_level
from staging_ai_jobs
where experience_level is not null and experience_level != '' and experience_level != '    '
order by experience_level;

-- =============================
-- Education_Levels Dimension Table
-- =============================

insert into education_levels(education_level_name)
select distinct education_level
from staging_ai_jobs
where education_level is not null and education_level != '' and education_level != '    '
order by education_level;

-- =============================
-- Hiring_Urgencies Dimension Table
-- =============================

insert into hiring_urgencies(hiring_urgency_name)
select distinct hiring_urgency
from staging_ai_jobs
where hiring_urgency is not null and hiring_urgency != '' and hiring_urgency != '    '
order by hiring_urgency;

-- =============================
-- Skills Dimension Table
-- =============================

insert into skills(skill_name)
values ('Python'),
       ('SQL'),
       ('Machine Learning'),
       ('Deep Learning'),
       ('Cloud');

-- =============================
-- Verify Inserts
-- =============================
SELECT * FROM job_titles;
SELECT * FROM industries;
SELECT * FROM countries;
SELECT * FROM remote_types;
SELECT * FROM experience_levels;
SELECT * FROM education_levels;
SELECT * FROM hiring_urgencies;
SELECT * FROM skills;