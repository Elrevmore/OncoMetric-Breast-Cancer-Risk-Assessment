/*
================================================================================
BREAST CANCER DATA ANALYSIS - DATA PREPARATION
================================================================================
Purpose: Prepare data for analysis and create train/test split
Prerequisites: Run scripts 01-05 first
================================================================================
*/

USE breast_cancer_db;

-- ============================================================================
-- SECTION 1: CREATE TRAIN/TEST SPLIT
-- ============================================================================

-- Step 1: Create a table to track which records are in training vs test
CREATE TABLE IF NOT EXISTS train_test_split (
    id BIGINT PRIMARY KEY,
    dataset_type VARCHAR(10) NOT NULL,  -- 'train' or 'test'
    FOREIGN KEY (id) REFERENCES cleaned_breast_cancer_data(id)
);

-- Step 2: Split data 80% training, 20% test
-- First, get counts for each diagnosis type
SET @total_malignant = (SELECT COUNT(*) FROM cleaned_breast_cancer_data WHERE diagnosis = 'M');
SET @total_benign = (SELECT COUNT(*) FROM cleaned_breast_cancer_data WHERE diagnosis = 'B');
SET @train_malignant = FLOOR(@total_malignant * 0.8);  -- 80% of malignant
SET @train_benign = FLOOR(@total_benign * 0.8);        -- 80% of benign

-- Insert training set (80% of each type)
INSERT INTO train_test_split (id, dataset_type)
SELECT id, 'train'
FROM (
    -- Get 80% of malignant cases (randomly)
    SELECT id FROM cleaned_breast_cancer_data 
    WHERE diagnosis = 'M' 
    ORDER BY RAND()
    LIMIT @train_malignant
    
    UNION ALL
    
    -- Get 80% of benign cases (randomly)
    SELECT id FROM cleaned_breast_cancer_data 
    WHERE diagnosis = 'B' 
    ORDER BY RAND()
    LIMIT @train_benign
) AS train_ids;

-- Insert test set (the remaining 20%)
INSERT INTO train_test_split (id, dataset_type)
SELECT id, 'test'
FROM cleaned_breast_cancer_data
WHERE id NOT IN (SELECT id FROM train_test_split WHERE dataset_type = 'train');

-- Step 3: Check the split
SELECT 
    dataset_type,
    COUNT(*) AS count,
    SUM(CASE WHEN c.diagnosis = 'M' THEN 1 ELSE 0 END) AS malignant,
    SUM(CASE WHEN c.diagnosis = 'B' THEN 1 ELSE 0 END) AS benign
FROM train_test_split t
JOIN cleaned_breast_cancer_data c ON t.id = c.id
GROUP BY dataset_type;

-- ============================================================================
-- SECTION 2: FIND IMPORTANT FEATURES
-- ============================================================================

-- Step 4: Compare average values between malignant and benign
-- Features with big differences are more useful for prediction
SELECT 
    'Feature Comparison' AS analysis,
    ROUND(AVG(CASE WHEN diagnosis = 'M' THEN radius_mean END), 2) AS malignant_avg_radius,
    ROUND(AVG(CASE WHEN diagnosis = 'B' THEN radius_mean END), 2) AS benign_avg_radius,
    ROUND(AVG(CASE WHEN diagnosis = 'M' THEN radius_mean END) - 
          AVG(CASE WHEN diagnosis = 'B' THEN radius_mean END), 2) AS difference_radius,
    ROUND(AVG(CASE WHEN diagnosis = 'M' THEN concavity_mean END), 2) AS malignant_avg_concavity,
    ROUND(AVG(CASE WHEN diagnosis = 'B' THEN concavity_mean END), 2) AS benign_avg_concavity,
    ROUND(AVG(CASE WHEN diagnosis = 'M' THEN concavity_mean END) - 
          AVG(CASE WHEN diagnosis = 'B' THEN concavity_mean END), 2) AS difference_concavity
FROM cleaned_breast_cancer_data;

-- ============================================================================
-- SECTION 3: CREATE VIEW FOR EXPORT
-- ============================================================================

-- Step 5: Create a view with all features ready for export
CREATE OR REPLACE VIEW ml_ready_data AS
SELECT 
    c.id,
    c.diagnosis,
    -- Original features
    c.radius_mean, c.texture_mean, c.area_mean, c.perimeter_mean,
    c.concavity_mean, c.compactness_mean,
    -- Engineered features
    c.perimeter_to_area_ratio,
    c.radius_spread,
    c.area_spread,
    c.high_risk_flag,
    -- Which dataset (train or test)
    COALESCE(t.dataset_type, 'unassigned') AS dataset_type
FROM cleaned_breast_cancer_data c
LEFT JOIN train_test_split t ON c.id = t.id;

-- Step 6: Show training data (for export to Python/R)
SELECT * FROM ml_ready_data WHERE dataset_type = 'train' LIMIT 10;

-- Step 7: Show test data
SELECT * FROM ml_ready_data WHERE dataset_type = 'test' LIMIT 10;

-- ============================================================================
-- SECTION 4: FINAL SUMMARY
-- ============================================================================

SELECT 
    '=== PROJECT SUMMARY ===' AS summary,
    '' AS details
UNION ALL
SELECT 
    'Total Records',
    CAST(COUNT(*) AS CHAR)
FROM cleaned_breast_cancer_data
UNION ALL
SELECT 
    'Training Set Size',
    CAST((SELECT COUNT(*) FROM train_test_split WHERE dataset_type = 'train') AS CHAR)
UNION ALL
SELECT 
    'Test Set Size',
    CAST((SELECT COUNT(*) FROM train_test_split WHERE dataset_type = 'test') AS CHAR)
UNION ALL
SELECT 
    'Malignant Cases',
    CAST(SUM(CASE WHEN diagnosis = 'M' THEN 1 ELSE 0 END) AS CHAR)
FROM cleaned_breast_cancer_data
UNION ALL
SELECT 
    'Benign Cases',
    CAST(SUM(CASE WHEN diagnosis = 'B' THEN 1 ELSE 0 END) AS CHAR)
FROM cleaned_breast_cancer_data;

SELECT 'Data Preparation Complete! Ready for analysis.' AS status;
