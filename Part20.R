Sys.setlocale("LC_ALL", "English") # for those who have default language different from English

# Attach packages
# install.packages("quantmod")
library(quantmod)
library(ggplot2)

# Define the tickers
tickers <- c("JPM", "BAC", "WFC")

# Download stock data
stock_data <- new.env()
getSymbols(tickers, src = 'yahoo', env = stock_data, from = '2020-01-01', to = Sys.Date())

# Access JPM stock data
jpm_data <- stock_data$JPM
head(jpm_data)

bac_data <- stock_data$BAC
wfc_data <- stock_data$WFC


# Plot adjusted closing prices
chartSeries(stock_data$JPM["2020-01::"], minor.ticks = F,
            theme = chartTheme("white"), 
            type = "line", TA = NULL, 
            name = "JPM - Adjusted Closing Prices")

chartSeries(stock_data$BAC["2020-01::"], minor.ticks = F,
            theme = chartTheme("white"), 
            type = "line", TA = NULL, 
            name = "BAC - Adjusted Closing Prices")

chartSeries(stock_data$WFC["2020-01::"], minor.ticks = F,
            theme = chartTheme("white"), 
            type = "line", TA = NULL, 
            name = "WFC - Adjusted Closing Prices")

# Merge adjusted closing prices
jpm_adj_close <- data.frame(Date=index(jpm_data), 
                            Ticker="JPM", 
                            Adjusted=as.numeric(jpm_data$JPM.Adjusted))
bac_adj_close <- data.frame(Date=index(bac_data),
                            Ticker="BAC", 
                            Adjusted=as.numeric(bac_data$BAC.Adjusted))
wfc_adj_close <- data.frame(Date=index(wfc_data), 
                            Ticker="WFC", 
                            Adjusted=as.numeric(wfc_data$WFC.Adjusted))
combined_adj_close <- rbind(jpm_adj_close, bac_adj_close, wfc_adj_close)

# Plot adjusted closing prices together
ggplot(combined_adj_close, aes(x=Date, y=Adjusted, color=Ticker)) +
  geom_line() +
  labs(title="Adjusted Closing Prices of JPM, BAC, and WFC",
       x="Date",
       y="Adjusted Closing Price") +
  theme_minimal()
