#################################################################################
# Starbucks Customer Behavior Analysis w/ ML Learning Segmentation & Optimization
#################################################################################
FYI: You may see the a detailed report in the folder. And the rest are the codes that you may run in R 

# ☕ Starbucks Consumer Data Analysis – Predictive Modeling & Targeted Marketing Strategies

## 📖 Overview

This project analyzes simulated Starbucks customer data to uncover how customer demographics, offer design, and delivery channels impact promotional effectiveness. Using data science techniques, we built predictive models to:

1. **Classify** which customers are likely to complete a given offer
2. **Predict** transaction spending and identify its key drivers

We apply a combination of classification (KNN, Decision Tree, Random Forest) and regression (stepwise linear regression) techniques to provide Starbucks with **data-driven marketing recommendations** that improve customer targeting, ROI, and engagement.

---

## 📁 Dataset

The analysis uses a **public dataset from Kaggle**, simulating 30 days of Starbucks customer behavior:
- [`portfolio.csv`](https://www.kaggle.com/datasets/sudalairajkumar/targeted-offers-campaign-data): 10 promotional offers and their characteristics
- `profile.csv`: 17,000 customers with demographic info
- `transcript.csv`: ~300,000 interactions (transactions, offers viewed, completed)

---

## 🎯 Objectives

- Predict offer completion using customer and offer data
- Identify variables that influence transaction volume
- Evaluate the effectiveness of different marketing channels
- Deliver actionable marketing segmentation strategies

---

## 🛠️ Technologies & Tools

- **Python**: Data cleaning and merging
- **R**: Predictive modeling and evaluation
- **Libraries**:
  - Python: `pandas`, `datetime`, `json`
  - R: `class`, `rpart`, `randomForest`, `MASS`, `stats`

---

## 📊 Modeling Summary

### 📌 Classification (Offer Completion Prediction)
Models were trained using two approaches:
- **Offer Alias Model**: Uses a categorical label for each offer (A–J)
- **Offer Attributes Model**: Decomposes offers into type, difficulty, duration, and channels

#### Algorithms Compared:
- **K-Nearest Neighbors (KNN)**  
  - Best F1 Score: 0.7368 (offer attributes)
- **Decision Tree (Pruned using 1-SE Rule)**  
  - Best F1 Score: 0.7964 (offer alias), 0.7934 (offer attributes)
- **Random Forest (50 Trees)**  
  - Best F1 Score: **0.7966** (offer attributes), 0.7895 (offer alias)

✅ **Conclusion**:  
Random Forest consistently delivered the best performance. Offer decomposition provided interpretability, while alias labels were slightly more concise.

---

### 📌 Regression (Spending Behavior Modeling)

- Used **forward stepwise selection** with Mallow’s Cp
- Final model selected 6 predictors:
  - **Income**
  - **Average Offer Duration**
  - **Social & Mobile Impressions**
  - **Gender**
  - **Membership Year (2014–2018)**

📈 Key Findings:
- Longer offers, mobile/social exposure, and higher income → higher spend
- Email/web impressions had negligible impact
- Male customers spend ~$19 less than female
- Customers from 2015–2017 spent significantly more than 2013 baseline

---

## 🔍 Key Recommendations

### ✅ Targeting Strategy (from Decision Tree Segmentation)
- **Informational offers** should be phased out—low completion rate
- **BOGO and discount offers** perform well, especially among:
  - Customers who joined before mid-2017
  - High-income and/or female/non-binary users

#### Male Customers (Low Income, Older Members):
- Use **high-channel exposure** (social + mobile)
- Combine with **low-difficulty** discount or BOGO offers for highest ROI

### ✅ Channel Optimization (from Regression)
- **Mobile push** and **social media** drive spend: ~$7.5–8.0 per exposure
- Reallocate budget from **email/web** to **mobile/social**
- Extend offer durations to improve redemption and revenue

---

## 📂 Project Structure

- `data/` – Raw Starbucks datasets (portfolio, profile, transcript)
- `Starbucks_Data_Cleaning_and_Merging.ipynb` – Python notebook for merging & cleaning
- `Classification_KNN_Tree_RF.R` – R script for classification models
- `Stepwise_Regression_Analysis.R` – R script for regression modeling
- `report/` – Final analysis report with visualizations and insights
- `requirements.txt` – Python dependencies for data cleaning



---

## 🚀 How to Run

1. git clone https://github.com/itstimetowin88/Starbucks-Customer-Behavior-Analysis-Marketing-Optimization.git
cd Starbucks-Customer-Behavior-Analysis-Marketing-Optimization

On macOS/Linux:
python3 -m venv env
source env/bin/activate

On Windows: 
python -m venv env
.\env\Scripts\activate

### Environment Setup

- **Python dependencies** (for data preparation notebooks):
  
  Install Python packages by running:
  
  ```bash
  pip install -r requirements.txt

- **R dependencies (for modeling scripts)**:

Make sure you have R installed on your computer.
Then, install required R packages by running the following commands in an R console or RStudio:

  install.packages(c("class", "rpart", "randomForest", "MASS", "stats"))

---

### Summary:

- **Python setup** = data prep & cleaning notebooks
- **R setup** = model training & evaluation scripts


