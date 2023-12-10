update_select <- function(session, df_choices, x_col, y_col, id) {
  if(x_col != y_col) {
    return()
  }
  
  indx <- match(x_col, df_choices) + 1
  if(is.na(indx)) { return()}
  
  if(indx > length(df_choices)) {
    indx <- 1
  }
  
  updateSelectizeInput(
    session, id, choices = df_choices, server = FALSE,
    selected = df_choices[indx]
  )
}

server <- function(input, output, session) {
  dataset <- reactive({
    input$dataset
  }) 
  
  x_col <- reactive({
    input$x_col
  })  
  
  y_col <- reactive({
    input$y_col
  })  
  
  df <- reactive({
    read.csv(
      paste0(dataset(), ".csv")
    )
  }) %>%
    bindCache(
      input$dataset
    )
  
  df_choices <- reactive({
    colnames(df())
  })
  
  observeEvent(input$dataset, {
    choices <- df_choices()
    
    progress <- shiny::Progress$new()
    on.exit(progress$close())
    
    progress$set(message = "Loading data...", value = 0)
    
    n <- 10
    for (i in 1:n) { 
      progress$inc(1/n, detail = paste("Progress: ", i/n * 100, "%"))
      Sys.sleep(0.1)
    }
    
    updateSelectizeInput(
      session, "x_col", choices = choices, server = FALSE,
      selected = choices[1]
    )
    
    updateSelectizeInput(
      session, "y_col", choices = choices, server = FALSE,
      selected = choices[2]
    )
    
    showNotification(
      paste("Current Dataset: ", dataset()),
      duration = 1.25,
      type = "message"
    )
  })
  

  output$plot <- renderPlotly({
    df <- df()
    df_choices <- df_choices()
    x_col <- x_col()
    y_col <- y_col()
    
    if((!x_col %in% df_choices) || ( !y_col %in% df_choices)) {
      return()  
    }
    
    (df %>%
        ggplot(
          aes(x=.data[[x_col]], y=.data[[y_col]] )
        ) +
        geom_point() +
        geom_line()) %>%
      ggplotly()
    
  }) 
  
  output$summary <- renderDataTable({
    summary(df()) %>%
      as.data.frame() %>%
      mutate(Variable = Var2, Statistic = Freq) %>%
      select(Variable, Statistic) 
  })

  output$table <- renderDataTable({
    df()  
  })
  
  
  render_histogram <- function(df, df_choices, col_name) {
    if((!col_name %in% df_choices)) {
      return()  
    }
    
    (df %>%
        ggplot(aes(x=.data[[col_name]])) +
        geom_histogram()) %>%
      ggplotly()
  }
  
  output$histogram_x <-  renderPlotly({
    render_histogram(df(), df_choices(), x_col())
  }) 
  
  output$histogram_y <-  renderPlotly({
    render_histogram(df(), df_choices(), y_col())
  })
  
  dataModal <- function(failed = FALSE) {
    modalDialog(
      selectInput(
        "download_dataset", "Download dataset",
        dataset_choices,
        multiple = FALSE,
        selectize = TRUE
      ),
      
      footer = tagList(
        downloadButton("downloadData", "Download"),
        actionButton("download_dataset_ok", "Close")
      )
    )
  }
  
  observeEvent(input$download_data, {
    showModal(dataModal())
  })
  
  download_dataset <- reactive({
    input$download_dataset
  })
  
  df_download <- reactive({
    read.csv(
      paste0(download_dataset(), ".csv")
    )
  }) %>%
    bindCache(
      input$download_dataset
    )
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste0(download_dataset(), "-", Sys.Date(),  ".csv")
    },
    content = function(file) {
      write_csv(df_download(), file)
    }
  )
  
  observeEvent(input$download_dataset_ok, {
    download_dataset <- download_dataset()
    
    if(is.null(download_dataset)){ return() }
    removeModal()
    
    showNotification(
      "Returning home",
      duration = 2.5,
      type = "message"
    )
  })
  
  mapping_location <- reactive({
    input$mapping_location
  })
  
  observeEvent(input$mapping_location, {
    showNotification(
      paste("Current Map: ", input$mapping_location),
      duration = 1.25,
      type = "message"
    )
  })
  
  map_zoom <- reactive({
    input$map_zoom
  })
  
  output$world_map <- renderLeaflet({
    mapping_location_key <- mapping_location() 
    mapping_location <- location_coords[[mapping_location_key]]

    leaflet() %>%
      addTiles(group = "OSM") %>%
      addMarkers(
        lng=mapping_location$lng, 
        lat=mapping_location$lat, 
        popup=mapping_location_key
      ) %>%
      setView(
        lng=mapping_location$lng, 
        lat = mapping_location$lat, 
        zoom = map_zoom()
      )
  })
}