#load required libraries 
library(tidyverse)
library(tigris)
library(ggplot2)
library(ggthemes)
library(sf)
library(leaflet)
library(sp)
library(readr)
library(viridis)
library(dplyr)

#West nile df
il_wnv <-read_csv("data/data_il.csv") %>% 
  subset(il != "IL") %>% #some values do not have county level data and are indicated as IL
  rename(NAME = il) %>% 
  group_by(NAME) %>% 
  count()

#Tigris IL df
il_counties <- counties(state = "IL", cb = TRUE, class = "sf") %>% 
  st_set_crs(NA) %>%
  st_set_crs(4326)

#fuzzy merge il_wnv and il_counties
full_il <- full_join(il_wnv, il_counties, by = "NAME") %>% 
  group_by(NAME) %>% 
  ungroup() %>% 
  st_as_sf()

il_skeleton <- il_counties %>% 
  ggplot() +
  geom_sf(data = il_counties) 

case_count_full <- full_il %>% 
  group_by(NAME) %>% 
  count()

#interactive leaflet plot
bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- leaflet::colorFactor((viridis_pal(option = "inferno",
                                         begin = 1, end = 0.2)(4)), 
                            domain = full_il$n)

labels <- sprintf(
  "<strong>%s</strong><br/> <sup></sup>",
  full_il$NAME #case_count_full$n
) %>% lapply(htmltools::HTML)

il_cases <- leaflet(full_il) %>%
  setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>% 
  addProviderTiles("OpenStreetMap.BlackAndWhite") %>%  
  addPolygons(
    fillColor = "grey",
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
    label = labels,
    labelOptions = labelOptions(
      style = list("font-weight" = "normal", padding = "3px 8px"),
      textsize = "15px",
      direction = "auto")) 


il_cases

