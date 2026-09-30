-- =============================================================================
-- Database DDL Script: Lotus Care Outpatient Clinics Data Warehouse
-- Environment: PostgreSQL / pgAdmin 4
-- Description: Star Schema DDL for fact_appointment and dimensional tables.
-- =============================================================================

-- Drop existing tables to ensure clean deployment (fact dropped first due to FK dependencies)
DROP TABLE IF EXISTS fact_appointment CASCADE;
DROP TABLE IF EXISTS dim_patient CASCADE;
DROP TABLE IF EXISTS dim_doctor CASCADE;
DROP TABLE IF EXISTS dim_clinic CASCADE;
DROP TABLE IF EXISTS dim_date CASCADE;


-- =============================================================================
-- 1. DIMENSION TABLES
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Table: dim_patient
-- Description: Patient demographic dimension containing current patient attributes.
-- -----------------------------------------------------------------------------
CREATE TABLE dim_patient (
    patient_key SERIAL PRIMARY KEY,              -- Surrogate Key (Auto-incrementing)
    patient_id VARCHAR(20) NOT NULL UNIQUE,      -- Natural Operational Source ID
    patient_name VARCHAR(100) NOT NULL,
    gender VARCHAR(10),
    district VARCHAR(50) NOT NULL
);

-- -----------------------------------------------------------------------------
-- Table: dim_doctor
-- Description: Medical practitioner dimension with denormalized specialization.
-- -----------------------------------------------------------------------------
CREATE TABLE dim_doctor (
    doctor_key SERIAL PRIMARY KEY,               -- Surrogate Key (Auto-incrementing)
    doctor_id VARCHAR(20) NOT NULL UNIQUE,       -- Natural Operational Source ID
    doctor_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(50) NOT NULL
);

-- -----------------------------------------------------------------------------
-- Table: dim_clinic
-- Description: Physical clinic branch location dimension.
-- -----------------------------------------------------------------------------
CREATE TABLE dim_clinic (
    clinic_key SERIAL PRIMARY KEY,               -- Surrogate Key (Auto-incrementing)
    clinic_id VARCHAR(20) NOT NULL UNIQUE,       -- Natural Operational Source ID
    clinic_name VARCHAR(100) NOT NULL,
    district VARCHAR(50) NOT NULL
);

-- -----------------------------------------------------------------------------
-- Table: dim_date
-- Description: Temporal calendar dimension pre-populated for calendar year 2025.
-- -----------------------------------------------------------------------------
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,                    -- Date Key in YYYYMMDD integer format
    full_date DATE NOT NULL,
    day_of_week VARCHAR(15) NOT NULL,
    month_name VARCHAR(15) NOT NULL,
    quarter INT NOT NULL CHECK (quarter BETWEEN 1 AND 4),
    year INT NOT NULL
);


-- =============================================================================
-- 2. FACT TABLE
-- =============================================================================

-- -----------------------------------------------------------------------------
-- Table: fact_appointment
-- Description: Central transaction fact table capturing patient appointment events.
-- Grain: One row per discrete appointment event.
-- -----------------------------------------------------------------------------
CREATE TABLE fact_appointment (
    appointment_id VARCHAR(20) PRIMARY KEY,     -- Operational Appointment ID
    patient_key INT NOT NULL,                    -- Foreign Key -> dim_patient
    doctor_key INT NOT NULL,                     -- Foreign Key -> dim_doctor
    clinic_key INT NOT NULL,                     -- Foreign Key -> dim_clinic
    date_key INT NOT NULL,                       -- Foreign Key -> dim_date
    wait_minutes INT CHECK (wait_minutes >= 0),  -- Measure: Patient Wait Time
    consultation_minutes INT CHECK (consultation_minutes >= 0), -- Measure: Duration
    fee NUMERIC(10, 2) CHECK (fee >= 0),         -- Measure: Transaction Fee (Revenue)

    -- Referential Integrity Constraints
    CONSTRAINT fk_fact_patient FOREIGN KEY (patient_key) REFERENCES dim_patient(patient_key) ON DELETE RESTRICT,
    CONSTRAINT fk_fact_doctor FOREIGN KEY (doctor_key) REFERENCES dim_doctor(doctor_key) ON DELETE RESTRICT,
    CONSTRAINT fk_fact_clinic FOREIGN KEY (clinic_key) REFERENCES dim_clinic(clinic_key) ON DELETE RESTRICT,
    CONSTRAINT fk_fact_date FOREIGN KEY (date_key) REFERENCES dim_date(date_key) ON DELETE RESTRICT
);


-- =============================================================================
-- 3. INDEXES FOR OLAP QUERY OPTIMIZATION
-- =============================================================================

CREATE INDEX idx_fact_patient_key ON fact_appointment(patient_key);
CREATE INDEX idx_fact_doctor_key ON fact_appointment(doctor_key);
CREATE INDEX idx_fact_clinic_key ON fact_appointment(clinic_key);
CREATE INDEX idx_fact_date_key ON fact_appointment(date_key);
