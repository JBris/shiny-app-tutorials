server <- function(input, output, server) {
  extra <- radioExtraServer("extra")
  output$value <- renderText(paste0("Selected: ", extra()))
}