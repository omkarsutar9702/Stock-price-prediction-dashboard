library(shinythemes)
library(shiny)
library(forecast)
library(shinydashboard)
library(tidyquant)
library(ggplot2)
library(tsfknn)
library(prophet)
library(dplyr)


ui <- dashboardPage(skin = "blue",
                    dashboardHeader(title = "Stock Data Analysis"),
                    dashboardSidebar(
                      sidebarMenu(
                        selectInput(inputId = "drop" , label = "Choose the symbol" ,list("ASIANPAINT.BO","AXISBANK.BO","BAJAJ-AUTO.BO","BAJFINANCE.BO","HCLTECH.BO","HDFC.BO","HDFC.BO","ICICIBANK.BO")),
                        menuItem("Data visualisation -1" , tabName = "dash",icon = icon("chart-bar")),
                        menuItem("Data visualisation -2" , tabName = "page",icon = icon("chart-area")),
                        menuItem("Time-series -1",tabName = "time-series-1",icon = icon("chart-pie")),
                        menuItem("time-series -2",tabName = "time-series-2" , icon = icon("chart-line")),
                        sliderInput("slider" , "Choose No. Of Days To Forecast:" , min=0 , max=360,value=50 , step = 10)
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = "dash",
                                fluidRow(
                                  box(title = "Time Series",
                                      status = "primary", solidHeader = TRUE,
                                      collapsible = TRUE,plotOutput("plot2")),
                                  box(title = "Regression line",
                                      status = "primary", solidHeader = TRUE,
                                      collapsible = TRUE,plotOutput("plot1")),
                                  box(title = "Bar Chart Of Volume" , status = "primary",
                                      collapsible = TRUE,solidHeader = TRUE,
                                      plotOutput("plot4")),
                                  box(title = "Yearly Returns" , status = "primary",
                                      collapsible = TRUE,solidHeader = TRUE,
                                      plotOutput("plot5"))
                                )
                        ),
                        tabItem(tabName="page",
                                fluidRow(
                                  box(title = "Bollinger Bands",
                                      status = "primary", solidHeader = TRUE,
                                      collapsible = TRUE,plotOutput("plot3")),
                                  box(title = "Trends In Annual Returns",
                                      status = "primary",solidHeader = TRUE,
                                      collapsible = TRUE,plotOutput("plot6")),
                                  box(title = "Daily Log Returns" , status = "primary",
                                      solidHeader = TRUE,collapsible = TRUE,plotOutput("plot7")),
                                  box(title = "MACD" , status = "primary",solidHeader = TRUE,
                                      collapsible = TRUE ,plotOutput("plot8"))
                                )),
                        tabItem(tabName = "time-series-1",
                                fluidRow(
                                  box(title = "ACF Plot" , status = "primary",
                                      collapsible = TRUE,solidHeader = TRUE ,
                                      plotOutput("plot9")),
                                  box(title = "PACF Plot" , status = "primary",
                                      collapsible = TRUE,solidHeader = TRUE ,
                                      plotOutput("plot10")),
                                  box(title = "AUTO-ARIMA" , status = "primary",
                                      collapsible = TRUE,solidHeader = TRUE,
                                      plotOutput("plot11")),
                                  box(title = "Prophet Model",status = "primary",
                                      collapsible = TRUE,solidHeader = TRUE,
                                      plotOutput("plot12"))
                                )),
                        tabItem(tabName = "time-series-2",
                                fluidRow(
                                  box(title = "Prophet Plot Components" ,status = "primary",
                                      collapsible = TRUE,solidHeader = TRUE,plotOutput("plot13")),
                                  box(title = "KNN Model" , status = "primary",
                                      collapsible = TRUE,solidHeader = TRUE,plotOutput("plot14"))
                                ))
                )
      )
)


