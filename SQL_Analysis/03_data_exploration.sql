/*
================================================================================
BREAST CANCER DATA ANALYSIS - DATA EXPLORATION
================================================================================
Purpose: Explore and understand the data
Prerequisites: Run 01_database_setup.sql and 02_data_loading.sql first
================================================================================
*/

USE breast_cancer_db;

-- ============================================================================
-- SECTION 1: BASIC COUNTS
-- ============================================================================

-- 1.1: How many records do we have?
SELECT 
    COUNT(*) AS total_records
FROM raw_breast_cancer_data;

-- 1.2: How many malignant vs benign cases?
SELECT 
    diagnosis,
    COUNT(*) AS count
FROM raw_breast_cancer_data
GROUP BY diagnosis;

-- 1.3: What percentage is each type?
SELECT 
    diagnosis,
    COUNT(*) AS count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM raw_breast_cancer_data), 1) AS percentage
FROM raw_breast_cancer_data
GROUP BY diagnosis;

-- ============================================================================
-- SECTION 2: BASIC STATISTICS
-- ============================================================================

-- 2.1: Average values for key features
SELECT 
    'Average Values' AS stat_type,
    ROUND(AVG(radius_mean), 2) AS avg_radius,
    ROUND(AVG(area_mean), 2) AS avg_area,
    ROUND(AVG(perimeter_mean), 2) AS avg_perimeter
FROM raw_breast_cancer_data;

-- 2.2: Minimum and maximum values
SELECT 
    'Min and Max Values' AS stat_type,
    MIN(radius_mean) AS min_radius,
    MAX(radius_mean) AS max_radius,
    MIN(area_mean) AS min_area,
    MAX(area_mean) AS max_area
FROM raw_breast_cancer_data;

-- ============================================================================
-- SECTION 3: COMPARE MALIGNANT VS BENIGN
-- ============================================================================

-- 3.1: Average radius for malignant vs benign
SELECT 
    diagnosis,
    ROUND(AVG(radius_mean), 2) AS avg_radius,
    ROUND(AVG(area_mean), 2) AS avg_area
FROM raw_breast_cancer_data
GROUP BY diagnosis;

-- 3.2: Which group has larger tumors on average?
SELECT 
    'Comparison' AS analysis,
    ROUND(AVG(CASE WHEN diagnosis = 'M' THEN radius_mean END), 2) AS malignant_avg_radius,
    ROUND(AVG(CASE WHEN diagnosis = 'B' THEN radius_mean END), 2) AS benign_avg_radius,
    ROUND(AVG(CASE WHEN diagnosis = 'M' THEN radius_mean END) - 
          AVG(CASE WHEN diagnosis = 'B' THEN radius_mean END), 2) AS difference
FROM raw_breast_cancer_data;

-- ============================================================================
-- SECTION 4: LOOK AT SPECIFIC RECORDS
-- ============================================================================

-- 4.1: Show some examples of malignant cases
SELECT 
    id,
    diagnosis,
    radius_mean,
    area_mean,
    concavity_mean
FROM raw_breast_cancer_data
WHERE diagnosis = 'M'
LIMIT 5;

-- 4.2: Show some examples of benign cases
SELECT 
    id,
    diagnosis,
    radius_mean,
    area_mean,
    concavity_mean
FROM raw_breast_cancer_data
WHERE diagnosis = 'B'
LIMIT 5;

-- ============================================================================
-- SECTION 5: SUMMARY
-- ============================================================================

SELECT 
    '=== EXPLORATION SUMMARY ===' AS summary,
    '' AS details
UNION ALL
SELECT 
    'Total Records',
    CAST(COUNT(*) AS CHAR)
FROM raw_breast_cancer_data
UNION ALL
SELECT 
    'Malignant Cases',
    CAST(SUM(CASE WHEN diagnosis = 'M' THEN 1 ELSE 0 END) AS CHAR)
FROM raw_breast_cancer_data
UNION ALL
SELECT 
    'Benign Cases',
    CAST(SUM(CASE WHEN diagnosis = 'B' THEN 1 ELSE 0 END) AS CHAR)
FROM raw_breast_cancer_data;
