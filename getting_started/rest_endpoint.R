library(shiny)
library(jsonlite)
library(callr)
library(datasets)

ui <- function(req) {
 
  query_params <- parseQueryString(req$QUERY_STRING)
  body_bytes <- req$rook.input$read(-1)
  print(query_params)
  print(body_bytes)
  
  if (identical(req$REQUEST_METHOD, "GET")) {
    
    if(req$PATH_INFO == "/") {
      fluidPage(
        h1("Accepting GET requests")
      )   
    } else if(req$PATH_INFO == "/metrics") {
      # Expose Prometheus endpoint
      
      httpResponse(
        status = 200L,
        content_type = "application/json",
        content = jsonlite::toJSON(iris, dataframe = "columns")
      )
    }
  }
}
attr(ui, "http_methods_supported") <- c("GET", "POST")

server <- function(input, output, session) {}

app <- shinyApp(ui, server, uiPattern = ".*")
