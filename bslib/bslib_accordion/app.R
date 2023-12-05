library(shiny)
library(bslib)

library(ggplot2)
data(penguins, package = "palmerpenguins")

cards <- list(
  card(
    full_screen = TRUE,
    card_header("Bill Length"),
    plotOutput("bill_length")
  ),
  card(
    full_screen = TRUE,
    card_header("Bill depth"),
    plotOutput("bill_depth")
  ),
  card(
    full_screen = TRUE,
    card_header("Body Mass"),
    plotOutput("body_mass")
  )
)

color_by <- varSelectInput(
  "color_by", "Color by",
  penguins[c("species", "island", "sex")],
  selected = "species"
)


means <- colMeans(
  penguins[c("bill_length_mm", "bill_depth_mm", "body_mass_g")],
  na.rm = TRUE
)

ui <- page_sidebar(
  title = "Penguins dashboard",

  sidebar = sidebar(
    bg = "white",
    accordion(
      accordion_panel(
        "Primary controls",
        color_by
      ),
      accordion_panel(
        "Other controls",
        "Other controls go here"
      )
    )
  ),

  accordion(
    open = c("Bill Length", "About"),
    accordion_panel(
      "Bill Length",
      plotOutput("bill_length")
    ),
    accordion_panel(
      "Bill Depth",
      plotOutput("bill_depth")
    ),
    accordion_panel(
      "Body Mass",
      plotOutput("body_mass")
    )
  )
)
server <- function(input, output) {
  gg_plot <- reactive({
    ggplot(penguins) +
      geom_density(aes(fill = !!input$color_by), alpha = 0.2) +
      theme_bw(base_size = 16) +
      theme(axis.title = element_blank())
  })

  output$bill_length <- renderPlot(gg_plot() + aes(bill_length_mm))
  output$bill_depth <- renderPlot(gg_plot() + aes(bill_depth_mm))
  output$body_mass <- renderPlot(gg_plot() + aes(body_mass_g))
}

shinyApp(ui, server)