# user interface of Illinois WNV interactive app

# load libraries

library(shinydashboard)
library(shiny)
library(dplyr)
library(leaflet)
library(DT)
library(ggplot2)
library(ggmap)

# source helper file
# source("il_app/helper.R")

shinyUI(dashboardPage(
  dashboardHeader(title = "Demographic patterns of West Nile Virus in Illinois,
                  2005 - 2012",
                  titleWidth = 1000),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
      column(7, 
           box(width = NULL, offset = 0,
               leafletOutput("map", height = 400))),
      column(width = 4, offset = 0,
             fluidRow(width = NULL,
                 selectizeInput(inputId = "gender", # gender widget
                             label = "Select gender(s): ",
                             choices = c("Male", 
                                       "Female",
                                       "na"),
                             multiple = TRUE) 
             )),
      column(width = 4, offset = 0,
             fluidRow(width = NULL,
                 selectizeInput(inputId = "race", # race widget
                             label = "Select race(s): ",
                             choices = c("White", 
                                         "BlackAfricanAmerican", 
                                         "Asian",
                                         "Multiple Races",
                                         "Other",
                                         "Unknown",
                                         "na"),
                             multiple = TRUE)
             )),
      column(width = 4, offset = 0,
             fluidRow(width = NULL,
                selectizeInput(inputId = "age", # age widget
                            label = "Select age group(s): ",
                            choices = c("years04",
                                        "years59", 
                                        "years1014",
                                        "years1519",
                                        "years2024",
                                        "years2529",
                                        "years3034",
                                        "years3539",
                                        "years4044",
                                        "years4549",
                                        "years5054",
                                        "years5559",
                                        "years6064",
                                        "years65",
                            multiple = TRUE))
    )),
      column(width = 12,
             box(width = 12,
                 sliderInput(inputId = "year", # year widget
                             label = "Select the year(s): ",
                             value = c(2005, 2012), 
                             min = 2005,
                             max = 2012,
                             sep = "",
                             ticks = TRUE
                           ))
                 ),
  skin = "navy"))))
  