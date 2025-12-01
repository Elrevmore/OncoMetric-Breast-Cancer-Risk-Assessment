/*
================================================================================
BREAST CANCER DATA ANALYSIS - DATA LOADING
================================================================================
Purpose: Load data from CSV file into our database
Prerequisites: Run 01_database_setup.sql first
================================================================================
*/

USE breast_cancer_db;

-- Step 1: Load data from CSV file
-- IMPORTANT: If you get an error, try these:
-- 1. Make sure you're running MySQL from the project folder
-- 2. Or change './data.csv' to the full path like 'C:/Users/YourName/Desktop/Breast Cancer Project/data.csv'
-- 3. You might need to run: SET GLOBAL local_infile = 1; first
-- 4. Or use the Python script: python load_data_alternative.py

LOAD DATA LOCAL INFILE './data.csv'
INTO TABLE raw_breast_cancer_data
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'   
LINES TERMINATED BY '\n'
IGNORE 1 ROWS 
(
    id, diagnosis,
    radius_mean, texture_mean, perimeter_mean, area_mean,
    smoothness_mean, compactness_mean, concavity_mean, concave_points_mean,
    symmetry_mean, fractal_dimension_mean,
    radius_se, texture_se, perimeter_se, area_se,
    smoothness_se, compactness_se, concavity_se, concave_points_se,
    symmetry_se, fractal_dimension_se,
    radius_worst, texture_worst, perimeter_worst, area_worst,
    smoothness_worst, compactness_worst, concavity_worst, concave_points_worst,
    symmetry_worst, fractal_dimension_worst
);

-- Step 2: Check if data loaded correctly
SELECT 
    'Data Loading Check' AS check_type,
    COUNT(*) AS total_records,
    SUM(CASE WHEN diagnosis = 'M' THEN 1 ELSE 0 END) AS malignant_count,
    SUM(CASE WHEN diagnosis = 'B' THEN 1 ELSE 0 END) AS benign_count
FROM raw_breast_cancer_data;

-- Step 3: Look at a few sample records
SELECT 
    id,
    diagnosis,
    radius_mean,
    area_mean
FROM raw_breast_cancer_data
LIMIT 5;

-- Step 4: Check for any missing values
SELECT 
    'Missing Values Check' AS check_type,
    SUM(CASE WHEN diagnosis IS NULL THEN 1 ELSE 0 END) AS missing_diagnosis,
    SUM(CASE WHEN radius_mean IS NULL THEN 1 ELSE 0 END) AS missing_radius
FROM raw_breast_cancer_data;

-- Done! Data is loaded
SELECT 'Data Loading Complete!' AS status;

