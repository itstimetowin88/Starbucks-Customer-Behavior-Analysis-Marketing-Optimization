### set the place
setwd("C:\\xixialan\\2024spring\\746datascience\\report")

### read data
data=read.csv(file="customer_data.csv", header=TRUE)

###################
#clean the data
###################
### make sure there's no  missing data
sum(is.na(data))

### remove education column
data$education <- NULL

### change gender to numerical value
data$gender <- factor(data$gender, levels = c("Female", "Male"))
data$gender_set <- as.numeric(data$gender) - 1

### change region to dummy variable
# check amount
region_count <- length(unique(data$region))
print(region_count)
# check value
region_values <- unique(data$region)
print(region_values)
# set up dummy variable
data$region <- factor(data$region, level= c("North", "East", "West", "South"))
region_matrix <- model.matrix(~ region, data = data)[,2:4]

### change loyalty status to dummy variable
# check amount
loyalty_status_count <- length(unique(data$loyalty_status))
print(loyalty_status_count)
# check value
loyalty_status_values <- unique(data$loyalty_status)
print(loyalty_status_values)
# set up dummy variable
data$loyalty_status <- factor(data$loyalty_status, level= c("Silver","Regular","Gold"))
loyalty_status_matrix <- model.matrix(~ loyalty_status, data = data)[,2:3]

### change purchase frequency to dummy variable
# check amount
purchase_frequency_count <- length(unique(data$purchase_frequency))
print(purchase_frequency_count)
# check value
purchase_frequency_values <- unique(data$purchase_frequency)
print(purchase_frequency_values)
# set up dummy variable
data$purchase_frequency <- factor(data$purchase_frequency, level= c("occasional", "rare", "frequent"))
purchase_frequency_matrix <- model.matrix(~ purchase_frequency, data = data)[,2:3]

### change product category to dummy variable
# check amount
product_category_count <- length(unique(data$product_category))
print(product_category_count)
# check value
product_category_values <- unique(data$product_category)
print(product_category_values)
# set up dummy variable
data$product_category <- factor(data$product_category, level= c("Books", "Clothing", "Food", "Electronics", "Home", "Beauty", "Health"))
product_category_matrix <- model.matrix(~ product_category, data = data)[,2:7]

###################
#Regression
#research question: what factors affect purchase frequency?
###################
### install package
install.packages("lars")
library(lars)

### for rare purchase
#set variables
rare_y = purchase_frequency_matrix[,1]
rare_x = cbind(data$age, data$gender_set, data$income, data$promotion_usage, data$satisfaction, region_matrix, loyalty_status_matrix, product_category_matrix)
# forward-stepwise regression
rare_res = lars(rare_x, rare_y, type="stepwise")
print(summary(rare_res))
rare_res
#regression model
rare_reg_model = lm(purchase_frequency_matrix[,1]~data$age+data$gender_set+data$income+data$promotion_usage+data$satisfaction+region_matrix+loyalty_status_matrix+product_category_matrix)
summary(rare_reg_model)
#regression model(adjust)
ad_rare_reg_model = lm(purchase_frequency_matrix[,1]~data$satisfaction+product_category_matrix[,2]+region_matrix[,2]+product_category_matrix[,4]+loyalty_status_matrix[,2]+loyalty_status_matrix[,1]+product_category_matrix[,6])
summary(ad_rare_reg_model)
#regression model(adjust2)
ad2_rare_reg_model = lm(purchase_frequency_matrix[,1]~data$satisfaction)
summary(ad2_rare_reg_model)

### for frequent purchase
# forward-stepwise regression
fre_y = purchase_frequency_matrix[,2]
fre_x = cbind(data$age, data$gender_set, data$income, data$promotion_usage, data$satisfaction, region_matrix, loyalty_status_matrix, product_category_matrix)
fre_res = lars(fre_x, fre_y, type="stepwise")
print(summary(fre_res))
fre_res
#regression model
fre_reg_model = lm(purchase_frequency_matrix[,2]~data$age+data$gender_set+data$income+data$promotion_usage+data$satisfaction+region_matrix+loyalty_status_matrix+product_category_matrix)
summary(fre_reg_model)
#regression model(adjust)
ad_fre_reg_model = lm(purchase_frequency_matrix[,2]~data$age+loyalty_status_matrix[,1:2]+product_category_matrix[,3:6])
summary(ad_fre_reg_model)
#regression model(adjust2)
ad2_fre_reg_model = lm(purchase_frequency_matrix[,2]~data$age+loyalty_status_matrix[,1:2])
summary(ad2_fre_reg_model)
#regression model(adjust3)
ad3_fre_reg_model = lm(purchase_frequency_matrix[,2]~data$age+loyalty_status_matrix[,1])
summary(ad3_fre_reg_model)

###################
#k-nn
#research question:
###################
###install package
install.packages("class")
library(class)

### change purchase frequency to classification
data$purchase_frequency_set <- as.integer(data$purchase_frequency)

### split the data 
set.seed(746)
data_train <- data[1:floor(0.7 * nrow(data)),]
data_test <- data[(floor(0.7 * nrow(data))+1):nrow(data),]

###k-nn
#X: age, gender_set, income, promotion_usage, satisfaction
train = cbind(data_train$age, data_train$gender_set, data_train$income, data_train$promotion_usage, data_train$satisfaction, region_matrix[1:floor(0.7 * nrow(data)),], loyalty_status_matrix[1:floor(0.7 * nrow(data)),], product_category_matrix[1:floor(0.7 * nrow(data)),]) 
test = cbind(data_test$age, data_test$gender_set, data_test$income, data_test$promotion_usage, data_test$satisfaction, region_matrix[(floor(0.7 * nrow(data))+1):nrow(data),], loyalty_status_matrix[(floor(0.7 * nrow(data))+1):nrow(data),], product_category_matrix[(floor(0.7 * nrow(data))+1):nrow(data),])
#Y: purchase frequency
cl = data_train$purchase_frequency_set
cl_test = data_test$purchase_frequency_set
#look for error for testing data 
err_by_k = rep(1, 10)
for(k in 1:10) {
  res = knn(train, test, cl, k = k, prob=TRUE)
  err_by_k[k] = sum(as.numeric(res)!=cl_test)
}
cbind(seq(1,10), err_by_k)
cbind(seq(1,10), err_by_k/30000)
