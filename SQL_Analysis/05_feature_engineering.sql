/*
================================================================================
BREAST CANCER DATA ANALYSIS - FEATURE ENGINEERING
================================================================================
Purpose: Create new features from existing data
Prerequisites: Run scripts 01-04 first
================================================================================
*/

USE breast_cancer_db;

-- ============================================================================
-- SECTION 1: CREATE RATIO FEATURES
-- ============================================================================
-- Feature 1: Perimeter to Area Ratio
-- First, add a new column
ALTER TABLE cleaned_breast_cancer_data
ADD COLUMN perimeter_to_area_ratio DECIMAL(10,4);

-- Then calculate the ratio for each row
-- We use CASE to avoid dividing by zero
UPDATE cleaned_breast_cancer_data
SET perimeter_to_area_ratio = 
    CASE 
        WHEN area_mean > 0 THEN (perimeter_mean * perimeter_mean) / area_mean
        ELSE NULL
    END;

-- ============================================================================
-- SECTION 2: CREATE SPREAD FEATURES
-- ============================================================================

-- Feature 2: Radius Spread
ALTER TABLE cleaned_breast_cancer_data
ADD COLUMN radius_spread DECIMAL(10,4);

UPDATE cleaned_breast_cancer_data
SET radius_spread = radius_worst - radius_mean;

-- Feature 3: Area Spread
ALTER TABLE cleaned_breast_cancer_data
ADD COLUMN area_spread DECIMAL(10,4);

UPDATE cleaned_breast_cancer_data
SET area_spread = area_worst - area_mean;

-- ============================================================================
-- SECTION 3: CREATE RISK FLAGS
-- ============================================================================

-- Feature 4: High Risk Flag
ALTER TABLE cleaned_breast_cancer_data
ADD COLUMN high_risk_flag TINYINT(1) DEFAULT 0;

-- Calculate average and standard deviation first
SET @avg_radius = (SELECT AVG(radius_mean) FROM cleaned_breast_cancer_data);
SET @avg_concavity = (SELECT AVG(concavity_mean) FROM cleaned_breast_cancer_data);
SET @std_radius = (SELECT STDDEV(radius_mean) FROM cleaned_breast_cancer_data);
SET @std_concavity = (SELECT STDDEV(concavity_mean) FROM cleaned_breast_cancer_data);

-- Flag cases where both radius and concavity are above average
UPDATE cleaned_breast_cancer_data
SET high_risk_flag = CASE 
    WHEN radius_mean > (@avg_radius + @std_radius) 
     AND concavity_mean > (@avg_concavity + @std_concavity)
    THEN 1 
    ELSE 0 
END;

-- ============================================================================
-- SECTION 4: SUMMARY
-- ============================================================================

-- Let's see what we created
SELECT 
    'Feature Engineering Complete!' AS status,
    COUNT(*) AS total_records,
    AVG(perimeter_to_area_ratio) AS avg_perimeter_area_ratio,
    AVG(radius_spread) AS avg_radius_spread,
    SUM(high_risk_flag) AS high_risk_cases
FROM cleaned_breast_cancer_data;

-- Show some examples with new features
SELECT 
    id,
    diagnosis,
    radius_mean,
    perimeter_to_area_ratio,
    radius_spread,
    high_risk_flag
FROM cleaned_breast_cancer_data
LIMIT 10;
