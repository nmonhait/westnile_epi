# user interface of Illinois WNV interactive app

# questions for Nichole: drop down vs checks; labels match data

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

<<<<<<< HEAD
shinyUI(dashboardPage( # create shiny dashboard fluid page
  # header and structure of shiny dashboard
=======
shinyUI(dashboardPage(
>>>>>>> 87c8055cd90bc6edc4541981ffd3546d22b56c0b
  dashboardHeader(title = "Demographic patterns of West Nile Virus in Illinois,
                  2005 - 2012",
                  titleWidth = 1000),
  dashboardSidebar(disable = TRUE),
  dashboardBody(
    fluidRow(
<<<<<<< HEAD
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

=======
      column(7, 
           box(width = NULL, offset = 0,
<<<<<<< HEAD
               leafletOutput("map", height = 500))),
      column(width = 4, offset = 0,
             fluidRow(width = NULL,
                 radioButtons("demo", label = "Choose one demographic indicator",
                              choiceNames = list(
                                         HTML("<b> Gender: </b> Male"), 
                                         HTML("<b> Gender: </b> Female"),
                                         HTML("<b> Race: </b> White"),
                                         HTML("<b> Race: </b> Black African American"),
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
    #   column(width = 4, offset = 0,
    #          fluidRow(width = NULL,
    #              selectizeInput(inputId = "race", # race widget
    #                          label = "Select race(s): ",
    #                          choices = c("White", 
    #                                      "BlackAfricanAmerican", 
    #                                      "Asian",
    #                                      "Multiple Races",
    #                                      "Other",
    #                                      "Unknown",
    #                                      "na"),
    #                          multiple = TRUE)
    #          )),
    #   column(width = 4, offset = 0,
    #          fluidRow(width = NULL,
    #             selectizeInput(inputId = "age", # age widget
    #                         label = "Select age group(s): ",
    #                         choices = c("0-4 Years",
    #                                     "5-9 Years",
    #                                     "10-14 Years",
    #                                     "15-19 Years",
    #                                     "20-24 Years",
    #                                     "25-29 Years",
    #                                     "30-34 Years",
    #                                     "35-39 Years",
    #                                     "40-44 Years",
    #                                     "45-49 Years",
    #                                     "50-54 Years",
    #                                     "55-59 Years",
    #                                     "60-64 Years",
    #                                     "65 + Years"),
    #                         multiple = TRUE))
    # )),
      column(width = 11,
             box(width = 10,
                 sliderInput(inputId = "year",
=======
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
>>>>>>> 87c8055cd90bc6edc4541981ffd3546d22b56c0b
                             label = "Select the year(s): ",
                             value = c(2005, 2012), 
                             min = 2005,
                             max = 2012,
                             sep = "",
                             ticks = TRUE
                           ))
                 ),
  skin = "navy"))))
>>>>>>> 87c8055cd90bc6edc4541981ffd3546d22b56c0b
  