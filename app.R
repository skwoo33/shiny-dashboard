library(shinydashboard)

# ui <- dashboardPage(skin = "green",
ui <- dashboardPage(
  # static dropdownMenu
  # dashboardHeader(title = "Basic dashboard",
  #                 dropdownMenu(type = "messages",
  #                              messageItem(
  #                                from = "Sales Dept",
  #                                message = "Sales are steady this month."
  #                              ),
  #                              messageItem(
  #                                from = "New User",
  #                                message = "How do I register?",
  #                                icon = icon("question"),
  #                                time = "13:45"
  #                              ),
  #                              messageItem(
  #                                from = "Support",
  #                                message = "The new server is ready.",
  #                                icon = icon("life-ring"),
  #                                time = "2014-12-01"
  #                              )
  #                 )),
  # dynamic dropdownMenu
  dashboardHeader(title = "My Dashboard",
                  # disable=TRUE,
                  dropdownMenuOutput("messageMenu"),
                  dropdownMenu(type = "notifications",
                               notificationItem(
                                 text = "5 new users today",
                                 icon("users"),
                                 href="http://www.naver.com"
                               ),
                               notificationItem(
                                 text = "12 items delivered",
                                 icon("truck"),
                                 status = "success"
                               ),
                               notificationItem(
                                 text = "Server load at 86%",
                                 icon = icon("exclamation-triangle"),
                                 status = "warning"
                               )
                  ),
                  dropdownMenuOutput("taskMenu")
  ),
  dashboardSidebar(
    # disable=TRUE,
    # static sidebarMenu
    sidebarMenu(
      sidebarSearchForm(textId = "searchText",buttonId = "searchButton",label = "Search..."),
      menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
      menuItem("Widgets", tabName = "widgets", icon = icon("th"), badgeLabel = "new", badgeColor = "red", selected = TRUE),
      menuItem("Source code", href = "https://github.com/rstudio/shinydashboafd", icon = icon("file-code-o")),
      sliderInput("slider2", "Slider:", min = 1, max = 20, value = 5),
      textInput("text", "Text Input:")
    )
    # dynamic sidebarMenu
    # sidebarMenuOutput("sidebarMenu")
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "dashboard",
              h2("dashboard tab content")
      ),
      tabItem(tabName = "widgets",
              fluidRow(
                box(title = "Histogram",
                    footer = "This is a histogram.",
                    solidHeader = TRUE,
                    status = "primary",
                    collapsible = TRUE,
                    # background = "maroon",
                    plotOutput("plot1", height = 200)),
                
                box(
                  title = "Controls",
                  solidHeader = TRUE,
                  # status = "warning",
                  background = "black",
                  "Box content here", br(), "More box content",
                  sliderInput("slider", "Number of observations:", 1, 100, 50)
                )
              ),
              fluidRow(
                tabBox(
                  title = "First tabBox",
                  id = "tabset1", height = "150px",
                  tabPanel("Tab1", "First tab content"),
                  tabPanel("Tab2", "Tab content 2")
                ),
                tabBox(
                  side = "right", height = "150px",
                  selected = "Tab3",
                  tabPanel("Tab1", "Tab content 1"),
                  tabPanel("Tab2", "Tab content 2"),
                  tabPanel("Tab3", "Note that when side = right, the tab order is reversed.")
                )
              ),
              fluidRow(
                tabBox(
                  title = tagList(icon("gear"), "tabBox status"),
                  tabPanel("Tab1",
                           "Currently selected tab from first box:",
                           verbatimTextOutput("tabset1Selected")
                  ),
                  tabPanel("Tab2", "Tab content 2")
                ),
                box(title = "Tabs",
                    tabsetPanel(
                      tabPanel("Plot",
                               textInput("textIntab", "Input Text:")
                      ),
                      tabPanel("Summary"),
                      tabPanel("Table")
                    )
                )
              ),
              # infoBoxes with fill=FALSE
              fluidRow(
                # static infoBox
                infoBox("New Orders", 10 * 2, icon = icon("credit-card")),
                # dynamic infoBox
                infoBoxOutput("progressBox"),
                infoBoxOutput("approvalBox")
              ),
              # infoBoxes with fill=TRUE
              fluidRow(
                # static infoBox
                infoBox("New Orders", 10 * 2, icon = icon("credit-card"), fill = TRUE),
                # dynamic infoBox
                infoBoxOutput("progressBox2"),
                infoBoxOutput("approvalBox2")
              ),
              # valueBoxes
              fluidRow(
                # Clicking this will increment the progress amount
                box(width = 4, actionButton("count", "Increment progress"))
              ),
              fluidRow(
                # static valueBox
                valueBox(10 * 2, "New Orders", icon = icon("credit-card")),
                # dynamic valueBox
                valueBoxOutput("progressValueBox"),
                valueBoxOutput("approvalValueBox")
              )
      )
    )
  )
)

