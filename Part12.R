# firstly we recover data we made in part 8
library(devtools)
source("https://raw.githubusercontent.com/TheLordOfTheR/R_for_Applied_Economics/main/Part8.R")

library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), "economic_data.db")

# Write the inflation dataset named df into a table named fct_inflation
dbWriteTable(con, "fct_inflation", df)
# List all the tables available in the database
dbListTables(con)

dbRemoveTable(con, "fct_inflation")
dbListTables(con)

results <- dbGetQuery(con, "SELECT * FROM fct_inflation")
glimpse(results)

dbDisconnect(con)
