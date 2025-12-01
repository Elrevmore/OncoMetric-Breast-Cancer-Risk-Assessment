# Quick Start Guide

## 🚀 Get Started in 3 Steps

### Step 1: Open MySQL
```bash
mysql -u root -p
```

### Step 2: Go to Project Folder
Make sure you're in the folder where `data.csv` is located.

### Step 3: Run the Scripts
```sql
source 00_run_all.sql;
```

That's it! The scripts will:
1. ✅ Create the database
2. ✅ Load your data
3. ✅ Explore the data
4. ✅ Clean the data
5. ✅ Create new features
6. ✅ Prepare for analysis

---

## ⚠️ Common Issues

### "File not found" error
- Make sure you're in the project directory
- Check that `data.csv` is in the same folder

### "LOAD DATA" doesn't work
- Try: `SET GLOBAL local_infile = 1;`
- Or use: `python load_data_alternative.py`

### "Duplicate column" error
- The column already exists - that's okay!
- Just continue or ignore the error

---

## 📖 Learning Tips

1. **Read the comments** in each SQL file
2. **Run scripts one at a time** to see what happens
3. **Try modifying queries** to see different results
4. **Experiment** with the data

---

## 📚 Files Overview

- `01_database_setup.sql` - Creates database
- `02_data_loading.sql` - Loads data
- `03_data_exploration.sql` - Explores data
- `04_data_cleaning.sql` - Cleans data
- `05_feature_engineering.sql` - Creates features
- `06_data_modeling.sql` - Prepares data
- `07_ml_models.py` - Trains ML models (optional)

## 🤖 Training ML Models (Optional)

After running the SQL scripts, you can train machine learning models:

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Edit 07_ml_models.py and set your MySQL password

# 3. Run the script
python 07_ml_models.py
```

This will train two models and show you the results!

---

**Happy Learning! 🎓**
