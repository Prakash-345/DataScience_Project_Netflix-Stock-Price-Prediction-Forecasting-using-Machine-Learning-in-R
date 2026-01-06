############################################################
# Data_Architecture_TimeSeries_Preparation.R
# Role: Data Architect & Time-Series Engineer
# Task: Dataset Exploration, Data Cleaning,
#       Time-Series Conversion, Integration & Scaling
############################################################

# ---------------- Step 1: Import Dataset ----------------
netflix_raw <- read.csv("./data/NFLX.csv")

# Preview dataset
dim(netflix_raw)
head(netflix_raw)
tail(netflix_raw)

# ---------------- Step 2: Initial Dataset Exploration ----------------
str(netflix_raw)
summary(netflix_raw)

# ---------------- Step 3: Data Quality Assessment ----------------

# Check for missing values
colSums(is.na(netflix_raw))

# Check for duplicate records
sum(duplicated(netflix_raw))

# Validate Date column type
class(netflix_raw$Date)

# ---------------- Step 4: Data Cleaning ----------------

# Convert Date column to Date format
netflix_raw$Date <- as.Date(netflix_raw$Date)

# Remove duplicate rows if exists
netflix_clean <- netflix_raw[!duplicated(netflix_raw), ]
netflix_clean

# ---------------- Step 5: Missing Value Handling ----------------
# Forward fill is applied as stock prices are time-dependent

library(zoo)

cols_to_fill <- c("Open", "High", "Low", "Close", "Adj.Close", "Volume")
netflix_clean[cols_to_fill] <- lapply(
  netflix_clean[cols_to_fill],
  na.locf
)
netflix_clean

# Verify missing values after treatment
colSums(is.na(netflix_clean))

# ---------------- Step 6: Post-cleaning Validation ----------------
str(netflix_clean)
summary(netflix_clean)

# ---------------- Step 7: Export Cleaned Dataset ----------------
write.csv(netflix_clean, "./data/NFLX_cleaned.csv", row.names = FALSE)


# ---------------- Step 8: Load Cleaned Dataset ----------------
netflix <- read.csv("./data/NFLX_cleaned.csv")

# Validate dataset integrity
str(netflix)
summary(netflix)

# ---------------- Step 9: Chronological Ordering ----------------
# Stock data must be sorted chronologically

netflix$Date <- as.Date(netflix$Date)

# Verify ordering before sorting
head(netflix$Date)
tail(netflix$Date)

# Sort dataset by Date
netflix <- netflix[order(netflix$Date), ]

# Verify ordering after sorting
head(netflix$Date)
tail(netflix$Date)


# ---------------- Step 10: Time-Series Conversion ----------------
# xts is used as it is optimized for financial time-series data

library(xts)

netflix_xts <- xts(
  netflix[, c("Open", "High", "Low", "Close", "Adj.Close", "Volume")],
  order.by = netflix$Date
)

head(netflix_xts)
tail(netflix_xts)

# ---------------- Step 11: Structural Feature Integration ----------------
# Moving averages are added to capture short- and long-term trends

library(TTR)

netflix_xts$MA_20 <- SMA(netflix_xts$Close, n = 20)
netflix_xts$MA_50 <- SMA(netflix_xts$Close, n = 50)
netflix_xts

# ---------------- Step 12: Convert Time-Series to Data Frame ----------------
# Required for EDA, feature engineering, and ML models

netflix_structured <- data.frame(
  Date = index(netflix_xts),
  coredata(netflix_xts)
)
netflix_structured

# ---------------- Step 13: Save Structured Outputs ----------------
saveRDS(netflix_xts, "./data/NFLX_timeseries.rds")
write.csv(netflix_structured, "./data/NFLX_structured.csv", row.names = FALSE)
