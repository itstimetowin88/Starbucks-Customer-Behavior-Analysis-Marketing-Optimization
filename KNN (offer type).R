setwd("/Users/panhanwen")

# === Part I: Classification Model Evaluation ===

# -------------------------------
# Part I - Q1: k-NN training error (single run)
# -------------------------------
library(class)
set.seed(744)

data <- read.csv("df_co_edited_ver2.csv", header = TRUE)

data$offer_alias <- as.factor(data$offer_alias)
data$gender <- as.factor(data$gender)
data$membership_year <- as.factor(data$membership_year)

data_train <- data[1:floor(0.8 * nrow(data)), ]
data_test <- data[(floor(0.8 * nrow(data)) + 1):nrow(data), ]

train <- cbind(data_train$offer_alias, data_train$gender, data_train$age, data_train$income, data_train$membership_year)
test <- cbind(data_test$offer_alias, data_test$gender, data_test$age, data_test$income, data_test$membership_year)
class1 <- data_train$is_completed

err_by_k <- rep(0, 10)
for(k in 1:10) {
  res <- knn(train, train, class1, k = k, prob=TRUE)
  err_by_k[k] <- sum(abs(as.numeric(res)-1 - class1))
}
cat("\n=== Part I - Q1: k-NN Training Error ===\n")
print(cbind(k = 1:10, training_error = err_by_k))

# -------------------------------
# Part I - Q2: k-NN testing error (single run)
# -------------------------------
class2 <- data_test$is_completed
err_by_k <- rep(0, 10)
for(k in 1:10) {
  res <- knn(train, test, class1, k = k, prob=TRUE)
  err_by_k[k] <- sum(abs(as.numeric(res)-1 - class2))
}
cat("\n=== Part I - Q2: k-NN Testing Error ===\n")
print(cbind(k = 1:10, testing_error = err_by_k))

myf1score <- function(pred, actual) {
  res <- table(pred, actual)
  precision <- res[2,2] / (res[2,2] + res[2,1])
  recall <- res[2,2] / (res[2,2] + res[1,2])
  f1 <- 2 / (1 / precision + 1 / recall)
  return(f1)
}

pred_test <- knn(train, test, class1, k = 8, prob = TRUE)
conf_test <- table(pred_test, data_test$is_completed)
precision_test <- conf_test[2,2] / (conf_test[2,2] + conf_test[2,1])
recall_test <- conf_test[2,2] / (conf_test[2,2] + conf_test[1,2])
f1_test <- myf1score(pred_test, data_test$is_completed)

print(conf_test)
cat("Precision =", precision_test, "  Recall =", recall_test, "  F1 =", f1_test, "\n")
