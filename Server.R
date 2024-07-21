library(shiny)
library(DT)
library(dplyr)
library(tidyverse)
library(shinythemes)

server <- function(input, output, session) {
  
  data <- reactive({
    req(input$file1)
    df <- read.csv(input$file1$datapath, header = input$header)
    
    if (!input$useFilter && !input$useFilter2) {
      updateSelectInput(session, "xcol", choices = names(df))
      updateSelectInput(session, "ycol", choices = names(df))
      updateSelectInput(session, "groupcol", choices = names(df))
      updateSelectInput(session, "groupcol2", choices = names(df))
      updateSelectInput(session, "filterCol", choices = names(df))
      updateSelectInput(session, "filterCol2", choices = names(df))
    }
    
    if (input$useFilter && input$filterCol != "") {
      filter_values <- strsplit(input$filterValues, ",")[[1]]
      df <- df[!df[[input$filterCol]] %in% filter_values, ]
    }
    
    if (input$useFilter2 && input$filterCol2 != "") {
      filter_values2 <- strsplit(input$filterValues2, ",")[[1]]
      df <- df[!df[[input$filterCol2]] %in% filter_values2, ]
    }
    
    return(df)
  })
  
  output$contents <- DT::renderDT({
    req(data())
    
    lengthMenu <- list(c(10, 20, 50, 100), c("10", "20", "50", "100"))
    
    datatable(data(), 
              options = list(
                pageLength = 10,  
                lengthMenu = lengthMenu
              ))
  })
  
  observeEvent(input$plotButton, {
    output$plot <- renderPlot({
      req(input$xcol, input$ycol)
      df <- data()
      
      plotType <- input$plotType
      x <- df[[input$xcol]]
      y <- df[[input$ycol]]
      
      if (input$useGroup && input$groupcol != "" && !is.null(input$groupcol2) && input$useGroup2 && input$groupcol2 != "") {
        group <- df[[input$groupcol]]
        group2 <- df[[input$groupcol2]]
        
        if (plotType == "scatter") {
          ggplot(df, aes_string(x = input$xcol, y = input$ycol, color = input$groupcol, shape = input$groupcol2)) + 
            geom_point(size = 3)
        } else if (plotType == "line") {
          ggplot(df, aes_string(x = input$xcol, y = input$ycol, color = input$groupcol, linetype = input$groupcol2)) + 
            geom_line()
        } else if (plotType == "bar") {
          df_summary <- df %>%
            group_by(!!as.name(input$xcol), !!as.name(input$groupcol), !!as.name(input$groupcol2)) %>%
            summarise(mean_value = mean(!!as.name(input$ycol), na.rm = TRUE))
          ggplot(df_summary, aes_string(x = input$xcol, y = "mean_value", fill = input$groupcol2)) + 
            geom_bar(stat = "identity", position = "dodge", color = "black")
        } else if (plotType == "hist") {
          ggplot(df, aes_string(x = input$xcol, fill = input$groupcol, group = input$groupcol2)) + 
            geom_histogram(position = "dodge")
        } else if (plotType == "boxplot") {
          ggplot(df, aes_string(x = input$groupcol, y = input$ycol, fill = input$groupcol2)) + 
            geom_boxplot()
        }
        
      } else if (input$useGroup && input$groupcol != "") {
        group <- df[[input$groupcol]]
        if (plotType == "scatter") {
          ggplot(df, aes_string(x = input$xcol, y = input$ycol, color = input$groupcol)) + 
            geom_point(size = 3)
        } else if (plotType == "line") {
          ggplot(df, aes_string(x = input$xcol, y = input$ycol, color = input$groupcol)) + 
            geom_line()
        } else if (plotType == "bar") {
          df_summary <- df %>%
            group_by(!!as.name(input$xcol), !!as.name(input$groupcol)) %>%
            summarise(mean_value = mean(!!as.name(input$ycol), na.rm = TRUE))
          ggplot(df_summary, aes_string(x = input$xcol, y = "mean_value", fill = input$groupcol)) + 
            geom_bar(stat = "identity", position = "dodge", color = "black")
        } else if (plotType == "hist") {
          ggplot(df, aes_string(x = input$xcol, fill = input$groupcol)) + 
            geom_histogram(position = "dodge")
        } else if (plotType == "boxplot") {
          ggplot(df, aes_string(x = input$groupcol, y = input$ycol)) + 
            geom_boxplot()
        }
        
      } else {
        if (plotType == "scatter") {
          ggplot(df, aes_string(x = input$xcol, y = input$ycol)) + 
            geom_point(size = 3)
        } else if (plotType == "line") {
          ggplot(df, aes_string(x = input$xcol, y = input$ycol)) + 
            geom_line()
        } else if (plotType == "bar") {
          ggplot(df, aes_string(x = input$xcol, y = input$ycol)) + 
            geom_bar(stat = "identity", color = "black")
        } else if (plotType == "hist") {
          ggplot(df, aes_string(x = input$xcol)) + 
            geom_histogram()
        } else if (plotType == "boxplot") {
          ggplot(df, aes_string(x = input$xcol, y = input$ycol)) + 
            geom_boxplot()
        }
      }
    })
  })
}
