############################################################
# Modeling_Prediction.R
# Role: Modeler / Predictor
# Task: Train, Predict & Compare Models
# Models: Linear Regression, ARIMA, Random Forest
############################################################

# ---------------- Step 1: Load Required Libraries ----------------
library(randomForest)
library(forecast)
library(ggplot2)

# ---------------- Step 2: Load Feature-Engineered Dataset ----------------
netflix <- read.csv("./data/NFLX_features.csv")

# Ensure correct data types
netflix$Date <- as.Date(netflix$Date)

# Ensure chronological order
netflix <- netflix[order(netflix$Date), ]

# ---------------- Step 3: Train–Test Split (Time-Based) ----------------
# Rationale:
# Stock data is sequential; random split would cause data leakage.

train_size <- floor(0.80 * nrow(netflix))

train_data <- netflix[1:train_size, ]
test_data  <- netflix[(train_size + 1):nrow(netflix), ]

# ---------------- Step 4: Linear Regression Model ----------------
lm_model <- lm(
  Close ~ Lag_1_Close + Lag_5_Close + MA_20 + MA_50 + Volatility_20,
  data = train_data
)

lm_pred <- predict(lm_model, test_data)

# ---------------- Step 5: ARIMA Model (Time-Series Forecasting) ----------------
close_ts <- ts(
  train_data$Close,
  frequency = 252  # Approximate trading days per year
)
class(close_ts)
length(close_ts)

arima_model <- auto.arima(close_ts)
summary(arima_model)

arima_forecast <- forecast(
  arima_model,
  h = nrow(test_data)
)

arima_pred <- as.numeric(arima_forecast$mean)

# ---------------- Step 6: Random Forest Model ----------------
rf_model <- randomForest(
  Close ~ Lag_1_Close + Lag_5_Close + MA_20 + MA_50 + Volatility_20,
  data  = train_data,
  ntree = 500,
  importance = TRUE
)

rf_pred <- predict(rf_model, test_data)

# ---------------- Step 7: Combine Prediction Results ----------------
results <- data.frame(
  Date          = test_data$Date,
  Actual        = test_data$Close,
  Linear        = lm_pred,
  RandomForest = rf_pred,
  ARIMA         = arima_pred
)

# ---------------- Step 8: Visual Comparison ----------------
ggplot(results, aes(x = Date)) +
  geom_line(aes(y = Actual, color = "Actual")) +
  geom_line(aes(y = Linear, color = "Linear Regression")) +
  geom_line(aes(y = RandomForest, color = "Random Forest")) +
  geom_line(aes(y = ARIMA, color = "ARIMA")) +
  labs(
    title = "Model Prediction Comparison",
    x = "Date",
    y = "Closing Price"
  ) +
  theme_minimal()

# ---------------- Step 9: Save Prediction Results ----------------
write.csv(
  results,
  "./data/results.csv",
  row.names = FALSE
)

############################################################
# End of Modeling & Prediction Script
############################################################
