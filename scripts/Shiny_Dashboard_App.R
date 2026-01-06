############################################################
# Shiny_Dashboard_App.R
# Role: Insights Lead
# Task: Interactive Visualization & Model Insights
############################################################

library(shiny)
library(ggplot2)
library(DT)
library(reshape2)

# ---------------- Load Data ----------------
results <- read.csv("./data/results.csv")
metrics <- read.csv("./data/Model_Evaluation_Results.csv")

results$Date <- as.Date(results$Date)

# ---------------- UI ----------------
ui <- fluidPage(
  
  titlePanel("Netflix Stock Price Prediction & Forecasting Dashboard"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Model Selection"),
      selectInput(
        inputId = "model",
        label   = "Choose Model:",
        choices = c("Linear", "RandomForest", "ARIMA"),
        selected = "RandomForest"
      ),
      hr(),
      helpText(
        "This dashboard provides an interactive comparison of stock price predictions ",
        "and quantitative evaluation metrics for different models."
      )
    ),
    
    mainPanel(
      tabsetPanel(
        
        # -------- Tab 1: Actual vs Predicted --------
        tabPanel(
          "Actual vs Predicted",
          plotOutput("predictionPlot", height = "420px")
        ),
        
        # -------- Tab 2: Evaluation Metrics --------
        tabPanel(
          "Model Evaluation",
          DTOutput("metricsTable")
        ),
        
        # -------- Tab 3: Error Comparison --------
        tabPanel(
          "Error Comparison",
          plotOutput("errorPlot", height = "420px")
        ),
        
        # -------- Tab 4: Insights --------
        tabPanel(
          "Insights",
          verbatimTextOutput("insightsText")
        )
      )
    )
  )
)

# ---------------- SERVER ----------------
server <- function(input, output) {
  
  # Actual vs Predicted Plot
  output$predictionPlot <- renderPlot({
    
    ggplot(results, aes(x = Date)) +
      geom_line(aes(y = Actual, color = "Actual"), linewidth = 0.8) +
      geom_line(aes_string(y = input$model, color = shQuote(input$model)),
                linewidth = 0.8) +
      labs(
        title = paste("Actual vs", input$model, "Predicted Prices"),
        x = "Date",
        y = "Closing Price"
      ) +
      scale_color_manual(
        values = c(
          "Actual" = "black",
          "Linear" = "blue",
          "RandomForest" = "green",
          "ARIMA" = "red"
        )
      ) +
      theme_minimal()
  })
  
  # Evaluation Metrics Table
  output$metricsTable <- renderDT({
    datatable(
      metrics,
      options = list(pageLength = 5),
      rownames = FALSE
    )
  })
  
  # Error Comparison Plot
  output$errorPlot <- renderPlot({
    
    metrics_long <- melt(
      metrics,
      id.vars = "Model",
      measure.vars = c("MAE", "RMSE", "MAPE")
    )
    
    ggplot(metrics_long, aes(x = Model, y = value, fill = variable)) +
      geom_bar(stat = "identity", position = "dodge") +
      labs(
        title = "Error Metrics Comparison Across Models",
        x = "Model",
        y = "Error Value"
      ) +
      theme_minimal()
  })
  
  # Insights Text
  output$insightsText <- renderText({
    paste(
      "Key Insights:\n\n",
      "- Random Forest shows the lowest error values across MAE, RMSE, and MAPE, ",
      "indicating superior predictive performance.\n\n",
      "- Linear Regression acts as a baseline model and performs reasonably ",
      "well but struggles with non-linear patterns.\n\n",
      "- ARIMA captures temporal trends but is less effective in modeling ",
      "complex market dynamics.\n\n",
      "- Ensemble-based and non-linear models are more suitable for ",
      "financial time-series prediction."
    )
  })
}

# ---------------- Run App ----------------
shinyApp(ui = ui, server = server)
