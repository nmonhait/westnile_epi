############################ ILLINOIS SHINY APP ############################

library(shinydashboard)
library(shiny)

########################### SOURCE HELPER FILE ############################


source("helper.R")


############################# UI BODY CODE ################################

# create dashboard
ui <- dashboardPage(
  # set title
  dashboardHeader(title = "Demographic patterns of West Nile Virus in Illinois,
                  2005 - 2012",
                  titleWidth = 1000),
  # disable sidebar
  dashboardSidebar(disable = TRUE),
  # set dashboard body with map, gender widget, and year widget
  dashboardBody(
    fluidRow(
      column(width = 12, # map widget
             box(width = 12, offset = 0, 
                 leafletOutput("map", height = 400)))), 
    fluidRow(
      column(width = 12,
           box(width = 8,
               sliderInput(inputId = "year", # year widget
                           label = "Select the year(s): ",
                           value = c(2005, 2012), 
                           min = 2005,
                           max = 2012,
                           sep = "", # to remove commas from numeric years
                           ticks = TRUE
               )),
           box(width = 3, offset = 9, # gender widget
              radioButtons("gender", label = "Choose gender",
                            choiceNames = list(
                                HTML("Male"), 
                                HTML("Female")
                                   ),
                            choiceValues = list("Male", "Female")
                          )
                  )
           )
      # fluidRow(
      #   tableOutput("values") # test table; delete after complete
      # )
      ),
    skin = "purple"))





############################## SERVER BODY ################################


server <- function (input, output, session) {
  sliderValues <- reactive({
    il_sex %>% 
      filter(gender == input$gender) %>% 
      filter(year >= input$year[1] & year <= input$year[2]) %>% 
      group_by(NAME) %>% 
      summarize(n = sum(n)) %>% 
      mutate(labels = 
        paste0(NAME, ' Count: ', n, ' ')
        )
  })
  
  # output$values <- renderTable({ # test table; delete after complete
  #   sliderValues()
  # })
  
  # create leaflet map
  output$map <- renderLeaflet({
    pal <- leaflet::colorBin("Blues", 
                             bins = 100,
                             pretty = TRUE,
                             domain = NULL)
    full_il %>% 
      left_join(sliderValues(), by = "NAME") %>% 
      leaflet() %>%
      setView(lng = -89.3985, lat = 40.0000, zoom = 6) %>%
      addProviderTiles("OpenStreetMap.BlackAndWhite") %>%
      addPolygons(
        fillColor = ~pal(n),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE),
        label = ~labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"))
  })
}

############################# CALL APP ###################################

shinyApp(ui = ui, server = server)

