# ==========================================
# BREAST CANCER MODEL TRAINER (CSV EDITION)
# ==========================================
import pandas as pd
import numpy as np
import joblib
from sklearn.model_selection import train_test_split
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, confusion_matrix

print("============================================================")
print("BREAST CANCER ML MODEL TRAINING")
print("============================================================")

# 1. Load Data (DIRECTLY FROM CSV)
# This bypasses the database error
try:
    print("Step 1: Loading data from 'data.csv'...")
    df = pd.read_csv('data.csv')
    print(f"   SUCCESS: Loaded {len(df)} rows.")
except FileNotFoundError:
    print("   ERROR: 'data.csv' not found. Make sure it is in this folder.")
    exit()

# 2. Preprocessing
# Fix columns and encode M/B to 1/0
print("Step 2: Preprocessing...")
df.columns = df.columns.str.replace(' ', '_')
y = df['diagnosis'].map({'M': 1, 'B': 0})

# Select Features (Must match what we use in the App)
features = ['radius_mean', 'texture_mean', 'perimeter_mean', 'area_mean', 'smoothness_mean', 'concavity_mean']
X = df[features]

# 3. Split Data
print("Step 3: Splitting Data (80% Train / 20% Test)...")
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)

# 4. Train Model
print("Step 4: Training Logistic Regression Model...")
model = LogisticRegression(max_iter=500)
model.fit(X_train, y_train)

# 5. Evaluate
print("Step 5: Evaluating...")
y_pred = model.predict(X_test)
acc = accuracy_score(y_test, y_pred)
cm = confusion_matrix(y_test, y_pred)

print(f"\n   >>> MODEL ACCURACY: {acc:.2%}")
print(f"   >>> FALSE NEGATIVES: {cm[1][0]} (Patients we missed)")

# 6. Save Model
print("\nStep 6: Saving Model...")
joblib.dump(model, 'cancer_model.pkl')
print("   SUCCESS: Model saved as 'cancer_model.pkl'")
print("============================================================")
print("READY FOR APP DEPLOYMENT")