"""
================================================================================
BREAST CANCER DATA ANALYSIS - MACHINE LEARNING MODELS
================================================================================
Purpose: Train and evaluate machine learning models on the prepared data
Prerequisites: 
    - Run SQL scripts 01-06 first
    - Install: pip install pandas scikit-learn mysql-connector-python
================================================================================
"""

import pandas as pd
import mysql.connector
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score, confusion_matrix
import warnings
warnings.filterwarnings('ignore')

# ============================================================================
# CONFIGURATION
# ============================================================================
# Update these with your MySQL connection details
DB_CONFIG = {
    'host': 'localhost',
    'database': 'breast_cancer_db',
    'user': 'root',
    'password': 'your_password_here'  # Change this!
}

print("=" * 60)
print("BREAST CANCER ML MODEL TRAINING")
print("=" * 60)
print()

# ============================================================================
# STEP 1: LOAD DATA FROM DATABASE
# ============================================================================
print("Step 1: Loading data from database...")

try:
    # Connect to MySQL database
    connection = mysql.connector.connect(**DB_CONFIG)
    print("✓ Connected to database")
    
    # Load data from the ml_ready_data view we created
    query = """
    SELECT 
        id,
        diagnosis,
        radius_mean, texture_mean, area_mean, perimeter_mean,
        concavity_mean, compactness_mean,
        perimeter_to_area_ratio,
        radius_spread,
        area_spread,
        high_risk_flag,
        dataset_type
    FROM ml_ready_data
    """
    
    # Read data into pandas DataFrame
    df = pd.read_sql(query, connection)
    print(f"✓ Loaded {len(df)} records")
    
    connection.close()
    print("✓ Database connection closed")
    
except Exception as e:
    print(f"ERROR: Could not load data from database: {e}")
    print("\nTroubleshooting:")
    print("1. Make sure MySQL is running")
    print("2. Check your database credentials in DB_CONFIG")
    print("3. Make sure you've run SQL scripts 01-06 first")
    exit(1)

# ============================================================================
# STEP 2: PREPARE DATA FOR MODELING
# ============================================================================
print("\nStep 2: Preparing data for modeling...")

# Separate features (X) and target (y)
# Features: all columns except id, diagnosis, and dataset_type
feature_columns = ['radius_mean', 'texture_mean', 'area_mean', 'perimeter_mean',
                   'concavity_mean', 'compactness_mean',
                   'perimeter_to_area_ratio', 'radius_spread', 'area_spread', 'high_risk_flag']

X = df[feature_columns]
y = df['diagnosis']

# Convert diagnosis to binary (M=1, B=0)
y = (y == 'M').astype(int)

print(f"✓ Features: {len(feature_columns)} columns")
print(f"✓ Target: {y.sum()} malignant, {len(y) - y.sum()} benign")

# Split into training and test sets (using the split we created in SQL)
# Or create a new split here
train_data = df[df['dataset_type'] == 'train']
test_data = df[df['dataset_type'] == 'test']

if len(train_data) > 0 and len(test_data) > 0:
    # Use the SQL split
    X_train = train_data[feature_columns]
    X_test = test_data[feature_columns]
    y_train = (train_data['diagnosis'] == 'M').astype(int)
    y_test = (test_data['diagnosis'] == 'M').astype(int)
    print(f"✓ Using SQL train/test split: {len(X_train)} train, {len(X_test)} test")
else:
    # Create new split if SQL split doesn't exist
    X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42, stratify=y)
    print(f"✓ Created new train/test split: {len(X_train)} train, {len(X_test)} test")

# ============================================================================
# STEP 3: TRAIN MODEL 1 - LOGISTIC REGRESSION
# ============================================================================
print("\n" + "=" * 60)
print("MODEL 1: LOGISTIC REGRESSION")
print("=" * 60)

# Create and train the model
model_lr = LogisticRegression(random_state=42, max_iter=1000)
model_lr.fit(X_train, y_train)
print("✓ Model trained")

# Make predictions
y_pred_lr = model_lr.predict(X_test)
y_pred_proba_lr = model_lr.predict_proba(X_test)[:, 1]

# Calculate metrics
accuracy_lr = accuracy_score(y_test, y_pred_lr)
precision_lr = precision_score(y_test, y_pred_lr)
recall_lr = recall_score(y_test, y_pred_lr)
f1_lr = f1_score(y_test, y_pred_lr)

print(f"\nResults:")
print(f"  Accuracy:  {accuracy_lr:.4f} ({accuracy_lr*100:.2f}%)")
print(f"  Precision: {precision_lr:.4f} ({precision_lr*100:.2f}%)")
print(f"  Recall:    {recall_lr:.4f} ({recall_lr*100:.2f}%)")
print(f"  F1 Score:  {f1_lr:.4f} ({f1_lr*100:.2f}%)")

