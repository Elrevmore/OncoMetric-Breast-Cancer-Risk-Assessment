/*
================================================================================
BREAST CANCER DATA ANALYSIS PROJECT - DATABASE SETUP
================================================================================

WHAT WE'RE DOING:
We're creating a database to store breast cancer patient data.
We'll have one table for raw data and one for cleaned data.
================================================================================
*/

-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS breast_cancer_db;

-- Step 2: Tell MySQL to use this database
USE breast_cancer_db;

-- Step 3: Create a table to store the raw data
CREATE TABLE IF NOT EXISTS raw_breast_cancer_data (
    id BIGINT PRIMARY KEY,
    -- Diagnosis: 'M' = Malignant (cancerous), 'B' = Benign (not cancerous)
    diagnosis VARCHAR(1) NOT NULL,
    radius_mean DECIMAL(10,4),
    texture_mean DECIMAL(10,4),
    perimeter_mean DECIMAL(10,4),
    area_mean DECIMAL(10,4),
    smoothness_mean DECIMAL(10,4),
    compactness_mean DECIMAL(10,4),
    concavity_mean DECIMAL(10,4),
    concave_points_mean DECIMAL(10,4),
    symmetry_mean DECIMAL(10,4),
    fractal_dimension_mean DECIMAL(10,4),
    radius_se DECIMAL(10,4),
    texture_se DECIMAL(10,4),
    perimeter_se DECIMAL(10,4),
    area_se DECIMAL(10,4),
    smoothness_se DECIMAL(10,4),
    compactness_se DECIMAL(10,4),
    concavity_se DECIMAL(10,4),
    concave_points_se DECIMAL(10,4),
    symmetry_se DECIMAL(10,4),
    fractal_dimension_se DECIMAL(10,4),
    radius_worst DECIMAL(10,4),
    texture_worst DECIMAL(10,4),
    perimeter_worst DECIMAL(10,4),
    area_worst DECIMAL(10,4),
    smoothness_worst DECIMAL(10,4),
    compactness_worst DECIMAL(10,4),
    concavity_worst DECIMAL(10,4),
    concave_points_worst DECIMAL(10,4),
    symmetry_worst DECIMAL(10,4),
    fractal_dimension_worst DECIMAL(10,4),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Step 4: Create a table for cleaned data
CREATE TABLE IF NOT EXISTS cleaned_breast_cancer_data (
    id BIGINT PRIMARY KEY,
    diagnosis VARCHAR(1) NOT NULL,
    radius_mean DECIMAL(10,4),
    texture_mean DECIMAL(10,4),
    perimeter_mean DECIMAL(10,4),
    area_mean DECIMAL(10,4),
    smoothness_mean DECIMAL(10,4),
    compactness_mean DECIMAL(10,4),
    concavity_mean DECIMAL(10,4),
    concave_points_mean DECIMAL(10,4),
    symmetry_mean DECIMAL(10,4),
    fractal_dimension_mean DECIMAL(10,4),
    radius_se DECIMAL(10,4),
    texture_se DECIMAL(10,4),
    perimeter_se DECIMAL(10,4),
    area_se DECIMAL(10,4),
    smoothness_se DECIMAL(10,4),
    compactness_se DECIMAL(10,4),
    concavity_se DECIMAL(10,4),
    concave_points_se DECIMAL(10,4),
    symmetry_se DECIMAL(10,4),
    fractal_dimension_se DECIMAL(10,4),
    radius_worst DECIMAL(10,4),
    texture_worst DECIMAL(10,4),
    perimeter_worst DECIMAL(10,4),
    area_worst DECIMAL(10,4),
    smoothness_worst DECIMAL(10,4),
    compactness_worst DECIMAL(10,4),
    concavity_worst DECIMAL(10,4),
    concave_points_worst DECIMAL(10,4),
    symmetry_worst DECIMAL(10,4),
    fractal_dimension_worst DECIMAL(10,4),
    cleaning_notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Step 5: Create indexes to make queries faster
CREATE INDEX idx_diagnosis ON raw_breast_cancer_data(diagnosis);
CREATE INDEX idx_diagnosis_cleaned ON cleaned_breast_cancer_data(diagnosis);

-- Step 6: Check if everything was created successfully
SELECT 
    'Database Setup Complete!' AS status,
    COUNT(*) AS tables_created
FROM information_schema.tables 
WHERE table_schema = 'breast_cancer_db';

