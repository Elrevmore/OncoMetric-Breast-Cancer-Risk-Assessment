# OncoMetric: Breast Cancer Risk Assistant 🔬

**A Machine Learning Clinical Support Tool optimized to minimize False Negatives in Breast Cancer Diagnosis.**

## 🧬 Project Overview
OncoMetric is a predictive tool designed to assist medical professionals in distinguishing between **Malignant (M)** and **Benign (B)** tumor samples. 

Unlike standard accuracy-focused models, this project prioritizes the reduction of **Type II Errors (False Negatives)**—cases where cancer is present but missed. In a clinical setting, a False Negative is the most dangerous outcome.

## 🚀 Live Demo
The application is built with **Streamlit** and provides real-time predictions based on cell nuclei measurements.
*(Link to live demo will be added here upon deployment)*

## 📊 Key Insights & Data Analysis
Before building the model, I conducted a deep-dive analysis using SQL to identify the most predictive features.

> **[📂 Click here to view the Full SQL Pipeline & Analysis Report](sql_analysis/)**

**Summary of Discovery:**
* **The "Hidden" Feature:** While `Radius` is the obvious indicator, my analysis revealed that **`Concavity`** (surface irregularity) is a critical differentiator for malignant tumors.
* **The Danger Zone:** Tumors with an area > 1000 showed a significantly higher malignancy rate.

## 🛠️ Tech Stack
* **Python:** Core Logic & ML Training
* **SQL:** Data Cleaning, Exploration, and Feature Engineering
* **Scikit-Learn:** Logistic Regression (Optimized for Recall)
* **Streamlit:** Web Interface Deployment
* **Pandas/NumPy:** Data Manipulation

## 💻 How to Run Locally

1. **Clone the Repository**
   ```bash
   git clone [https://github.com/YOUR_USERNAME/OncoMetric-Breast-Cancer-Risk-Assessment.git](https://github.com/YOUR_USERNAME/OncoMetric-Breast-Cancer-Risk-Assessment.git)
