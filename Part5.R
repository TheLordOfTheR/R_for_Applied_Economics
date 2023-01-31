# chunk 1
library(dplyr)

# chunk 2
# local functions (here we will create a generic functions)
parse_web_table <- function(link = "", table_number = 1)
{
  # we call the package inside of the function so it is called automatically every time you use the function
  library(rvest)
  
  # here we check the provided link for being non-empty string
  if(link == "")
  {stop("No URL provided")}
  
  # then we try to parse the URL, but if it fails - we print error message and stop function
  try(parsed_data <- read_html(link), stop("Something went wrong...Please, check the link you provided."))
  try(parsed_table <- html_table(parsed_data), stop("Something went wrong...Seems like there are no tables available."))
  try(df <- as.data.frame(parsed_table[[table_number]]), stop(paste0("Something went wrong...Seems like the link does not have table number ",table_number, " or any tables at all")))
  
  return(df)
}

# chunk 3
# let's call the function with the desired link
infl_df <- parse_web_table("https://tradingeconomics.com/country-list/inflation-rate?continent=europe") %>%
  select(Country, Last) %>%
  rename(infl = Last)

# let's call the function with another desired link
unemp_df <- parse_web_table("https://tradingeconomics.com/country-list/unemployment-rate?continent=europe") %>% 
  select(Country, Last) %>%
  rename(unempl = Last)

glimpse(infl_df)
glimpse(unemp_df)

# chunk 4
join_df <- infl_df %>% 
  inner_join(unemp_df, by = "Country")

join_df %>% glimpse()

# chunk 5
european_union <- c("Austria","Belgium","Bulgaria","Croatia","Cyprus",
                    "Czech Republic","Denmark","Estonia","Finland","France",
                    "Germany","Greece","Hungary","Ireland","Italy","Latvia",
                    "Lithuania","Luxembourg","Malta","Netherlands","Poland",
                    "Portugal","Romania","Slovakia","Slovenia","Spain",
                    "Sweden","United Kingdom")

join_df$eu_country <- factor(ifelse(join_df$Country %in% european_union, "EU-countries", "Other countries"))

plot(join_df$infl, join_df$unempl, col = join_df$eu_country)
legend("topleft", legend = levels(join_df$eu_country), pch = 19, col = factor(levels(join_df$eu_country)))
