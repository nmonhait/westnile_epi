############################ ILLINOIS SHINY APP #############################

library(shinydashboard)
library(shiny)

####################### SOURCE HELPER FILE #########################


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
  # set dashboard body with map, "one option widget", and year slider
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
           box(width = 3, offset = 9, # sex widget
              radioButtons("gender", label = "Choose gender",
                            choiceNames = list(
                                HTML("Male"), 
                                HTML("Female")
                                   ),
                            choiceValues = list("Male", "Female")
                          )
                  )
           ),
      fluidRow(
        tableOutput("values")
      )
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
      mutate(labels = paste0('<strong>', NAME, '</strong>',
                             '<br/>', 'Count: ', '<strong>', n, '</strong>', ' '))
  })
  
  output$values <- renderTable({
    sliderValues()
  })
  
  # year_filter <- reactive({
  #   il_demog[il_demog$year >= input$]
  # })
  # 
  # # Reactive expression for the data subsetted to what the user selected
  #   filteredData <- reactive({
  #     quakes[quakes$mag >= input$range[1] & quakes$mag <= input$range[2],]
  #   })
  # 
  # create leaflet map
  output$map <- renderLeaflet({
    pal <- leaflet::colorNumeric("Blues", # change color; quantiles/breaks
                         domain = NULL)
    full_il %>% 
      left_join(sliderValues(), by = "NAME") %>% 
      leaflet() %>%
      setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>%
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



shinyApp(ui = ui, server = server)



###################### example ################


# ui <- bootstrapPage(
#   tags$style(type = "text/css",
#              "html,
#              body {width:100%;height:100%}"),
#   leafletOutput("map",
#                 width = "100%",
#                 height = "100%"),
#   absolutePanel(top = 10,
#                 right = 10,
#                 sliderInput("range",
#                             "Magnitudes",
#                             min(quakes$mag),
#                             max(quakes$mag),
#                             value = range(quakes$mag),
#                             step = 0.1
#                 ),
#                 selectInput("colors",
#                             "Color Scheme",
#                             rownames(subset(brewer.pal.info,
#                                             category %in% c("seq", "div")))
#                 ),
#                 checkboxInput("legend",
#                               "Show legend",
#                               TRUE)
#   )
# )



# server <- function(input, output, session) {
# 
#   # Reactive expression for the data subsetted to what the user selected
  # filteredData <- reactive({
  #   quakes[quakes$mag >= input$range[1] & quakes$mag <= input$range[2],]
  # })
# 
#   # This reactive expression represents the palette function,
#   # which changes as the user makes selections in UI.
#   colorpal <- reactive({
#     colorNumeric(input$colors, quakes$mag)
#   })
# 
#   output$map <- renderLeaflet({
#     # Use leaflet() here, and only include aspects of the map that
#     # won't need to change dynamically (at least, not unless the
#     # entire map is being torn down and recreated).
#     leaflet(quakes) %>% addTiles() %>%
#       fitBounds(~min(long),
#                 ~min(lat),
#                 ~max(long),
#                 ~max(lat))
#   })
# 
#   # Incremental changes to the map (in this case, replacing the
#   # circles when a new color is chosen) should be performed in
#   # an observer. Each independent set of things that can change
#   # should be managed in its own observer.
#   observe({
#     pal <- colorpal()
# 
#     leafletProxy("map", data = filteredData()) %>%
#       clearShapes() %>%
#       addCircles(radius = ~10^mag/10,
#                  weight = 1,
#                  color = "#777777",
#                  fillColor = ~pal(mag),
#                  fillOpacity = 0.7,
#                  popup = ~paste(mag)
#       )
#   })
# 
#   # Use a separate observer to recreate the legend as needed.
#   observe({
#     proxy <- leafletProxy("map", data = quakes)
# 
#     # Remove any existing legend, and only if the legend is
#     # enabled, create a new one.
#     proxy %>% clearControls()
#     if (input$legend) {
#       pal <- colorpal()
#       proxy %>% addLegend(position = "bottomright",
#                           pal = pal,
#                           values = ~mag
#       )
#     }
#   })
# }
# 
# shinyApp(ui, server)

