# firstly we recover data we made in part 8
library(devtools)
source("https://raw.githubusercontent.com/TheLordOfTheR/R_for_Applied_Economics/main/Part8.R")

library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), "economic_data.db")

# Write the inflation dataset named df into a table named fct_inflation
dbWriteTable(con, "fct_inflation", df)
# List all the tables available in the database
dbListTables(con)

# remove the fct_inflation
dbRemoveTable(con, "fct_inflation")
dbListTables(con)

#restore the fct_inflation
dbWriteTable(con, "fct_inflation", df)
dbListTables(con)

# first select query
results <- dbGetQuery(con, "SELECT * FROM fct_inflation")
glimpse(results)

# close the session with the file
dbDisconnect(con)
