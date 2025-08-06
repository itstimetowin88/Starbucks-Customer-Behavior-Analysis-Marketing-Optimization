setwd('/Users/panhanwen')

# === Part III: Regression Analysis ===

# Load data
data <- read.csv(file = "df_features_edited_ver2.csv", header = TRUE)

data$gender <- as.factor(data$gender)
data$membership_year <- as.factor(data$membership_year)

# -------------------------------
# Part III - Q1: Full Model Search using Mallow’s Cp
# -------------------------------
library(leaps)
y <- data$total_amount
x <- cbind(data$count_type_bogo, data$count_type_discount, data$count_type_informational,
           data$avg_duration, data$avg_difficulty, data$gender, data$age, data$income, data$membership_year,
           data$count_channel_email, data$count_channel_mobile, data$count_channel_social, data$count_channel_web)

out <- leaps(x, y, method = "Cp", nbest = 1)
print(out)

# -------------------------------
# Part III - Q2: Forward Stepwise Regression
# -------------------------------
library(lars)
res <- lars(x, y, type = "stepwise")
print(summary(res))
print(res)

res1 <- lm(total_amount~income+membership_year+count_channel_social+gender+avg_duration+count_channel_mobile, data=data)
summary(res1)

res2 <- lm(total_amount~count_type_bogo+count_type_discount+count_type_informational+
             avg_duration+avg_difficulty+gender+age+income+membership_year+
             count_channel_email+count_channel_mobile+count_channel_social+count_channel_web, data=data)
summary(res2)
