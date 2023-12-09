ui <- fluidPage(
  datasetInput("data", is.data.frame),
  selectVarInput("var"),
  verbatimTextOutput("out")
)