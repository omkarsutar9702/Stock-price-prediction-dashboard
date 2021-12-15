#import data set----

df<-tq_get(c("ASIANPAINT.BO","AXISBANK.BO","BAJAJ-AUTO.BO","BAJFINANCE.BO","HCLTECH.BO","HDFC.BO","HDFC.BO","ICICIBANK.BO") ,get = "stock.prices", from = "2017-01-01")

#fit the prophet model----
dataset<-data.frame(ds = df$date , y  = as.numeric(df$close))
prophet_1<-prophet(dataset)

#fit the forecast prophet model-----
future<- make_future_dataframe(prophet_1 , periods =30)
forecastprophet <-predict(prophet_1 , future)

#fit knn model----
dataset_knn<-data.frame(ds = df$date , y  = as.numeric(df$close))
predknn <- knn_forecasting(dataset_knn$y , h = 30 , lags = 1:30 , k = 3 , msas = "MIMO")


