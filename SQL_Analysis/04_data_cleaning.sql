/*
================================================================================
BREAST CANCER DATA ANALYSIS - DATA CLEANING
================================================================================
Purpose: Clean the data and fix any problems
Prerequisites: Run scripts 01-03 first
================================================================================
*/

USE breast_cancer_db;

-- ============================================================================
-- SECTION 1: COPY DATA TO CLEANED TABLE
-- ============================================================================

-- Step 1: Copy all data from raw table to cleaned table
INSERT INTO cleaned_breast_cancer_data (
    id, diagnosis,
    radius_mean, texture_mean, perimeter_mean, area_mean,
    smoothness_mean, compactness_mean, concavity_mean, concave_points_mean,
    symmetry_mean, fractal_dimension_mean,
    radius_se, texture_se, perimeter_se, area_se,
    smoothness_se, compactness_se, concavity_se, concave_points_se,
    symmetry_se, fractal_dimension_se,
    radius_worst, texture_worst, perimeter_worst, area_worst,
    smoothness_worst, compactness_worst, concavity_worst, concave_points_worst,
    symmetry_worst, fractal_dimension_worst,
    cleaning_notes
)
SELECT 
    id, diagnosis,
    radius_mean, texture_mean, perimeter_mean, area_mean,
    smoothness_mean, compactness_mean, concavity_mean, concave_points_mean,
    symmetry_mean, fractal_dimension_mean,
    radius_se, texture_se, perimeter_se, area_se,
    smoothness_se, compactness_se, concavity_se, concave_points_se,
    symmetry_se, fractal_dimension_se,
    radius_worst, texture_worst, perimeter_worst, area_worst,
    smoothness_worst, compactness_worst, concavity_worst, concave_points_worst,
    symmetry_worst, fractal_dimension_worst,
    'Copied from raw data' AS cleaning_notes
FROM raw_breast_cancer_data;

-- ============================================================================
-- SECTION 2: CHECK FOR PROBLEMS
-- ============================================================================

-- Step 2: Check for missing values
SELECT 
    'Missing Values' AS check_type,
    SUM(CASE WHEN radius_mean IS NULL THEN 1 ELSE 0 END) AS missing_radius,
    SUM(CASE WHEN area_mean IS NULL THEN 1 ELSE 0 END) AS missing_area
FROM cleaned_breast_cancer_data;

-- Step 3: Check for impossible values (negative numbers)
SELECT 
    'Invalid Values' AS check_type,
    SUM(CASE WHEN radius_mean < 0 THEN 1 ELSE 0 END) AS negative_radius,
    SUM(CASE WHEN area_mean < 0 THEN 1 ELSE 0 END) AS negative_area
FROM cleaned_breast_cancer_data;

-- ============================================================================
-- SECTION 3: FIX PROBLEMS (if any)
-- ============================================================================
-- Step 4: If there are missing values, fill them with the average
UPDATE cleaned_breast_cancer_data
SET 
    radius_mean = COALESCE(radius_mean, (SELECT AVG(radius_mean) FROM cleaned_breast_cancer_data)),
    area_mean = COALESCE(area_mean, (SELECT AVG(area_mean) FROM cleaned_breast_cancer_data)),
    cleaning_notes = CONCAT(COALESCE(cleaning_notes, ''), '; Fixed missing values')
WHERE radius_mean IS NULL OR area_mean IS NULL;

-- Step 5: Make sure diagnosis is uppercase and has no spaces
UPDATE cleaned_breast_cancer_data
SET 
    diagnosis = UPPER(TRIM(diagnosis));

-- ============================================================================
-- SECTION 4: VERIFY CLEANING
-- ============================================================================

-- Step 6: Check how many records we have after cleaning
SELECT 
    'Cleaning Complete!' AS status,
    COUNT(*) AS total_records,
    SUM(CASE WHEN diagnosis = 'M' THEN 1 ELSE 0 END) AS malignant_count,
    SUM(CASE WHEN diagnosis = 'B' THEN 1 ELSE 0 END) AS benign_count
FROM cleaned_breast_cancer_data;

-- Step 7: Show a sample of cleaned data
SELECT 
    id,
    diagnosis,
    radius_mean,
    area_mean
FROM cleaned_breast_cancer_data
LIMIT 5;
