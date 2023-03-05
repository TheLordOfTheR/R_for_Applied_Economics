library(RSQLite)
library(dplyr)
con <- dbConnect(RSQLite::SQLite(), "economic_data.db")

# test idea 1
idea1 <- dbGetQuery(con, "SELECT Period, Inflation FROM fct_inflation")
head(idea1);tail(idea1)

# test idea 2
idea2 <- dbGetQuery(con, "SELECT * FROM fct_inflation WHERE Period>'2000–01–01'")
head(idea2);tail(idea2)

#joint query
inflation <- dbGetQuery(con, 
"SELECT Period, Inflation
FROM fct_inflation 
WHERE Period>'2000-01-01'")
head(inflation);tail(inflation)

# test number of rows
sql_test1 <- "SELECT count(*) as NUM_OF_ROWS FROM fct_inflation"
test1 <- dbGetQuery(con, sql_test1)
print(test1)

# check formats
sql_test2 <- "SELECT * FROM fct_inflation LIMIT 10;"
test2 <- dbGetQuery(con, sql_test2)
print(test2)


dbDisconnect(con)
