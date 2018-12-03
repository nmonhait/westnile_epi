# Illinois WNV interactive map

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

shinyUI(dashboardPage(
  
  dashboardHeader(title = "Demographic patterns of West Nile Virus in Illinois,
                  2005 - 2012",
                  titleWidth = 1000),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      column(width = 7,
             box(width = NULL,
                 leafletOutput("map", height = 400))),
      column(width = 5,
             box(width = NULL,
                 checkboxGroupInput(inputId = "gender",
                             label = "Filter based on patient gender: ",
                             choices = c("Male", 
                                       "Female"),
                             selected =  c("Male", 
                                           "Female"))
             ),
                 checkboxGroupInput(inputId = "race",
                             label = "Filter based on patient race: ",
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
                                          "Other",
                                          "Unknown",
                                          "na"))
             ),
                checkboxGroupInput(inputId = "age",
                            label = "Filter based on patient age group: ",
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
                                         "65 + Years",
                                         "na"))
      )
    ),
  skin = "blue"))

  