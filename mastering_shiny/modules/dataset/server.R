server <- function(input, output, session) {
  data <- datasetServer("data")
  var <- selectVarServer("var", data, filter = filter)
  output$out <- renderPrint(var())
}