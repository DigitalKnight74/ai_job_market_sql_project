-- ===============================================================
-- Populates the Many-to-Many relationship between jobs and skills
-- ===============================================================

insert into job_skill_requirements(job_id, skill_id, required_flag)
select s.job_id, sk.skill_id, TRUE
from staging_ai_jobs s
inner join skills sk on sk.skill_name = 'Python'
where s.skills_python = 1;

insert into job_skill_requirements(job_id, skill_id, required_flag)
select s.job_id, sk.skill_id, TRUE
from staging_ai_jobs s
inner join skills sk on sk.skill_name = 'SQL'
where s.skills_sql = 1;

insert into job_skill_requirements(job_id, skill_id, required_flag)
select s.job_id, sk.skill_id, TRUE
from staging_ai_jobs s
inner join skills sk on sk.skill_name = 'Machine Learning'
where s.skills_ml = 1;

insert into job_skill_requirements(job_id, skill_id, required_flag)
select s.job_id, sk.skill_id, TRUE
from staging_ai_jobs s
inner join skills sk on sk.skill_name = 'Deep Learning'
where s.skills_deep_learning = 1;

insert into job_skill_requirements(job_id, skill_id, required_flag)
select s.job_id, sk.skill_id, TRUE
from staging_ai_jobs s
inner join skills sk on sk.skill_name = 'Cloud'
where s.skills_cloud = 1;