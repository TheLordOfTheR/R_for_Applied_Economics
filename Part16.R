library(httr)
library(stringr)

api_key <- readLines("OpenAI_API_key.txt")

# Calls the ChatGPT API with the given prompt and returns the answer
ask_chatgpt <- function(prompt) {
  
  response <- POST(
    # URL address we target
    url = "https://api.openai.com/v1/chat/completions", 
    add_headers(Authorization = paste("Bearer", api_key)),
    content_type_json(),
    # we wrap the conversation into json format
    encode = "json",
    body = list(
      model = "gpt-3.5-turbo",
      messages = list(list(
        role = "user", 
        content = prompt
      ))
    )
  )
  cat(str_trim(content(response)$choices[[1]]$message$content))
  
}

ask_chatgpt("Does it work?")

ask_chatgpt("What could you say about factors, affecting inflation in various EU countries?")

ask_chatgpt("But what else?")
