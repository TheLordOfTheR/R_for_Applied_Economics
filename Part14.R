library(RSQLite)
con <- dbConnect(RSQLite::SQLite(), "economic_data.db")

dbGetQuery(con, "SELECT name FROM sqlite_master WHERE type='table'")
dbGetQuery(con, "SELECT * FROM sqlite_master WHERE type='table'")

inflation <- dbGetQuery(con, "SELECT * FROM fct_inflation")
head(inflation);tail(inflation)

# step 1. renaming
dbExecute(con, "ALTER TABLE fct_inflation RENAME COLUMN Period TO Period_number")
head(dbGetQuery(con, "SELECT * FROM fct_inflation"))

# step 2. new column creation
dbExecute(con, "ALTER TABLE fct_inflation ADD COLUMN Period TYPE DATE")
head(dbGetQuery(con, "SELECT * FROM fct_inflation"))

# step 3. updating date values
dbExecute(con, "UPDATE fct_inflation SET Period = date('1970-01-01', Period_number || ' days')")
head(dbGetQuery(con, "SELECT * FROM fct_inflation"))


dbDisconnect(con)
