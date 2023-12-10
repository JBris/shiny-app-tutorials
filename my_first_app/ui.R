dataset_choices <- c(
  "iris", "mtcars"
)

ui <- page_sidebar(
  title = "Data Dashboard",
  
  theme = bs_theme(
    bootswatch = "lux",
    base_font = font_google("Inter"),
    navbar_bg = "#4a8273",
    font_scale = 0.8
  ),
  
  sidebar = sidebar(
    bg = "white",
    accordion(
      accordion_panel(
        "Inputs",
        selectInput(
          "dataset", "Dataset",
          dataset_choices,
          multiple = FALSE,
          selectize = TRUE
        ),
        selectInput(
          "x_col",
          "X column",
          character(0),
          multiple = FALSE,
          selectize = TRUE
        ),
        selectInput(
          "y_col",
          "Y column",
          character(0),
          multiple = FALSE,
          selectize = TRUE
        )
      )
    )
  ),
  
  navset_card_underline(
    title = "Outputs",
    nav_panel("Plot", plotlyOutput("plot")),
    nav_panel("Summary", verbatimTextOutput("summary")),
    nav_panel("Table", dataTableOutput("table")),
    nav_panel(
      "Histogram", 
      layout_columns(
        card(
          plotlyOutput("histogram_x"),
          full_screen = TRUE
        ),
        card(
          plotlyOutput("histogram_y"),
          full_screen = TRUE
        )
      )
    )

  )
)  
