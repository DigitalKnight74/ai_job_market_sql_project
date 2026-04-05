insert into jobs(job_id,
                    job_title_id,
                    company_size,
                    industry_id,
                    country_id,
                    remote_type_id,
                    experience_level_id,
                    years_experience,
                    education_level_id,
                    salary,
                    job_posting_month,
                    job_posting_year,
                    hiring_urgency_id,
                    job_openings
)

select s.job_id,
       jt.job_title_id,
       s.company_size,
       i.industry_id,
       c.country_id,
       rt.remote_type_id,
       el.experience_level_id,
       s.years_experience,
       edl.education_level_id,
       s.salary,
       s.job_posting_month,
       s.job_posting_year,
       hu.hiring_urgency_id,
       s.job_openings

from staging_ai_jobs s

inner join job_titles jt
    on s.job_title = jt.job_title_name

inner join industries i
    on s.company_industry = i.industry_name

inner join countries c
    on s.country = c.country_name

inner join remote_types rt
    on s.remote_type = rt.remote_type_name

inner join experience_levels el
    on s.experience_level = el.experience_level_name

inner join education_levels edl
    on s.education_level = edl.education_level_name

inner join hiring_urgencies hu
    on s.hiring_urgency = hu.hiring_urgency_name;