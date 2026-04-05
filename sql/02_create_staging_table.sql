CREATE TABLE staging_ai_jobs (
    job_id INT,
    job_title TEXT,
    company_size TEXT,
    company_industry TEXT,
    country TEXT,
    remote_type TEXT,
    experience_level TEXT,
    years_experience INT,
    education_level TEXT,
    skills_python INT,
    skills_sql INT,
    skills_ml INT,
    skills_deep_learning INT,
    skills_cloud INT,
    salary INT,
    job_posting_month INT,
    job_posting_year INT,
    hiring_urgency TEXT,
    job_openings INT
);

SELECT COUNT(*) FROM staging_ai_jobs;

SELECT * FROM staging_ai_jobs LIMIT 10;

SELECT COUNT(DISTINCT job_id) FROM staging_ai_jobs;