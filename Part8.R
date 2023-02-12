# chunk 1
# packages

library(ggplot2) # for beautiful charts
library(scales) # for beautiful scaling
library(zoo) # for moving average function
library(devtools) # for web-parsing of source codes
library(ggrepel) # to attach country names to data dots

# system settings
Sys.setlocale("LC_TIME", "English")

#preparation of dataset 1

#read our github function to parse data from ECB website
source_url("https://raw.githubusercontent.com/TheLordOfTheR/R_for_Applied_Economics/main/Part1.R")
df <- clean_df

plot1 <- ggplot(df, aes(x = Period, y = Inflation)) +
  geom_line(aes(color = "Inflation"), #show.legend = F,
            size = 0.8) + 
  theme_bw() + 
  xlab('Period of observation') + 
  ylab('Inflation rate, %') + 
  ggtitle("Inflation in European Union") + 
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1))+
  scale_x_date(date_breaks = "6 months",
               date_labels = "%b %y",
               expand = c(0.01,0.01)) + 
  scale_y_continuous(breaks=c(seq(0,max(df$Inflation),1))) +
  geom_hline(aes(yintercept=2, color = "Target threshold 2%"),
             size=1) + 
  geom_line(aes(y=rollmean(Inflation, 12, na.pad=TRUE), color = "MA(12)"),
            show.legend = TRUE) + 
  theme(plot.title = element_text(hjust = 0.5),
        text=element_text(size=12,family="Comic Sans MS")) + 
  theme(legend.position="top") + 
  scale_color_manual(name = "",
                     values = c("black", "blue", "red"),
                     labels = c("Inflation", "MA(12)", "Target 2%"))

# preparation of dataset 2
# start with our previously made function for parsing data from TradingEconomics
parse_tradecon_table <- function(link = "", table_number = 1, indicator_name = "value")
{
  # we call the package inside of the function so it is called automatically every time you use the function
  library(rvest)
  library(dplyr)
  
  # here we check the provided link for being non-empty string
  if(link == "")
  {stop("No URL provided")}
  
  # then we try to parse the URL, but if it fails - we print error message and stop function
  try(parsed_data <- read_html(link), stop("Something went wrong...Please, check the link you provided."))
  try(parsed_table <- html_table(parsed_data), stop("Something went wrong...Seems like there are no tables available."))
  try(df <- as.data.frame(parsed_table[[table_number]]), stop(paste0("Something went wrong...Seems like the link does not have table number ",table_number, " or any tables at all")))
  
  output_df <- df %>% 
    select(Country, Last) %>%
    rename(!!indicator_name := Last, country = Country)
  
  return(output_df)
}


infl_df <- parse_tradecon_table("https://tradingeconomics.com/country-list/inflation-rate?continent=europe", indicator_name = "inflation")
unemp_df <- parse_tradecon_table("https://tradingeconomics.com/country-list/unemployment-rate?continent=europe", indicator_name = "unemployment")
gdp_df <- parse_tradecon_table("https://tradingeconomics.com/country-list/gdp-annual-growth-rate?continent=europe", indicator_name = "gdp_growth")

merged_df <- infl_df %>% 
  full_join(unemp_df, by = c("country")) %>%
  full_join(gdp_df, by = c("country"))

european_union <- c("Austria","Belgium","Bulgaria","Croatia","Cyprus",
                    "Czech Republic","Denmark","Estonia","Finland","France",
                    "Germany","Greece","Hungary","Ireland","Italy","Latvia",
                    "Lithuania","Luxembourg","Malta","Netherlands","Poland",
                    "Portugal","Romania","Slovakia","Slovenia","Spain",
                    "Sweden","United Kingdom")

merged_df$eu_country <- factor(ifelse(merged_df$country %in% european_union, "EU-countries", "Other countries"))

plot2 <- ggplot(merged_df, aes(x = inflation, y = gdp_growth, color = eu_country, size = (unemployment^2))) +
  geom_point() +
  geom_text_repel(aes(label = substr(country, 1, 3)), size = 3) +
  scale_color_manual(name = "EU Status", values = c("EU-countries" = "red", "Other countries" = "black")) +
  scale_size_continuous(name = "Unemployment", range = c(2, 7), guide = FALSE) +
  xlab("Inflation rate") +
  ylab("GDP growth rate") +
  ggtitle("Scatter plot of EU and non-EU countries by \n Inflation vs GDP Growth in Europe (size by Unemployment)") +
  theme(legend.title = element_text(size = 12, face = "bold"), 
        legend.text = element_text(size = 10), 
        plot.title = element_text(size = 14, face = "bold", hjust = 0.5), 
        axis.title = element_text(size = 12, face = "bold"))

plot3 <- ggplot(merged_df, aes(x = inflation, y = gdp_growth, color = unemployment)) +
  geom_point() +
  geom_text_repel(aes(label = substr(country, 1, 3)), size = 3) +
  scale_color_continuous(name = "Unemployment rate, %", low = "blue", high = "red") +
  scale_size_continuous(name = "Unemployment rate, %", range = c(2, 7), guide = FALSE) +
  xlab("Inflation rate") +
  ylab("GDP growth rate") +
  ggtitle("Scatter plot of EU and non-EU countries by \n Inflation, GDP Growth, and Unemployment in Europe") +
  theme(legend.title = element_text(size = 12, face = "bold"), 
        legend.text = element_text(size = 10), 
        plot.title = element_text(size = 14, face = "bold", hjust = 0.5), 
        axis.title = element_text(size = 12, face = "bold")) +
  facet_wrap(~eu_country, ncol = 2)
