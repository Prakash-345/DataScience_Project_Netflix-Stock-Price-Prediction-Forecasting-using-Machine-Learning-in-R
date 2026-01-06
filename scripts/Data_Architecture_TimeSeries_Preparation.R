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
