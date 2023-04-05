library(httr)
library(stringr)

api_key <- readLines("OpenAI_API_key.txt")

ask_chatgpt <- function(prompt, clean_history = F) {
  
  if(clean_history == T || !exists("history_log"))
  {history_log <- list()}
  
  history_log[[length(history_log) + 1]] <- list(
    role = "user",
    #time = date(),
    content = prompt)
  
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
        content = paste(unlist(lapply(history_log, paste, collapse=" ")), collapse = " ")))))
  
  response.text <- str_trim(content(response)$choices[[1]]$message$content)
  
  history_log[[length(history_log) + 1]] <- list(
    role = "chatbot",
    #time = date(),
    content = response.text)
  
  history_log <<- history_log

  return(response.text)
}

# CONVERSATION FLOW DEMO
ask_chatgpt("What is the M1 monetary aggregate?")
ask_chatgpt("What was the last question?")
ask_chatgpt("And how would you answer that?")

# TEST MEMORY WIPE
ask_chatgpt("Do you remember the context of this conversation?")
ask_chatgpt("Do you remember the context of this conversation?", clean_history = T)
