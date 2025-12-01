/*
================================================================================
BREAST CANCER DATA ANALYSIS - RUN ALL SCRIPTS
================================================================================
Purpose: Run all project scripts in order
Usage: source 00_run_all.sql;

This script runs all steps:
1. Create database and tables
2. Load data from CSV
3. Explore the data
4. Clean the data
5. Create new features
6. Prepare data for analysis
================================================================================
*/

-- Enable local file loading (needed for CSV import)
SET GLOBAL local_infile = 1;

-- Display start message
SELECT '========================================' AS '';
SELECT 'BREAST CANCER DATA ANALYSIS PROJECT' AS '';
SELECT 'Starting...' AS '';
SELECT '========================================' AS '';

-- Step 1: Create database and tables
SELECT 'Step 1: Creating database...' AS status;
SOURCE 01_database_setup.sql;

-- Step 2: Load data
SELECT 'Step 2: Loading data...' AS status;
SOURCE 02_data_loading.sql;

-- Step 3: Explore data
SELECT 'Step 3: Exploring data...' AS status;
SOURCE 03_data_exploration.sql;

-- Step 4: Clean data
SELECT 'Step 4: Cleaning data...' AS status;
SOURCE 04_data_cleaning.sql;

-- Step 5: Create features
SELECT 'Step 5: Creating features...' AS status;
SOURCE 05_feature_engineering.sql;

-- Step 6: Prepare for analysis
SELECT 'Step 6: Preparing data...' AS status;
SOURCE 06_data_modeling.sql;

-- Done!
SELECT '========================================' AS '';
SELECT 'ALL STEPS COMPLETE!' AS '';
SELECT '========================================' AS '';
SELECT 'Check the output above to see results from each step.' AS note;

