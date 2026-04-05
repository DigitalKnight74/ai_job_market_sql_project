-- =========================================
-- AI Job Market SQL Project - Schema
-- =========================================
-- =========================
-- DROP TABLES (SAFE RESET)
-- =========================
DROP TABLE IF EXISTS job_skill_requirements;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS skills;
DROP TABLE IF EXISTS hiring_urgencies;
DROP TABLE IF EXISTS education_levels;
DROP TABLE IF EXISTS experience_levels;
DROP TABLE IF EXISTS remote_types;
DROP TABLE IF EXISTS countries;
DROP TABLE IF EXISTS industries;
DROP TABLE IF EXISTS job_titles;
-- =========================
-- DIMENSION TABLES
-- =========================
-- Small, descriptive lookup tables that store categories/attributes
CREATE TABLE job_titles (
    job_title_id SERIAL PRIMARY KEY,
    job_title_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE industries (
    industry_id SERIAL PRIMARY KEY,
    industry_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE remote_types (
    remote_type_id SERIAL PRIMARY KEY,
    remote_type_name VARCHAR(100) NOT NULL UNIQUE
);
CREATE TABLE experience_levels (
    experience_level_id SERIAL PRIMARY KEY,
    experience_level_name VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE education_levels (
    education_level_id SERIAL PRIMARY KEY,
    education_level_name VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE hiring_urgencies (
    hiring_urgency_id SERIAL PRIMARY KEY,
    hiring_urgency_name VARCHAR(50) NOT NULL UNIQUE
);
CREATE TABLE skills (
    skill_id SERIAL PRIMARY KEY,
    skill_name VARCHAR(50) NOT NULL UNIQUE
);
-- =========================
-- FACT TABLE
-- =========================
-- Table that contains measurable data (salary, openings) and adds foreign keys to dimensions -> stores actual events/transactions
CREATE TABLE jobs (
    job_id INT PRIMARY KEY,
    job_title_id INT NOT NULL,
    company_size VARCHAR(50) NOT NULL,
    industry_id INT NOT NULL,
    country_id INT NOT NULL,
    remote_type_id INT NOT NULL,
    experience_level_id INT NOT NULL,
    years_experience INT NOT NULL CHECK (years_experience >= 0),
    education_level_id INT NOT NULL,
    salary NUMERIC(12, 2) NOT NULL CHECK(salary >= 0),
    job_posting_month INT NOT NULL CHECK (job_posting_month BETWEEN 1 AND 12),
    job_posting_year INT NOT NULL CHECK (job_posting_year BETWEEN 2000 AND 2100),
    hiring_urgency_id INT NOT NULL,
    job_openings INT NOT NULL CHECK (job_openings >= 1),
    FOREIGN KEY (job_title_id) REFERENCES job_titles(job_title_id),
    FOREIGN KEY (industry_id) REFERENCES industries(industry_id),
    FOREIGN KEY (country_id) REFERENCES countries(country_id),
    FOREIGN KEY (remote_type_id) REFERENCES remote_types(remote_type_id),
    FOREIGN KEY (experience_level_id) REFERENCES experience_levels(experience_level_id),
    FOREIGN KEY (education_level_id) REFERENCES education_levels(education_level_id),
    FOREIGN KEY (hiring_urgency_id) REFERENCES hiring_urgencies(hiring_urgency_id)
);
 -- =========================
-- MANY-TO-MANY (SKILLS)
-- =========================
-- Builds powerful flexible, scalable, real-world design, interview gold and creates MANY-TO-MANY Relationships between databases
CREATE TABLE job_skill_requirements (
    job_id INT NOT NULL,
    skill_id INT NOT NULL,
    required_flag BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (job_id, skill_id),
    FOREIGN KEY (job_id) REFERENCES jobs(job_id) ON DELETE CASCADE,
    FOREIGN KEY (skill_id) REFERENCES skills(skill_id) ON DELETE CASCADE
);
-- =========================
-- INDEXES (PERFORMANCE)
-- =========================
-- Builds an index table that assists in the search accelerates database scans
CREATE INDEX idx_jobs_salary ON jobs(salary);
CREATE INDEX idx_jobs_country ON jobs(country_id);
CREATE INDEX idx_jobs_experience ON jobs(years_experience);
CREATE INDEX idx_jobs_posting_date ON jobs(job_posting_year, job_posting_month);
CREATE INDEX idx_jsr_job ON job_skill_requirements(job_id);
CREATE INDEX idx_jsr_skill ON job_skill_requirements(skill_id);