# chunk 1
library(ggplot2) 

# Load data 
data(mtcars) 

# Create scatter plot with 2 dimensions
ggplot(mtcars, aes(x = wt, y = mpg)) + 
  geom_point() +
  xlab("Weight (1000 lbs)") +
  ylab("Miles per Gallon")


# chunk 2
# Create a ggplot object using the mtcars data set
ggplot(mtcars, aes(x = wt, y = mpg, color = factor(cyl), size = hp, shape = factor(am))) + 
  
  # Add the geom_point layer to the plot, which will create the scatter plot
  geom_point() +
  # Label the x-axis as "Weight (1000 lbs)"
  xlab("Weight (1000 lbs)") +
  # Label the y-axis as "Miles per Gallon"
  ylab("Miles per Gallon") +
  # Add a discrete color scale, labeling the scale as "Number of Cylinders"
  scale_color_discrete(name = "Number of Cylinders") +
  # Add a continuous size scale, labeling the scale as "Horsepower"
  scale_size_continuous(name = "Horsepower") +
  # Add a discrete shape scale, labeling the scale as "Transmission"
  scale_shape_discrete(name = "Transmission") +
  # Apply the classic ggplot2 theme to the plot
  theme_classic()


# chunk 3
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

# chunk 4
# Load necessary packages
library(ggrepel)

# Plot data with ggplot2
ggplot(merged_df, aes(x = inflation, y = gdp_growth, color = eu_country, size = (unemployment^2))) +
  geom_point() +
  geom_text_repel(aes(label = substr(country, 1, 3)), size = 3) +
  scale_color_manual(name = "EU Status", values = c("EU-countries" = "red", "Other countries" = "black")) +
  scale_size_continuous(name = "Unemployment", range = c(2, 7), guide = FALSE) +
  xlab("Inflation rate") +
  ylab("GDP growth rate") +
  ggtitle("Scatter plot of EU and non-EU countries by Inflation vs GDP Growth in Europe (size by Unemployment)") +
  theme(legend.title = element_text(size = 12, face = "bold"), 
        legend.text = element_text(size = 10), 
        plot.title = element_text(size = 14, face = "bold", hjust = 0.5), 
        axis.title = element_text(size = 12, face = "bold"))

# chunk 5 - facet demo
# Plot data with ggplot2
ggplot(merged_df, aes(x = inflation, y = gdp_growth, color = unemployment)) +
  geom_point() +
  geom_text_repel(aes(label = substr(country, 1, 3)), size = 3) +
  scale_color_continuous(name = "Unemployment rate, %", low = "blue", high = "red") +
  scale_size_continuous(name = "Unemployment rate, %", range = c(2, 7), guide = FALSE) +
  xlab("Inflation rate") +
  ylab("GDP growth rate") +
  ggtitle("Scatter plot of EU and non-EU countries by Inflation, GDP Growth, and Unemployment in Europe") +
  theme(legend.title = element_text(size = 12, face = "bold"), 
        legend.text = element_text(size = 10), 
        plot.title = element_text(size = 14, face = "bold", hjust = 0.5), 
        axis.title = element_text(size = 12, face = "bold")) +
  facet_wrap(~eu_country, ncol = 2)

