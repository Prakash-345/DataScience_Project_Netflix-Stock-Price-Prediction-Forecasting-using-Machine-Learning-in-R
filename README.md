Netflix Stock Price Prediction & Forecasting (R)
Overview
This project implements a complete data science pipeline to predict and forecast Netflix stock prices using historical market data and machine learning techniques in R. The focus is on understanding price behavior, engineering meaningful features, and comparing multiple predictive models to determine the most reliable approach for volatile financial time-series data.

Motivation
Stock prices are highly volatile and influenced by multiple factors such as market sentiment and economic conditions. Traditional forecasting methods often struggle to adapt to sudden price changes. This project explores whether machine learning models, supported by proper feature engineering, can improve prediction accuracy compared to classical time-series methods.

Key Features
•	End-to-end data preprocessing and time-series preparation
•	Exploratory analysis of trends, distributions, and volatility
•	Feature engineering using lag variables, moving averages, and rolling statistics
•	Comparison of multiple models:
    o	Linear Regression
    o	Random Forest
    o	ARIMA
•	Model evaluation using RMSE
•	Interactive visualization using Shiny

Methodology
1.	Data Preparation
    o	Duplicate removal
    o	Missing value handling using forward fill (LOCF)
    o	Chronological ordering and time-series conversion
2.	Exploratory Data Analysis
    o	Price trend visualization
    o	Volume distribution analysis
    o	Volatility and outlier inspection
3.	Feature Engineering
    o	Lagged closing prices
    o	Moving averages (short-term and long-term)
    o	Daily returns and rolling volatility
4.	Modeling & Evaluation
    o	Time-based train–test split
    o	Model comparison using RMSE
    o	Visual comparison of actual vs predicted prices

Results
•	Linear Regression achieved the lowest RMSE and showed the most stable performance.
•	Random Forest produced smoother predictions but lagged during sharp market movements.
•	ARIMA struggled with non-stationary behavior and high volatility.
Key takeaway: Model effectiveness depended more on data characteristics and feature engineering than on algorithm complexity.

Tech Stack
•	Language: R
•	Core Libraries: zoo, xts, TTR, ggplot2, corrplot
•	Modeling: stats, randomForest, forecast
•	Evaluation: caret
•	Visualization: ggplot2, Shiny
•	Version Control: Git & GitHub

Usage
1.	Run data preprocessing and analysis scripts in sequence.
2.	Execute modeling scripts to generate predictions and evaluation metrics.
3.	Launch the Shiny dashboard for interactive visualization of predictions and RMSE comparison.

Team Contributions
•	Data Architecture & Time-Series Preparation
•	Exploratory Data Analysis
•	Feature Engineering
•	Modeling & Prediction
•	Evaluation, Insights & Reporting
(Each contribution is documented through individual scripts and reports.)

Limitations
•	Uses only historical price and volume data
•	External factors such as news sentiment are not included
•	Designed for short-term analysis rather than long-term investment decisions

Future Enhancements
•	Integration of news sentiment and macroeconomic indicators
•	Advanced models such as Gradient Boosting or LSTM
•	Real-time prediction using live market data
•	Extension to multi-stock or portfolio-level forecasting

License
This project is licensed under the MIT License.

Disclaimer
This project is for educational and research purposes only.
The predictions generated should not be considered financial or investment advice.

