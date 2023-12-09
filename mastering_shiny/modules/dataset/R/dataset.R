library(shiny)

datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(get(input$dataset, "package:datasets"))
  })
}

datasetInput <- function(id, filter = NULL) {
  names <- ls("package:datasets")
  if (!is.null(filter)) {
    data <- lapply(names, get, "package:datasets")
    names <- names[vapply(data, filter, logical(1))]
  }
  
  selectInput(NS(id, "dataset"), "Pick a dataset", choices = names)
}

selectVarInput <- function(id) {
  selectInput(NS(id, "var"), "Variable", choices = NULL) 
}

find_vars <- function(data, filter) {
  names(data)[vapply(data, filter, logical(1))]
}

selectVarServer <- function(id, data, filter = is.numeric) {
  moduleServer(id, function(input, output, session) {
    observeEvent(data(), {
      updateSelectInput(session, "var", choices = find_vars(data(), filter))
    })
    
    reactive(data()[[input$var]])
  })
}