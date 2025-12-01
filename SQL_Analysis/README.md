# Breast Cancer Data Analysis - SQL Project

[![SQL](https://img.shields.io/badge/SQL-MySQL-blue)](https://www.mysql.com/)
[![Level](https://img.shields.io/badge/Level-Entry--Intermediate-green)](https://github.com)

## 📋 Project Overview

A beginner-friendly SQL project for analyzing breast cancer data. This project teaches you how to use SQL for data analysis, from loading data to preparing it for further analysis.

**Dataset**: Breast Cancer Wisconsin (Diagnostic) Dataset  
**Records**: 569 samples  
**Features**: 30 numerical features  
**Target**: Diagnosis (M = Malignant, B = Benign)

### What You'll Learn

- ✅ How to create databases and tables in SQL
- ✅ How to load CSV data into MySQL
- ✅ Basic data exploration and statistics
- ✅ Data cleaning techniques
- ✅ Creating new features from existing data
- ✅ Preparing data for analysis

---

## 🚀 Quick Start

### Prerequisites

- **MySQL 8.0+** or **MariaDB 10.3+**
- **Python 3.7+** (optional, for ML models)
- Basic SQL knowledge (SELECT, INSERT, UPDATE)
- The `data.csv` file in the project folder

### Installation

1. **Install MySQL** (if needed)
   - Download from [mysql.com](https://dev.mysql.com/downloads/mysql/)

2. **Start MySQL**
   ```bash
   mysql -u root -p
   ```

3. **Navigate to project folder**
   ```bash
   cd "path/to/Breast Cancer Project"
   ```

### Running the Project

**Option 1: Run all scripts at once**
```sql
source 00_run_all.sql;
```

**Option 2: Run scripts one by one** (recommended for learning)
```sql
source 01_database_setup.sql;
source 02_data_loading.sql;
source 03_data_exploration.sql;
source 04_data_cleaning.sql;
source 05_feature_engineering.sql;
source 06_data_modeling.sql;
```

**Option 3: Train ML models** (after running SQL scripts)
```bash
# Install Python dependencies
pip install -r requirements.txt

# Edit 07_ml_models.py and set your MySQL password
# Then run:
python 07_ml_models.py
```

---

## 📁 Project Structure

```
Breast Cancer Project/
│
├── data.csv                    # The dataset
├── 00_run_all.sql             # Run everything at once
├── 01_database_setup.sql      # Create database and tables
├── 02_data_loading.sql        # Load data from CSV
├── 03_data_exploration.sql    # Explore the data
├── 04_data_cleaning.sql       # Clean the data
├── 05_feature_engineering.sql # Create new features
├── 06_data_modeling.sql       # Prepare data for analysis
├── 07_ml_models.py           # Train ML models (Python)
├── README.md                  # This file
├── QUICK_START.md            # Quick reference
└── requirements.txt          # Python dependencies
```

---

## 📚 What Each Script Does

### 01_database_setup.sql
- Creates the database
- Creates tables to store data
- Sets up indexes for faster queries

### 02_data_loading.sql
- Loads data from CSV file
- Checks if data loaded correctly
- Shows basic statistics

### 03_data_exploration.sql
- Counts records
- Calculates averages and statistics
- Compares malignant vs benign cases

### 04_data_cleaning.sql
- Copies data to cleaned table
- Fixes missing values
- Checks for data problems

### 05_feature_engineering.sql
- Creates new features (columns)
- Calculates ratios and spreads
- Adds risk flags

### 06_data_modeling.sql
- Splits data into training and test sets
- Identifies important features
- Creates view for data export

### 07_ml_models.py (Optional)
- Trains Logistic Regression model
- Trains Decision Tree model
- Evaluates and compares models
- Saves predictions and results

---

## 🎯 Key Results

- **Total Records**: 569
- **Malignant Cases**: ~212 (37%)
- **Benign Cases**: ~357 (63%)
- **New Features Created**: 4
- **Data Quality**: 100% complete after cleaning

---

## 💡 SQL Concepts Used

- `CREATE DATABASE` / `CREATE TABLE`
- `INSERT INTO` / `SELECT`
- `UPDATE` / `ALTER TABLE`
- `GROUP BY` / `COUNT` / `AVG`
- `CASE WHEN` (conditional logic)
- `JOIN` (combining tables)
- `VIEW` (saved queries)

---

## 🔧 Troubleshooting

### Problem: "LOAD DATA INFILE" doesn't work

**Solution**: 
1. Make sure you're in the project directory
2. Or use the Python script: `python load_data_alternative.py`
3. Or change the file path in `02_data_loading.sql`

### Problem: "Duplicate column name" error

**Solution**: The column already exists. Either:
- Ignore the error and continue
- Or drop the column first: `ALTER TABLE cleaned_breast_cancer_data DROP COLUMN column_name;`

---

## 📖 Learning Resources

- [MySQL Tutorial](https://www.mysqltutorial.org/)
- [SQL Basics](https://www.w3schools.com/sql/)
- [Data Analysis with SQL](https://mode.com/sql-tutorial/)

---

## 👤 Author

**Merve Lavinya EROL**

Entry-level SQL data analysis project | November 2025

---

## 📄 License

This project is for educational purposes. The dataset is from UCI Machine Learning Repository.

---

**Happy Learning! 🎓**

*This project is designed for beginners learning SQL for data analysis. Each script includes comments explaining what's happening and why.*
