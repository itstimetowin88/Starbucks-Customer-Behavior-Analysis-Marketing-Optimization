setwd("/Users/panhanwen")

# === Part II: Classification Tree and Random Forest Analysis ===

# Load data
data <- read.csv("df_co_edited_ver2.csv", header = TRUE)
data_train <- data[1:floor(0.8 * nrow(data)), ]
data_test <- data[(floor(0.8 * nrow(data)) + 1):nrow(data), ]

# Load necessary libraries
library(rpart)
library(randomForest)

# Define F1 score function
myf1score <- function(pred, actual) {
  res <- table(pred, actual)
  precision <- res[2,2] / (res[2,2] + res[2,1])
  recall <- res[2,2] / (res[2,2] + res[1,2])
  f1 <- 2 / (1 / precision + 1 / recall)
  return(f1)
}

# ------------------------------------------
# Part II - Q1: Unpruned Classification Tree
# ------------------------------------------

set.seed(123)
tfit <- rpart(is_completed ~ gender + age + income + membership_year + offer_type + difficulty + duration + channels,
              data = data_train,
              method = 'class',
              parms = list(split = 'information'),
              control = rpart.control(cp = 0.0001))

cat("\n=== Part II - Q1: Unpruned Tree Summary ===\n")
print(tfit)
plot(tfit, uniform = TRUE)
text(tfit)

# Evaluate on training data
pred_train <- predict(tfit, data_train, type = "class")
conf_train <- table(pred_train, data_train$is_completed)
precision_train <- conf_train[2,2] / (conf_train[2,2] + conf_train[2,1])
recall_train <- conf_train[2,2] / (conf_train[2,2] + conf_train[1,2])
f1_train <- myf1score(pred_train, data_train$is_completed)

cat("\n[Unpruned Tree - Training Set]\n")
print(conf_train)
cat("Precision =", precision_train, "  Recall =", recall_train, "  F1 =", f1_train, "\n")

# Evaluate on testing data
pred_test <- predict(tfit, data_test, type = "class")
conf_test <- table(pred_test, data_test$is_completed)
precision_test <- conf_test[2,2] / (conf_test[2,2] + conf_test[2,1])
recall_test <- conf_test[2,2] / (conf_test[2,2] + conf_test[1,2])
f1_test <- myf1score(pred_test, data_test$is_completed)

cat("\n[Unpruned Tree - Testing Set]\n")
print(conf_test)
cat("Precision =", precision_test, "  Recall =", recall_test, "  F1 =", f1_test, "\n")

# -----------------------------------------------------
# Part II - Q2: Pruned Tree (using 1-SE rule on cp plot)
# -----------------------------------------------------

cat("\n=== Part II - Q2: Pruned Tree (Using 1-SE Rule) ===\n")
printcp(tfit)
plotcp(tfit)

cat("\n[Pruning Decision]\n")
cat("Minimum xerror is found (example: cp = 0.00165955)\n")
cat("Using 1-SE rule, we select cp = 0.00077629 for pruning.\n")

tfit_pruned <- prune(tfit, cp = 0.00077629)
print(tfit_pruned)
plot(tfit_pruned, uniform = TRUE)
text(tfit_pruned)

# Evaluate on training data
pred_train_pruned <- predict(tfit_pruned, data_train, type = "class")
conf_train_pruned <- table(pred_train_pruned, data_train$is_completed)
precision_train_pruned <- conf_train_pruned[2,2] / (conf_train_pruned[2,2] + conf_train_pruned[2,1])
recall_train_pruned <- conf_train_pruned[2,2] / (conf_train_pruned[2,2] + conf_train_pruned[1,2])
f1_train_pruned <- myf1score(pred_train_pruned, data_train$is_completed)

cat("\n[Pruned Tree - Training Set]\n")
print(conf_train_pruned)
cat("Precision =", precision_train_pruned, "  Recall =", recall_train_pruned, "  F1 =", f1_train_pruned, "\n")

# Evaluate on testing data
pred_test_pruned <- predict(tfit_pruned, data_test, type = "class")
conf_test_pruned <- table(pred_test_pruned, data_test$is_completed)
precision_test_pruned <- conf_test_pruned[2,2] / (conf_test_pruned[2,2] + conf_test_pruned[2,1])
recall_test_pruned <- conf_test_pruned[2,2] / (conf_test_pruned[2,2] + conf_test_pruned[1,2])
f1_test_pruned <- myf1score(pred_test_pruned, data_test$is_completed)

cat("\n[Pruned Tree - Testing Set]\n")
print(conf_test_pruned)
cat("Precision =", precision_test_pruned, "  Recall =", recall_test_pruned, "  F1 =", f1_test_pruned, "\n")

# -----------------------------------------
# Part II - Q3: Random Forest (50 trees)
# -----------------------------------------

cat("\n=== Part II - Q3: Random Forest (ntree = 50) ===\n")
data_train$is_completed <- as.factor(data_train$is_completed)
set.seed(42)
rffit <- randomForest(is_completed ~ gender + age + income + membership_year + offer_type + difficulty + duration + channels,
                      data = data_train,
                      ntree = 50,
                      importance = TRUE)

plot(rffit)
print(rffit)
varImpPlot(rffit)

# Evaluate on training data
pred_rf_train <- predict(rffit, data_train)
conf_rf_train <- table(pred_rf_train, data_train$is_completed)
precision_rf_train <- conf_rf_train[2,2] / (conf_rf_train[2,2] + conf_rf_train[2,1])
recall_rf_train <- conf_rf_train[2,2] / (conf_rf_train[2,2] + conf_rf_train[1,2])
f1_rf_train <- myf1score(pred_rf_train, data_train$is_completed)

cat("\n[Random Forest - Training Set]\n")
print(conf_rf_train)
cat("Precision =", precision_rf_train, "  Recall =", recall_rf_train, "  F1 =", f1_rf_train, "\n")

# Evaluate on testing data
pred_rf_test <- predict(rffit, data_test)
conf_rf_test <- table(pred_rf_test, data_test$is_completed)
precision_rf_test <- conf_rf_test[2,2] / (conf_rf_test[2,2] + conf_rf_test[2,1])
recall_rf_test <- conf_rf_test[2,2] / (conf_rf_test[2,2] + conf_rf_test[1,2])
f1_rf_test <- myf1score(pred_rf_test, data_test$is_completed)

cat("\n[Random Forest - Testing Set]\n")
print(conf_rf_test)
cat("Precision =", precision_rf_test, "  Recall =", recall_rf_test, "  F1 =", f1_rf_test, "\n")

# Comparison of all three models
model_comparison <- rbind(
  c(precision_test, recall_test, f1_test),
  c(precision_test_pruned, recall_test_pruned, f1_test_pruned),
  c(precision_rf_test, recall_rf_test, f1_rf_test)
)
colnames(model_comparison) <- c("Precision", "Recall", "F1 Score")
rownames(model_comparison) <- c("Unpruned Tree", "Pruned Tree", "Random Forest")

cat("\n=== Final Model Comparison (Test Set) ===\n")
print(model_comparison)
