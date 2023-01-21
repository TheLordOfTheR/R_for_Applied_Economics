# chunk 1
# packages
library(rvest)

# chunk 2
# input / extraction
link <- "https://sdw.ecb.europa.eu/quickview.do?SERIES_KEY=122.ICP.M.U2.N.000000.4.ANR"
parsed_data <- read_html(link)
class(parsed_data)
parsed_data

#chunk 3
parsed_table <- html_table(parsed_data)
class(parsed_table)
parsed_table

#chunk 4
# manipulation / transformation
raw_df <- as.data.frame(parsed_table[[6]])
str(raw_df)

#chunk 5
clean_df <- raw_df[3:nrow(raw_df),1:2] # subset raw_df: take all rows starting from 3 and only first 2 columns
names(clean_df) <- c("Period","Inflation") # now we need to rename only those columns, that are relevant

# start with time measure
clean_df$Period <- paste0(clean_df$Period,"-01") # as far as data do not have day, I will just add it for convenience
clean_df$Period_formatted <- as.Date(clean_df$Period,format="%Y-%m-%d") # new column is formatted based on the format settings

# then fix the value column
clean_df$Inflation_formatted <- as.numeric(clean_df$Inflation)

# now we check what we have got, drop redundancies and rename newly created columns
str(clean_df)
clean_df <- clean_df[,3:4]
names(clean_df) <- c("Period","Inflation")

# chunk 6
# output / loading
plot(clean_df, type = "line")

