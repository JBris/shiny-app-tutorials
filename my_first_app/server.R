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
    updateSelectizeInput(
      session, "x_col", choices = choices, server = FALSE,
      selected = choices[1]
    )
    
    updateSelectizeInput(
      session, "y_col", choices = choices, server = FALSE,
      selected = choices[2]
    )
    
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
  })
  

  output$summary <- renderPrint({
    summary(df())
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
}