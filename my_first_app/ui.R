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
      ),
      accordion_panel(
        "Mapping",
        selectInput(
          "mapping_location", "Location",
          location_choices,
          multiple = FALSE,
          selectize = TRUE
        ),
        sliderInput(
          "map_zoom", 
          "Zoom",
          min = 2, 
          max = 18,
          step = 2,
          value = 16
        )
      ),
      accordion_panel(
        "File Management",
        actionButton("download_data", "Download Dataset")
      )
    )
  ),
  
  navset_card_underline(
    title = "Outputs",
    nav_panel(
      "Plot", 
      card(
        plotlyOutput("plot"),
        full_screen = TRUE
      )
    ),
    nav_panel(
      "Summary", 
      card(
        dataTableOutput("summary"),
        full_screen = TRUE
      )
    ),
    nav_panel(
      "Data Table", 
      card(
        dataTableOutput("table"),
        full_screen = TRUE
      )
    ),
    nav_panel(
      "Histograms", 
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
    ),
    nav_panel(
      "World Map", 
      card(
        leafletOutput("world_map"),
        full_screen = TRUE
      )
    ),

  )
)  
