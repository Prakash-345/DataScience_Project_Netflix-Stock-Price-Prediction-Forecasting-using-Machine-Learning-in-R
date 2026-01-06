############################################################
# Model_Evaluation_Insights.R
# Role: Insights Lead
# Task: Model Evaluation, Comparison & Interpretation
# Models Evaluated: Linear Regression, Random Forest, ARIMA
############################################################

# ---------------- Step 1: Load Required Libraries ----------------
library(caret)
library(ggplot2)

# ---------------- Step 2: Load Prediction Results ----------------
# Generated from Modeling_Prediction.R

results <- read.csv("./data/results.csv")

# Ensure correct data types
results$Date <- as.Date(results$Date)

# Remove any residual NA values
results <- na.omit(results)

# ---------------- Step 3: Define Evaluation Metrics ----------------
# Metrics used:
# MAE  – Mean Absolute Error
# RMSE – Root Mean Squared Error
# MAPE – Mean Absolute Percentage Error

mape <- function(actual, predicted) {
  mean(abs((actual - predicted) / actual)) * 100
}

# ---------------- Step 4: Compute Metrics for Each Model ----------------

# Linear Regression
mae_lm  <- mean(abs(results$Actual - results$Linear))
rmse_lm <- RMSE(results$Linear, results$Actual)
mape_lm <- mape(results$Actual, results$Linear)

# Random Forest
mae_rf  <- mean(abs(results$Actual - results$RandomForest))
rmse_rf <- RMSE(results$RandomForest, results$Actual)
mape_rf <- mape(results$Actual, results$RandomForest)

# ARIMA
mae_ar  <- mean(abs(results$Actual - results$ARIMA))
rmse_ar <- RMSE(results$ARIMA, results$Actual)
mape_ar <- mape(results$Actual, results$ARIMA)
