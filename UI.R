ui <- fluidPage(
  theme = shinytheme("cerulean"),
  
  titlePanel("PlotPal"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file1", "Choose CSV File",
                accept = c("text/csv",
                           "text/comma-separated-values,text/plain",
                           ".csv")),
      checkboxInput("header", "Header", TRUE),
      
      hr(),  
      
      radioButtons("disp", "Display",
                   choices = c(Head = "head",
                               All = "all"),
                   selected = "head"),
      
      hr(),
      
      fluidRow(
        column(6, selectInput("xcol", "X Variable", "")),
        column(6, selectInput("ycol", "Y Variable", ""))
      ),
      
      hr(),
      
      checkboxInput("useGroup", "Use Grouping Variable 1", TRUE),
      conditionalPanel(
        condition = "input.useGroup == true",
        selectInput("groupcol", "Grouping Variable 1", "")
      ),
      
      checkboxInput("useGroup2", "Use Grouping Variable 2", FALSE),
      conditionalPanel(
        condition = "input.useGroup2 == true",
        selectInput("groupcol2", "Grouping Variable 2", "")
      ),
      
      hr(),
      
      checkboxInput("useFilter", "Use Filter 1", FALSE),
      conditionalPanel(
        condition = "input.useFilter == true",
        selectInput("filterCol", "Filter Column 1", ""),
        textInput("filterValues", "Filter Values 1 (comma-separated)", "")
      ),
      
      checkboxInput("useFilter2", "Use Filter 2", FALSE),
      conditionalPanel(
        condition = "input.useFilter2 == true",
        selectInput("filterCol2", "Filter Column 2", ""),
        textInput("filterValues2", "Filter Values 2 (comma-separated)", "")
      ),
      
      hr(),
      
      selectInput("plotType", "Plot Type",
                  choices = list("Scatter Plot" = "scatter",
                                 "Line Plot" = "line",
                                 "Bar Plot" = "bar",
                                 "Histogram" = "hist",
                                 "Box Plot" = "boxplot")),
      
      actionButton("plotButton", "Generate Plot", class = "btn-primary")
    ),
    
    mainPanel(
      actionButton("toggleWelcome", "Hide Welcome", class = "btn-secondary"),
      div(
        id = "welcomeSection",
        class = "welcome-section",
        h3("Welcome to PlotPal"),
        p("This application allows you to upload a CSV file and generate various types of plots based on your data."),
        p("To get started:"),
        tags$ul(
          tags$li("Upload your CSV file using the file input on the left."),
          tags$li("Select whether your CSV file has a header row."),
          tags$li("Choose which columns to use for the X and Y axes."),
          tags$li("Optionally, select grouping variables and filters."),
          tags$li("Choose the type of plot you want to generate."),
          tags$li("Click 'Generate Plot' to view the data table and plot.")
        )
      ),
      hr(),  
      DTOutput("contents"),
      plotOutput("plot")
    )
  ),
  
  tags$head(
    tags$script(HTML("
      $(document).on('click', '#toggleWelcome', function() {
        var welcomeSection = $('#welcomeSection');
        if (welcomeSection.is(':visible')) {
          welcomeSection.hide();
          $(this).text('Show Welcome');
        } else {
          welcomeSection.show();
          $(this).text('Hide Welcome');
        }
      });
    ")),
    tags$style(HTML("
      .btn-primary {
        background-color: #007bff;
        border-color: #007bff;
      }
      .btn-secondary {
        background-color: #6c757d;
        border-color: #6c757d;
      }
      .shiny-input-container {
        margin-bottom: 15px;
      }
      .form-group {
        margin-bottom: 15px;
      }
      hr {
        margin-top: 20px;
        margin-bottom: 20px;
      }
      .welcome-section {
        padding: 20px;
        background-color: #f8f9fa;
        border: 1px solid #e0e0e0;
        border-radius: 5px;
      }
    "))
  )
)