# Confusion Matrix
cm_lr = confusion_matrix(y_test, y_pred_lr)
print(f"\nConfusion Matrix:")
print(f"  True Negatives:  {cm_lr[0,0]}  |  False Positives: {cm_lr[0,1]}")
print(f"  False Negatives: {cm_lr[1,0]}  |  True Positives:  {cm_lr[1,1]}")

# Feature importance (coefficients)
print(f"\nTop 5 Most Important Features:")
feature_importance = pd.DataFrame({
    'feature': feature_columns,
    'coefficient': model_lr.coef_[0]
})
feature_importance['abs_coefficient'] = feature_importance['coefficient'].abs()
feature_importance = feature_importance.sort_values('abs_coefficient', ascending=False)
for idx, row in feature_importance.head(5).iterrows():
    print(f"  {row['feature']}: {row['coefficient']:.4f}")

# ============================================================================
# STEP 4: TRAIN MODEL 2 - DECISION TREE
# ============================================================================
print("\n" + "=" * 60)
print("MODEL 2: DECISION TREE")
print("=" * 60)

# Create and train the model
model_dt = DecisionTreeClassifier(random_state=42, max_depth=5)
model_dt.fit(X_train, y_train)
print("✓ Model trained")

# Make predictions
y_pred_dt = model_dt.predict(X_test)

# Calculate metrics
accuracy_dt = accuracy_score(y_test, y_pred_dt)
precision_dt = precision_score(y_test, y_pred_dt)
recall_dt = recall_score(y_test, y_pred_dt)
f1_dt = f1_score(y_test, y_pred_dt)

print(f"\nResults:")
print(f"  Accuracy:  {accuracy_dt:.4f} ({accuracy_dt*100:.2f}%)")
print(f"  Precision: {precision_dt:.4f} ({precision_dt*100:.2f}%)")
print(f"  Recall:    {recall_dt:.4f} ({recall_dt*100:.2f}%)")
print(f"  F1 Score:  {f1_dt:.4f} ({f1_dt*100:.2f}%)")

# Confusion Matrix
cm_dt = confusion_matrix(y_test, y_pred_dt)
print(f"\nConfusion Matrix:")
print(f"  True Negatives:  {cm_dt[0,0]}  |  False Positives: {cm_dt[0,1]}")
print(f"  False Negatives: {cm_dt[1,0]}  |  True Positives:  {cm_dt[1,1]}")

# Feature importance
print(f"\nTop 5 Most Important Features:")
feature_importance_dt = pd.DataFrame({
    'feature': feature_columns,
    'importance': model_dt.feature_importances_
})
feature_importance_dt = feature_importance_dt.sort_values('importance', ascending=False)
for idx, row in feature_importance_dt.head(5).iterrows():
    print(f"  {row['feature']}: {row['importance']:.4f}")

# ============================================================================
# STEP 5: COMPARE MODELS
# ============================================================================
print("\n" + "=" * 60)
print("MODEL COMPARISON")
print("=" * 60)

comparison = pd.DataFrame({
    'Model': ['Logistic Regression', 'Decision Tree'],
    'Accuracy': [accuracy_lr, accuracy_dt],
    'Precision': [precision_lr, precision_dt],
    'Recall': [recall_lr, recall_dt],
    'F1 Score': [f1_lr, f1_dt]
})

print("\n" + comparison.to_string(index=False))

# Find best model
best_model_name = comparison.loc[comparison['Accuracy'].idxmax(), 'Model']
print(f"\n✓ Best Model: {best_model_name} (based on accuracy)")

# ============================================================================
# STEP 6: SAVE RESULTS
# ============================================================================
print("\n" + "=" * 60)
print("SAVING RESULTS")
print("=" * 60)

# Save predictions to CSV
results_df = test_data[['id', 'diagnosis']].copy()
results_df['predicted_lr'] = y_pred_lr
results_df['predicted_dt'] = y_pred_dt
results_df['predicted_lr'] = results_df['predicted_lr'].map({1: 'M', 0: 'B'})
results_df['predicted_dt'] = results_df['predicted_dt'].map({1: 'M', 0: 'B'})

results_df.to_csv('ml_predictions.csv', index=False)
print("✓ Predictions saved to ml_predictions.csv")

# Save model comparison
comparison.to_csv('model_comparison.csv', index=False)
print("✓ Model comparison saved to model_comparison.csv")

# ============================================================================
# FINAL SUMMARY
# ============================================================================
print("\n" + "=" * 60)
print("SUMMARY")
print("=" * 60)
print(f"✓ Trained 2 models successfully")
print(f"✓ Tested on {len(X_test)} samples")
print(f"✓ Best accuracy: {comparison['Accuracy'].max()*100:.2f}%")
print(f"✓ Results saved to CSV files")
print("\n" + "=" * 60)
print("ML MODEL TRAINING COMPLETE!")
print("=" * 60)

