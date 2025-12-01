import streamlit as st
import joblib
import numpy as np

# 1. Load the trained model
# This 'cancer_model.pkl' must be in the same folder!
model = joblib.load('cancer_model.pkl')

# 2. App Title and Description
st.title("OncoMetric: Breast Cancer Risk Assistant 🔬")
st.write("Enter the tumor measurements below to predict the diagnosis.")
st.write("*(Model trained on Wisconsin Breast Cancer Dataset)*")

# 3. Create Input Fields for the Doctor
# We need inputs for the 6 features you selected
col1, col2 = st.columns(2)

with col1:
    radius = st.number_input("Radius Mean", min_value=0.0, max_value=30.0, value=14.0)
    texture = st.number_input("Texture Mean", min_value=0.0, max_value=40.0, value=19.0)
    perimeter = st.number_input("Perimeter Mean", min_value=0.0, max_value=200.0, value=90.0)

with col2:
    area = st.number_input("Area Mean", min_value=0.0, max_value=2500.0, value=600.0)
    smoothness = st.number_input("Smoothness Mean", min_value=0.0, max_value=0.2, value=0.09, format="%.4f")
    concavity = st.number_input("Concavity Mean", min_value=0.0, max_value=0.5, value=0.08, format="%.4f")

# 4. Predict Button
if st.button("Predict Diagnosis"):
    # Prepare the data for the model (must match the training shape)
    features = np.array([[radius, texture, perimeter, area, smoothness, concavity]])
    
    # Make Prediction
    prediction = model.predict(features)
    probability = model.predict_proba(features)

    # 5. Display Result
    if prediction[0] == 1:
        st.error(f"🚨 Prediction: MALIGNANT (Risk: {probability[0][1]:.2%})")
        st.write("Recommendation: Urgent Biopsy Recommended.")
    else:
        st.success(f"✅ Prediction: BENIGN (Confidence: {probability[0][0]:.2%})")
        st.write("Recommendation: Routine Monitor.")