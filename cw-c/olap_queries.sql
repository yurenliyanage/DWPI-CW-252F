-- ==========================================
-- DWBI Coursework Part C - Task 5: OLAP Queries
-- Database: clinic_dw
-- ==========================================

-- ------------------------------------------
-- 1. SLICE (1 Mark)
-- Fix one dimension to a single value: Filter strictly for Clinic 'C01' (Lotus Care Colombo).
-- Business Question: What is the total revenue and volume generated across specialties at the main Colombo clinic?
-- ------------------------------------------
SELECT 
    c.clinic_name,
    d.specialty,
    COUNT(f.appointment_id) AS total_appointments,
    SUM(f.fee_lkr) AS total_revenue_lkr
FROM fact_appointment f
JOIN dim_clinic c ON f.clinic_sk = c.clinic_sk
JOIN dim_doctor d ON f.doctor_sk = d.doctor_sk
WHERE c.clinic_id = 'C01'
GROUP BY c.clinic_name, d.specialty
ORDER BY total_revenue_lkr DESC;


-- ------------------------------------------
-- 2. DICE (1 Mark)
-- Restrict two or more dimensions: Specialty IN ('Cardiology', 'Dermatology') AND City = 'Galle'.
-- Business Question: How many appointments and revenue did Cardiology and Dermatology generate specifically in Galle?
-- ------------------------------------------
SELECT 
    c.city,
    d.specialty,
    COUNT(f.appointment_id) AS total_appointments,
    SUM(f.fee_lkr) AS total_revenue_lkr
FROM fact_appointment f
JOIN dim_doctor d ON f.doctor_sk = d.doctor_sk
JOIN dim_clinic c ON f.clinic_sk = c.clinic_sk
WHERE d.specialty IN ('Cardiology', 'Dermatology')
  AND c.city = 'Galle'
GROUP BY c.city, d.specialty;


-- ------------------------------------------
-- 3. ROLL-UP (1 Mark)
-- Summarise from doctor to specialty to a grand total using GROUP BY ROLLUP.
-- Business Question: What is the revenue breakdown at the individual doctor level rolled up to medical specialty and overall clinic totals?
-- ------------------------------------------
SELECT 
    COALESCE(d.specialty, '--- ALL SPECIALTIES (GRAND TOTAL) ---') AS specialty,
    COALESCE(d.doctor_name, '--- SPECIALTY SUBTOTAL ---') AS doctor_name,
    COUNT(f.appointment_id) AS total_appointments,
    SUM(f.fee_lkr) AS total_revenue_lkr
FROM fact_appointment f
JOIN dim_doctor d ON f.doctor_sk = d.doctor_sk
GROUP BY ROLLUP(d.specialty, d.doctor_name)
ORDER BY d.specialty NULLS LAST, d.doctor_name NULLS LAST;


-- ------------------------------------------
-- 4. DRILL-DOWN (1 Mark)
-- Query 4a: High-Level (Totals by Quarter)
-- Business Question: What is the total revenue trends across all four quarters of 2025?
-- ------------------------------------------
SELECT 
    dt.quarter,
    COUNT(f.appointment_id) AS total_appointments,
    SUM(f.fee_lkr) AS total_revenue_lkr
FROM fact_appointment f
JOIN dim_date dt ON f.date_sk = dt.date_sk
GROUP BY dt.quarter
ORDER BY dt.quarter;

-- Query 4b: Drilled-Down Level (Monthly breakdown inside Quarter 2)
-- Business Question: Within Quarter 2, what is the monthly breakdown of appointment performance?
SELECT 
    dt.quarter,
    dt.month,
    COUNT(f.appointment_id) AS total_appointments,
    SUM(f.fee_lkr) AS total_revenue_lkr
FROM fact_appointment f
JOIN dim_date dt ON f.date_sk = dt.date_sk
WHERE dt.quarter = 2
GROUP BY dt.quarter, dt.month
ORDER BY dt.month;


-- ------------------------------------------
-- 5. PIVOT (1 Mark)
-- Turn values of one dimension into columns: One column per Quarter (Q1, Q2, Q3, Q4) per Specialty.
-- Business Question: How does revenue per medical specialty distribute across each quarter of the year in side-by-side columns?
-- ------------------------------------------
SELECT 
    d.specialty,
    SUM(CASE WHEN dt.quarter = 1 THEN f.fee_lkr ELSE 0 END) AS q1_revenue_lkr,
    SUM(CASE WHEN dt.quarter = 2 THEN f.fee_lkr ELSE 0 END) AS q2_revenue_lkr,
    SUM(CASE WHEN dt.quarter = 3 THEN f.fee_lkr ELSE 0 END) AS q3_revenue_lkr,
    SUM(CASE WHEN dt.quarter = 4 THEN f.fee_lkr ELSE 0 END) AS q4_revenue_lkr,
    SUM(f.fee_lkr) AS total_year_revenue_lkr
FROM fact_appointment f
JOIN dim_doctor d ON f.doctor_sk = d.doctor_sk
JOIN dim_date dt ON f.date_sk = dt.date_sk
GROUP BY d.specialty
ORDER BY total_year_revenue_lkr DESC;