############################################################
# Feature_Engineering_Correlation.R
# Role: Feature Engineer
# Task: Feature Creation & Correlation Analysis
# Dataset: Netflix Stock Price (Structured Data)
############################################################

# ---------------- Step 1: Load Required Libraries ----------------
library(dplyr)
library(TTR)
library(corrplot)

# ---------------- Step 2: Load Structured Dataset ----------------
netflix <- read.csv("./data/NFLX_structured.csv")

# Ensure correct data types
netflix$Date  <- as.Date(netflix$Date)
netflix$Close <- as.numeric(netflix$Close)

# ---------------- Step 3: Feature Engineering ----------------
# Rationale:
# Raw prices alone are insufficient for learning trends and momentum.
# Derived features help models capture temporal dynamics.

# 3.1 Daily Returns (Price Change)
netflix$Daily_Return <- c(NA, diff(netflix$Close))

# 3.2 Lag Features (Past Information)
netflix$Lag_1_Close <- lag(netflix$Close, 1)
netflix$Lag_5_Close <- lag(netflix$Close, 5)

# 3.3 Moving Averages (Trend Indicators)
netflix$MA_20 <- SMA(netflix$Close, n = 20)
netflix$MA_50 <- SMA(netflix$Close, n = 50)

# 3.4 Rolling Volatility (Risk Indicator)
netflix$Volatility_20 <- runSD(netflix$Close, n = 20)

# Inspect newly engineered features for correctness
head(netflix[, c(
  "Date", "Close", "Daily_Return", "Lag_1_Close",
  "Lag_5_Close", "MA_20", "MA_50", "Volatility_20"
)], 25)


# ---------------- Step 4: Handle NA Values ----------------
# NA values are introduced due to lagging and rolling calculations.
# These rows are removed to ensure complete feature availability.

rows_before <- nrow(netflix)

netflix <- na.omit(netflix)

rows_after <- nrow(netflix)

# Check dimension change
cat("Rows before NA removal:", rows_before, "\n")
cat("Rows after NA removal:", rows_after, "\n")
cat("Rows removed:", rows_before - rows_after, "\n")

# ---------------- Step 5: Correlation Analysis ----------------
# Select numeric features only
numeric_data <- netflix %>%
  select(where(is.numeric))

numeric_data

# Compute correlation matrix
cor_matrix <- cor(numeric_data)
cor_matrix

# Visualize correlation matrix
corrplot(
  cor_matrix,
  method = "color",
  type = "upper",
  tl.cex = 0.8,
  title = "Correlation Matrix of Engineered Features",
  mar = c(0, 0, 1, 0)
)

# ---------------- Step 6: Interpretation Notes ----------------
# Key Observations:
# - Close price is strongly correlated with moving averages
# - Lag features show meaningful predictive relationships
# - Volatility has weaker correlation with price but captures risk
# - Volume is relatively less correlated with price movements

# ---------------- Step 7: Save Feature-Engineered Dataset ----------------
write.csv(
  netflix,
  "./data/NFLX_features.csv",
  row.names = FALSE
)

# ---------------- Step 8: Save Correlation Matrix (Optional) ----------------
write.csv(
  cor_matrix,
  "./outputs/tables/Feature_Correlation_Matrix.csv"
)

############################################################
# End of Feature Engineering & Correlation Script
############################################################
