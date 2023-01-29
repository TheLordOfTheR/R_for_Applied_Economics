# chunk 1
# local functions (here we will create a generic functions based on web-scraping script we got from part 1)
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

#chunk 2
# LET'S TRY TO CATCH EXCEPTIONS

# let's call the function without any arguments 
# parse_web_table()

# let's call the function with some wrong link (e.g. without any tables)
# parse_web_table("https://twitter.com/teconomics")

# let's call the function with some wrong link - 2 (e.g. broken link)
# parse_web_table("tradingeconomics.com/country-list/unemployment-rate?continent=europe")


# chunk 3
# LET'S USE THE FUNCTION TO GET DATA

# let's call the function with the desired link
# parse_web_table("https://tradingeconomics.com/country-list/inflation-rate?continent=europe")

# let's call the function with another desired link
# parse_web_table("https://tradingeconomics.com/country-list/unemployment-rate?continent=europe")

# let's call the function with completely other link with a table 
# parse_web_table("https://en.wikipedia.org/wiki/List_of_countries_by_GDP_(PPP)_per_capita", table_number = 2)



