"""
Alternative Data Loading Script for Breast Cancer Project
==========================================================
Purpose: Load CSV data into MySQL database when LOAD DATA INFILE doesn't work

WHY WE DO THIS:
Some MySQL configurations don't allow LOAD DATA INFILE due to security settings.
This Python script provides an alternative method using pandas and mysql-connector.

Prerequisites:
- pip install pandas mysql-connector-python
- MySQL server running
- Database created (run 01_database_setup.sql first)
"""

import pandas as pd
import mysql.connector
from mysql.connector import Error
import os

# Configuration - UPDATE THESE VALUES
DB_CONFIG = {
    'host': 'localhost',
    'database': 'breast_cancer_db',
    'user': 'root',
    'password': 'your_password_here'  # Change this!
}

CSV_FILE = 'data.csv'  # Path to your CSV file

def load_data_to_mysql():
    """
    Load CSV data into MySQL database.
    
    WHY: This function reads the CSV file and inserts each row into the database.
    It's slower than LOAD DATA INFILE but more compatible across systems.
    """
    
    # Step 1: Read CSV file
    # WHY: pandas makes CSV reading easy and handles encoding issues
    print("Reading CSV file...")
    try:
        df = pd.read_csv(CSV_FILE)
        print(f"✓ Loaded {len(df)} records from CSV")
    except FileNotFoundError:
        print(f"ERROR: File '{CSV_FILE}' not found!")
        print("Please ensure the CSV file is in the same directory as this script.")
        return False
    except Exception as e:
        print(f"ERROR reading CSV: {e}")
        return False
    
    # Step 2: Connect to MySQL
    # WHY: Need database connection to insert data
    print("Connecting to MySQL database...")
    connection = None
    try:
        connection = mysql.connector.connect(**DB_CONFIG)
        if connection.is_connected():
            print("✓ Connected to MySQL database")
    except Error as e:
        print(f"ERROR connecting to MySQL: {e}")
        print("\nTroubleshooting:")
        print("1. Make sure MySQL server is running")
        print("2. Check your database credentials in DB_CONFIG")
        print("3. Ensure database 'breast_cancer_db' exists (run 01_database_setup.sql first)")
        return False
    
    # Step 3: Clear existing data (optional)
    # WHY: Allows re-running the script without duplicates
    cursor = connection.cursor()
    try:
        cursor.execute("DELETE FROM raw_breast_cancer_data")
        connection.commit()
        print("✓ Cleared existing data")
    except Error as e:
        print(f"Warning: Could not clear existing data: {e}")
    
    # Step 4: Insert data row by row
    # WHY: Insert each row individually (slower but reliable)
    print("Inserting data into database...")
    
    # Prepare SQL insert statement
    # WHY: Using parameterized queries prevents SQL injection
    insert_query = """
    INSERT INTO raw_breast_cancer_data (
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
    ) VALUES (
        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
        %s, %s, %s, %s, %s, %s, %s, %s, %s, %s,
        %s, %s
    )
    """
    
    # Insert rows
    inserted_count = 0
    error_count = 0
    
    for index, row in df.iterrows():
        try:
            # Convert row to tuple
            # WHY: MySQL connector requires tuple format
            values = (
                int(row['id']),
                str(row['diagnosis']),
                float(row['radius_mean']) if pd.notna(row['radius_mean']) else None,
                float(row['texture_mean']) if pd.notna(row['texture_mean']) else None,
                float(row['perimeter_mean']) if pd.notna(row['perimeter_mean']) else None,
                float(row['area_mean']) if pd.notna(row['area_mean']) else None,
                float(row['smoothness_mean']) if pd.notna(row['smoothness_mean']) else None,
                float(row['compactness_mean']) if pd.notna(row['compactness_mean']) else None,
                float(row['concavity_mean']) if pd.notna(row['concavity_mean']) else None,
                float(row['concave points_mean']) if pd.notna(row['concave points_mean']) else None,
                float(row['symmetry_mean']) if pd.notna(row['symmetry_mean']) else None,
                float(row['fractal_dimension_mean']) if pd.notna(row['fractal_dimension_mean']) else None,
                float(row['radius_se']) if pd.notna(row['radius_se']) else None,
                float(row['texture_se']) if pd.notna(row['texture_se']) else None,
                float(row['perimeter_se']) if pd.notna(row['perimeter_se']) else None,
                float(row['area_se']) if pd.notna(row['area_se']) else None,
                float(row['smoothness_se']) if pd.notna(row['smoothness_se']) else None,
                float(row['compactness_se']) if pd.notna(row['compactness_se']) else None,
                float(row['concavity_se']) if pd.notna(row['concavity_se']) else None,
                float(row['concave points_se']) if pd.notna(row['concave points_se']) else None,
                float(row['symmetry_se']) if pd.notna(row['symmetry_se']) else None,
                float(row['fractal_dimension_se']) if pd.notna(row['fractal_dimension_se']) else None,
                float(row['radius_worst']) if pd.notna(row['radius_worst']) else None,
                float(row['texture_worst']) if pd.notna(row['texture_worst']) else None,
                float(row['perimeter_worst']) if pd.notna(row['perimeter_worst']) else None,
                float(row['area_worst']) if pd.notna(row['area_worst']) else None,
                float(row['smoothness_worst']) if pd.notna(row['smoothness_worst']) else None,
                float(row['compactness_worst']) if pd.notna(row['compactness_worst']) else None,
                float(row['concavity_worst']) if pd.notna(row['concavity_worst']) else None,
                float(row['concave points_worst']) if pd.notna(row['concave points_worst']) else None,
                float(row['symmetry_worst']) if pd.notna(row['symmetry_worst']) else None,
                float(row['fractal_dimension_worst']) if pd.notna(row['fractal_dimension_worst']) else None,
            )
            
            cursor.execute(insert_query, values)
            inserted_count += 1
            
            # Progress indicator
            if (index + 1) % 100 == 0:
                print(f"  Processed {index + 1}/{len(df)} records...")
                
        except Error as e:
            error_count += 1
            print(f"  Error inserting row {index + 1} (ID: {row['id']}): {e}")
            continue
    
    # Commit all inserts
    # WHY: Transactions ensure data integrity
    connection.commit()
    
    print(f"\n✓ Data loading complete!")
    print(f"  Successfully inserted: {inserted_count} records")
    if error_count > 0:
        print(f"  Errors encountered: {error_count} records")
    
    # Step 5: Verify data was loaded
    # WHY: Always verify after data loading
    print("\nVerifying data...")
    cursor.execute("SELECT COUNT(*) FROM raw_breast_cancer_data")
    count = cursor.fetchone()[0]
    print(f"✓ Total records in database: {count}")
    
    cursor.execute("""
        SELECT 
            diagnosis,
            COUNT(*) as count
        FROM raw_breast_cancer_data
        GROUP BY diagnosis
    """)
    results = cursor.fetchall()
    print("\nDiagnosis distribution:")
    for diagnosis, count in results:
        print(f"  {diagnosis}: {count} records")
    
    # Cleanup
    cursor.close()
    connection.close()
    print("\n✓ Database connection closed")
    
    return True

if __name__ == "__main__":
    print("=" * 60)
    print("Breast Cancer Data Loading Script")
    print("=" * 60)
    print()
    
    # Check if CSV file exists
    if not os.path.exists(CSV_FILE):
        print(f"ERROR: CSV file '{CSV_FILE}' not found!")
        print(f"Current directory: {os.getcwd()}")
        print("\nPlease ensure:")
        print("1. The CSV file is in the same directory as this script")
        print("2. The filename matches 'data.csv'")
        exit(1)
    
    # Run the loading process
    success = load_data_to_mysql()
    
    if success:
        print("\n" + "=" * 60)
        print("SUCCESS! Data loaded successfully.")
        print("You can now proceed with the remaining SQL scripts:")
        print("  03_data_exploration.sql")
        print("  04_data_cleaning.sql")
        print("  05_feature_engineering.sql")
        print("  06_data_modeling.sql")
        print("=" * 60)
    else:
        print("\n" + "=" * 60)
        print("FAILED! Please check the errors above and try again.")
        print("=" * 60)
        exit(1)

