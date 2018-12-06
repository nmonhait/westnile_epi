################ USER INTERFACE FILE FOR ILLINOIS SHINY APP ################



######### LOAD LIBRARIES ########

library(shinydashboard)
library(shiny)
library(dplyr)
library(leaflet)
library(DT)
library(ggplot2)
library(ggmap)


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
      column(width = 7, # map widget
       box(width = NULL, offset = 0, 
           leafletOutput("map", height = 500))), 
      column(width = 4, offset = 0,
             fluidRow(width = NULL, # "one option widget" (sex, race, OR age)
                radioButtons("demo", label = "Choose one demographic indicator",
                             choiceNames = list(
                               HTML("<b> Gender: </b> Male"), 
                               HTML("<b> Gender: </b> Female"),
                               HTML("<b> Race: </b> White"),
                               HTML("<b> Race: </b> Black / African American"),
                               HTML("<b> Race: </b> Multiple Races"),
                               HTML("<b> Race: </b> Other"),
                               HTML("<b> Race: </b> Unknown"),
                               HTML("<b> Age: </b> 0-4 Years"),
                               HTML("<b> Age: </b> 5-9 Years"),
                               HTML("<b> Age: </b> 15-19 Years"),
                               HTML("<b> Age: </b> 20-24 Years"),
                               HTML("<b> Age: </b> 25-29 Years"),
                               HTML("<b> Age: </b> 30-34 Years"),
                               HTML("<b> Age: </b> 35-39 Years"),
                               HTML("<b> Age: </b> 40-44 Years"),
                               HTML("<b> Age: </b> 45-49 Years"),
                               HTML("<b> Age: </b> 50-54 Years"),
                               HTML("<b> Age: </b> 55-59 Years"),
                               HTML("<b> Age: </b> 60-64 Years"),
                               HTML("<b> Age: </b> 64+ Years")
                             ),
                             
                             choiceValues = list(
                               "text", "text", "text", "text", "text",
                               "text", "text", "text", "text", "text",
                               "text", "text", "text", "text", "text",
                               "text", "text", "text", "text", "text")
                )
       ))),

column(width = 11,
       box(width = 10,
           sliderInput(inputId = "year", # year widget
                       label = "Select the year(s): ",
                       value = c(2005, 2012), 
                       min = 2005,
                       max = 2012,
                       sep = "", # to remove commas from numeric years
                       ticks = TRUE
           ))
),
skin = "purple"))

