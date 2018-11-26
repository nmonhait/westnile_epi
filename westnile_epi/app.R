library(shinydashboard)
library(leaflet)
# library(shinythemes)

header <- dashboardHeader(
  title = "West Nile Virus in Illinois 2005-2012"
)
sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Earthquakes", tabName="dashboard", icon = icon("bullseye")),
    menuItem("Fatalities", tabName="damage", icon = icon("ambulance")),
    menuItem("Data", tabName="data", icon = icon("table")),
    menuItem("About", tabName="about", icon = icon("info"))
  )
)