server <- function(input, output) {
  set.seed(122)
  histdata <- rnorm(500)
  
  # dropdownMenu
  messageData <- data.frame(from = c("Sales Dept","New User","Support"),
                            message = c("Sales are steady this month.","How do I register?","The new server is ready."),
                            time = c("","13:45","2014-12-01"),
                            icon = c("user","question","life-ring")
  )
  taskData <- data.frame(text = c("Documentation","Project X","Server deployment","Overall project"),
                         value = c(90,17,75,80),
                         color = c("green","aqua","yellow","red")
  )
  
  output$messageMenu <- renderMenu({
    msgs <- apply(messageData, 1, function(row) {
      messageItem(from = row[["from"]], message = row[["message"]], time = row[["time"]], icon = icon(row[["icon"]]))
    })
    dropdownMenu(type = "messages", .list = msgs)
  })
  
  output$taskMenu <- renderMenu({
    tasks <- apply(taskData, 1, function(row) {
      taskItem(text = row[["text"]], value = row[["value"]], color = row[["color"]])
    })
    dropdownMenu(type = "tasks", badgeStatus = "success", .list = tasks)
  })
  
  # sidebarMenu => menuItem not selected when running dynamic
  # output$sidebarMenu <- renderMenu({
  #   sidebarMenu(
  #     # sidebarSearchForm(textId = "searchText",buttonId = "searchButton",label = "Search..."),
  #     menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard"), badgeLabel = "new", badgeColor = "blue", selected = TRUE),
  #     menuItem("Widgets", tabName = "widgets", icon = icon("th")),
  #     menuItem("Source code", href = "https://github.com/rstudio/shinydashboafd", icon = icon("file-code-o")),
  #     sliderInput("slider2", "Slider:", min = 1, max = 20, value = 5),
  #     textInput("text", "Text Input:")
  #   )
  # })
  
  output$plot1 <- renderPlot({
    data <- histdata[seq_len(input$slider)]
    # data <- histdata[1:input$slider]
    hist(data)
  })
  
  output$tabset1Selected <- renderText({
    input$tabset1
  })

  # infoBox  
  output$progressBox <- renderInfoBox({
    cat("infoBox 1 : ", input$count, "\n")
    infoBox("Progress", paste0(25 + input$count, "%"), icon = icon("list"), color = "purple")
  })
  
  output$approvalBox <- renderInfoBox({
    infoBox("Approval(link)", "80%", icon = icon("thumbs-up", lib = "glyphicon"), color = "yellow", href="http://www.google.com")
  })

  output$progressBox2 <- renderInfoBox({
    cat("infoBox 2 : ", input$count, "\n")
    infoBox("Progress", paste0(25 + input$count, "%"), icon = icon("list"), color = "purple", fill = TRUE)
  })
  
  output$approvalBox2 <- renderInfoBox({
    infoBox("Approval", "80%", icon = icon("thumbs-up", lib = "glyphicon"), color = "yellow", fill = TRUE)
  })
  
  # valueBox  
  output$progressValueBox <- renderValueBox({
    cat("valueBox 1 : ", input$count, "\n")
    valueBox(paste0(25 + input$count, "%"), "Progress", icon = icon("list"), color = "purple")
  })
  
  output$approvalValueBox <- renderValueBox({
    valueBox("80%", "Approval", icon = icon("thumbs-up", lib = "glyphicon"), color = "yellow")
  })
}

shinyApp(ui, server)
