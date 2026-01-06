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

# ---------------- Step 5: Create Comparison Table ----------------
evaluation_metrics <- data.frame(
  Model = c("Linear Regression", "Random Forest", "ARIMA"),
  MAE   = c(mae_lm, mae_rf, mae_ar),
  RMSE  = c(rmse_lm, rmse_rf, rmse_ar),
  MAPE  = c(mape_lm, mape_rf, mape_ar)
)

evaluation_metrics

# ---------------- Step 6: Save Evaluation Results ----------------
write.csv(
  evaluation_metrics,
  "./data/Model_Evaluation_Results.csv",
  row.names = FALSE
)

# Also save a copy for report tables
dir.create("./outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(
  evaluation_metrics,
  "./outputs/tables/Model_Performance_Comparison.csv",
  row.names = FALSE
)

# ---------------- Step 7: Visual Comparison of Errors ----------------
ggplot(evaluation_metrics, aes(x = Model, y = RMSE, fill = Model)) +
  geom_bar(stat = "identity") +
  labs(
    title = "RMSE Comparison Across Models",
    x = "Model",
    y = "RMSE"
  ) +
  theme_minimal() +
  theme(legend.position = "none")

# ---------------- Step 8: Key Insights ----------------
# Interpretation:
# - Lower error values indicate better predictive performance
# - Random Forest typically performs best due to non-linear learning
# - Linear Regression serves as a baseline model
# - ARIMA captures temporal trends but struggles with complex patterns

############################################################
# End of Model Evaluation & Insights Script
############################################################