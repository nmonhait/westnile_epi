# load required libraries 
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
library(stringr)

<<<<<<< HEAD
# West nile df with location counts for map
il_wnv <-read_csv("data/data_il.csv") %>% 
=======
# West nile df
il_wnv <- read_csv("data/data_il.csv") %>% 
>>>>>>> 2867f24660c47e15c176cb716163a08107a4a422
  subset(il != "IL") %>% #some values do not have county level data and are indicated as IL
  rename(NAME = il) %>% 
  group_by(NAME) %>% 
  count() 

il_wnv$NAME <- sub("Dupage", "DuPage", il_wnv$NAME)
il_wnv$NAME <- sub("Dekalb", "DeKalb", il_wnv$NAME)
il_wnv$NAME <- sub("Jodaviss", "Jo Daviess", il_wnv$NAME)
il_wnv$NAME <- sub("Lasalle", "LaSalle", il_wnv$NAME)
il_wnv$NAME <- sub("Mchenry", "McHenry", il_wnv$NAME)
il_wnv$NAME <- sub("Mclean", "McLean", il_wnv$NAME)
il_wnv$NAME <- sub("St Clair", "St. Clair", il_wnv$NAME)

#demography df to join with county location

il_demog <-read_csv("data/data_il.csv") %>% 
  subset(il != "IL") %>% #some values do not have county level data and are indicated as IL
  rename(NAME = il) %>% 
  select(agegroup, gender, race, NAME) %>% 
  arrange(NAME)

il_demog$NAME <- sub("Dupage", "DuPage", il_demog$NAME)
il_demog$NAME <- sub("Dekalb", "DeKalb", il_demog$NAME)
il_demog$NAME <- sub("Jodaviss", "Jo Daviess", il_demog$NAME)
il_demog$NAME <- sub("Lasalle", "LaSalle", il_demog$NAME)
il_demog$NAME <- sub("Mchenry", "McHenry", il_demog$NAME)
il_demog$NAME <- sub("Mclean", "McLean", il_demog$NAME)
il_demog$NAME <- sub("St Clair", "St. Clair", il_demog$NAME)

# Tigris IL df, arrange in alphabetical order
il_counties <- counties(state = "IL", cb = TRUE, class = "sf") %>% 
  st_set_crs(NA) %>%
  st_set_crs(4326) %>% 
  arrange(NAME)

# merge il_wnv and il_counties
full_il <- full_join(il_wnv, il_counties, by = "NAME") %>% 
  group_by(NAME) %>% 
  ungroup() %>% 
  st_as_sf() %>% 
  select(NAME, n, geometry)

#merge il_demog and il_counties

il_skeleton <- il_counties %>% 
  ggplot() +
  geom_sf(data = il_counties) 

case_count_full <- full_il %>% 
  group_by(NAME) %>% 
  count()

# interactive leaflet plot
bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- leaflet::colorFactor((viridis_pal(option = "inferno",
                                         begin = 1, end = 0.2)(4)), 
                            domain = full_il$n)

labels <- sprintf(
  "<strong>%s</strong><br/> <sup></sup>",
  full_il$NAME # case_count_full$n
) %>% lapply(htmltools::HTML)

il_all <- leaflet(full_il) %>%
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


il_all

il_maprace <- leaflet()

#map function
#race
il_race <- il_demog %>% 
  group_by(NAME, race) %>% 
  count() %>% 
  ungroup() %>% 
  arrange(NAME)

il_race <-full_join(il_race, full_il, by = "NAME") %>% 
  group_by(NAME) %>% 
  st_as_sf()

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- leaflet::colorFactor((viridis_pal(option = "inferno",
                                         begin = 1, end = 0.2)(4)), 
                            domain = il_race$n)

labels_race <- sprintf(
  "<strong>%s</strong><br/> <sup></sup>",
  full_il$NAME, il_race$n
) %>% lapply(htmltools::HTML)


il_racemap <- leaflet(il_race) %>%
  setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>% 
  addProviderTiles("OpenStreetMap.BlackAndWhite") %>%  
  addPolygons(
    fillColor = ~pal(il_race$n),
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


il_all

il_age <- il_demog %>% 
  group_by(agegroup, NAME) %>% 
  count() %>% 
  ungroup()

il_age <-full_join(il_age, il_counties, by = "NAME")

il_gender <- il_demog %>% 
  group_by(gender, NAME) %>% 
  count() %>% 
  ungroup()

il_gender <-full_join(il_gender, il_counties, by = "NAME")

#x=1,2,3 for each demographic indicator

map_output <- function(x) for (i in 1:3){
  if (race) print 
}
