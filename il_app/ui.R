# Illinois WNV interactive map

# questions for Nichole: drop down vs checks; labels match data

# load libraries

library(shinydashboard)
library(shiny)
library(dplyr)
library(leaflet)
library(DT)
library(ggplot2)
library(ggmap)

# source map file

# source("writing/il_map.R")

shinyUI(dashboardPage( # create shiny dashboard fluid page
  # header and structure of shiny dashboard
  dashboardHeader(title = "Demographic patterns of West Nile Virus in Illinois,
                  2005 - 2012",
                  titleWidth = 1000),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      column(width = 7, # map widget
             box(width = NULL,
                 leafletOutput("map", height = 400))), 
      column(width = 5, # year slider widget
             box(width = NULL,
                 sliderInput(inputId = "year",
                             label = "Select the year(s): ",
                             value = c(2005, 2012), # not in date form
                             min = 2005,
                             max = 2012,
                             ticks = TRUE,
                             animate = TRUE 
                             #animationOptions(interval = 1)
                             ))
                 ),
      column(width = 5,
             box(width = NULL,
                 checkboxGroupInput(inputId = "gender", # gender widget
                             label = "Select gender(s): ",
                             choices = c("Male", 
                                       "Female",
                                       "na"),
                             selected =  c("Male", 
                                           "Female")) 
             ),
                 checkboxGroupInput(inputId = "race", # race widget
                             label = "Select race(s): ",
                             choices = c("White", 
                                       "BlackAfricanAmerican", # same as data labels? 
                                       "Asian",
                                       "Multiple Races",
                                       "Other",
                                       "Unknown",
                                       "na"),
                             selected = c("White", 
                                          "BlackAfricanAmerican", # same as data labels?
                                          "Asian",
                                          "Multiple Races",
                                          "Other")) 
             ),
                checkboxGroupInput(inputId = "age", # age widget
                            label = "Select age group(s): ",
                            choices = c("0-4 Years",
                                        "5-9 Years",
                                        "10-14 Years",
                                        "15-19 Years",
                                        "20-24 Years",
                                        "25-29 Years",
                                        "30-34 Years",
                                        "35-39 Years",
                                        "40-44 Years",
                                        "45-49 Years",
                                        "50-54 Years",
                                        "55-59 Years",
                                        "60-64 Years",
                                        "65 + Years",
                                        "na"),
                            selected = c("0-4 Years",
                                         "5-9 Years",
                                         "10-14 Years",
                                         "15-19 Years",
                                         "20-24 Years",
                                         "25-29 Years",
                                         "30-34 Years",
                                         "35-39 Years",
                                         "40-44 Years",
                                         "45-49 Years",
                                         "50-54 Years",
                                         "55-59 Years",
                                         "60-64 Years",
                                         "65 + Years"))
      )
    ),
  skin = "blue"))

  