library(shinythemes)
library(shiny)
library(forecast)
library(shinydashboard)
library(tidyquant)
library(ggplot2)
library(tsfknn)
library(prophet)
library(dplyr)

source("data.R")

server <- function(input, output) {
  
  output$plot1<-renderPlot({
    df<-filter(df, symbol==input$drop)
    df %>% 
      ggplot(aes(x=date , y=close))+
      geom_line(color = palette_dark()[[1]])+
      scale_y_log10()+
      geom_smooth(method = "lm")+
      labs(y = "price"  , x = "")+
      theme_minimal()
  })
  output$plot2<-renderPlot({
    df<-filter(df, symbol==input$drop)
    df %>% 
      ggplot(aes(x=date , y=close))+
      geom_line()+xlab("")+theme_minimal()
  })
  output$plot3<-renderPlot({
    df<-filter(df, symbol==input$drop)
    df %>% tail(100) %>% 
      ggplot(aes(x = date, y = close, open = open,
                 high = high, low = low, close = close)) +
      geom_candlestick() +
      geom_bbands(ma_fun = SMA, sd = 2, n = 20 ,linetype = 5) +
      labs(y = "Closing Price", x = "") + 
      theme_minimal()
  })
  output$plot4<-renderPlot({
    df<-filter(df, symbol==input$drop)
    df %>% 
      ggplot(aes(x = date , y = volume))+
      geom_segment(aes(xend = date , yend = 0 , color = volume))+
      geom_smooth(method = "loess" ,se = F)+
      labs(y="volume" , x="")+
      scale_color_gradient(low = "#249cd4" , high="#0c7829")+
      theme_minimal()+
      theme(legend.position = "none")
  })
  output$plot5<-renderPlot({
    df<-filter(df, symbol==input$drop)
    apple_returns<-df %>% 
      tq_transmute(
        select = close,
        mutate_fun = periodReturn,
        period = "yearly",
        col_rename ="yearly_returns" 
      )
    apple_returns %>% 
      ggplot(aes(x = year(date) , y = yearly_returns))+
      geom_bar(position = "dodge" , stat = "identity" , fill="#4282eb")+
      labs(y = "retruns" , x="")+
      scale_y_continuous(labels = scales::percent)+
      coord_flip()+
      theme_minimal()+
      scale_fill_tq()
  })
  output$plot6<-renderPlot({
    df<-filter(df, symbol==input$drop)
    apple_returns_1<-df %>% 
      tq_transmute(
        select = close,
        mutate_fun = periodReturn,
        period = "yearly",
        type = "log",
        col_rename ="yearly_return" 
      )
    apple_returns_1 %>% 
      ggplot(aes(x = year(date) , y=yearly_return))+
      geom_hline(yintercept = 0  , color = palette_light()[[1]])+
      geom_point(size = 3 , color = palette_light()[[3]])+
      geom_line(size = 1 , color = palette_light()[[3]])+
      geom_smooth(method = "lm" , se = F)+
      labs(x = "" , y = "annual returns")+
      theme_minimal()
  })
  output$plot7<-renderPlot({
    df<-filter(df, symbol==input$drop)
    apple_returns_2<-df %>% 
      tq_transmute(
        select = close,
        mutate_fun = periodReturn,
        period = "daily",
        type = "log",
        col_rename ="monthly_return" 
      )
    
    apple_returns_2 %>%
      ggplot(aes(x = monthly_return ,fill=""))+
      geom_density(alpha=0.7, color = "blue")+
      labs(y = "density" , x = "monthly returns")+
      theme_minimal()+
      scale_fill_tq()+theme(legend.position = "none")
  })
  output$plot8<-renderPlot({
    df<-filter(df, symbol==input$drop)
    appl_macd<-df %>% tail(300) %>% 
      tq_mutate(
        select = close,
        mutate_fun = MACD , 
        nFast = 15,
        nSlow = 25,
        nSig = 9,
        maType = SMA
      ) %>% 
      mutate(diff = macd - signal) %>% 
      select(-(open:volume))
    
    appl_macd %>% 
      ggplot(aes(x = date))+
      geom_hline(yintercept = 0 , color = palette_light()[[1]])+
      geom_line(aes(y=macd ))+
      geom_line(aes(y = signal) , color  ="red" , linetype = 2)+
      geom_bar(aes(y = diff) ,stat = "identity" , color = palette_dark()[[1]])+
      labs(y = "MACD" , x = "")+
      theme_minimal()+
      scale_color_tq()
  })
  output$plot9<-renderPlot({
    df<-filter(df, symbol==input$drop)
    ggAcf(df$close)+theme_minimal()+labs(title = "acf plot")
  })
  output$plot10<-renderPlot({
    df<-filter(df, symbol==input$drop)
    ggPacf(df$close , main = "pacf")+theme_minimal()
  })
  output$plot11<-renderPlot({
    df<-filter(df, symbol==input$drop)
    auto_arima<-auto.arima(df$close, lambda = "auto") 
      autoplot(forecast(auto_arima ,input$slider))+theme_minimal()
  })
  output$plot12<-renderPlot({
    df<-filter(df, symbol==input$drop)
    dataset<-data.frame(ds = df$date , y  = as.numeric(df$close))
    prophet_1<-prophet(dataset)
    future<- make_future_dataframe(prophet_1 , periods =input$slider)
    forecastprophet <-predict(prophet_1 , future)
    plot(prophet_1 ,forecastprophet , xlab="time" , ylab="")
    
  })
  output$plot13<-renderPlot({
    df<-filter(df, symbol==input$drop)
    prophet_plot_components(prophet_1 , forecastprophet)+theme_minimal()
  })
  output$plot14<-renderPlot({
    df<-filter(df, symbol==input$drop)
    dataset_knn<-data.frame(ds = df$date , y  = as.numeric(df$close))
    predknn <- knn_forecasting(dataset_knn$y , h = input$slider , lags = 1:30 , k = 3 , msas = "MIMO")
    autoplot(predknn)+theme_minimal()
  })
}







