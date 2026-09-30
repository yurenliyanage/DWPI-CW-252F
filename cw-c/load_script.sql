-- load_script.sql
-- Load dimension tables first to avoid foreign key violations, then load the fact table

\copy dim_patient(patient_sk, patient_id, gender, date_of_birth, home_district) FROM 'data/dim_patient.csv' WITH (FORMAT csv, HEADER true);

\copy dim_doctor(doctor_sk, doctor_id, doctor_name, specialty) FROM 'data/dim_doctor.csv' WITH (FORMAT csv, HEADER true);

\copy dim_clinic(clinic_sk, clinic_id, clinic_name, city, province) FROM 'data/dim_clinic.csv' WITH (FORMAT csv, HEADER true);

\copy dim_date(date_sk, full_date, year, quarter, month, day_name) FROM 'data/dim_date.csv' WITH (FORMAT csv, HEADER true);

\copy fact_appointment(appointment_id, patient_sk, doctor_sk, clinic_sk, date_sk, wait_minutes, consultation_minutes, fee_lkr) FROM 'data/fact_appointment.csv' WITH (FORMAT csv, HEADER true);