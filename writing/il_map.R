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
library(janitor)

# West nile df
il_wnv <- read_csv("data/data_il.csv") %>% 
  subset(il != "IL") %>% # some values do not have county level data and are indicated as IL
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

# demography df to join with county location

il_demog <-read_csv("data/data_il.csv") %>% 
  subset(il != "IL") %>% # some values do not have county level data and are indicated as IL
  rename(NAME = il) %>% 
  select(year, agegroup, gender, race, NAME) %>% 
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

# merge il_wnv and il_counties for blank map highlighted by county name and boundary
full_il <- full_join(il_wnv, il_counties, by = "NAME") %>% 
  group_by(NAME) %>% 
  ungroup() %>% 
  st_as_sf() %>% 
  select(NAME, geometry)

# merge il_counties and il_demog for later use in function building
il_demographic <- full_join(il_demog, il_counties, by = "NAME") %>% 
  group_by(NAME, gender, race, agegroup, year) %>% 
  ungroup() %>% 
  st_as_sf()

# static outline with Il county shapes 

il_skeleton <- il_counties %>% 
  ggplot() +
  geom_sf(data = il_counties) 

# interactive leaflet plot- BLANK
bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- leaflet::colorFactor((viridis_pal(option = "inferno",
                                         begin = 1, end = 0.2)(4)), 
                            domain = full_il$n)

labels <- sprintf(
  "<strong>%s</strong><br/> <sup></sup>",
  df$demog
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

# filtered df for map functions to counts by group and county
# race
il_race <- il_demog %>% 
  arrange(NAME) %>% 
  group_by(NAME, race) %>% 
  count() %>% 
  ungroup()

il_race <- il_race %>% 
  spread(key = race, value = n) %>% 
  rename(MiltipleRaces = `Multiple Races`)
  

race_count <-full_join(il_race, full_il, by = "NAME") %>% 
  st_as_sf()

race_map <- leaflet(race_count) %>%
  setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>% 
  addProviderTiles("OpenStreetMap.BlackAndWhite") %>%  
  addPolygons(
    fillColor = ~pal(race_count$Asian), # only selected for one race? add reactivity
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

# df for age group, first create df then spread so 1 row per county for merge 
# with spatial info, place 0 for all NA

il_age <- il_demog %>% 
  arrange(NAME) %>% 
  group_by(NAME, agegroup) %>% 
  count() %>% 
  ungroup()

il_age <- il_age %>% 
  spread(key = agegroup, value = n)  %>%
  rename(years04 = '0-4 Years') %>% 
  rename(years59 = '5-9 Years') %>% 
  rename(years1014 = '10-14 Years') %>% 
  rename(years1519 = '15-19 Years') %>% 
  rename(years2024 = '20-24 Years') %>% 
  rename(years2529 = '25-29 Years') %>% 
  rename(years3034 = '30-34 Years') %>% 
  rename(years3539 = '35-39 Years') %>%  
  rename(years4044 = '40-44 Years') %>% 
  rename(years4549 = '45-49 Years') %>% 
  rename(years5054 = '50-54 Years') %>% 
  rename(years5559 = '55-59 Years') %>% 
  rename(years6064 = '60-64 Years') %>% 
  rename(years65 = '65 + Years') 

age_count <-full_join(il_age, full_il, by = "NAME") %>% 
  st_as_sf()

age_map <- leaflet(age_count) %>%
  setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>% 
  addProviderTiles("OpenStreetMap.BlackAndWhite") %>%  
  addPolygons(
    fillColor = ~pal(age_count$years1014), # rename columns to clean code
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

# df for sex, first create df then spread so 1 row per county for merge 
## with spatial info, place 0 for all NA

il_sex <- il_demog %>% 
  arrange(NAME) %>% 
  group_by(NAME, gender) %>% 
  count() %>% 
  ungroup()

il_sex <- il_sex %>% 
  spread(key = gender, value = n)

sex_count <-full_join(il_sex, full_il, by = "NAME") %>% 
  st_as_sf()

sex_map <- leaflet(sex_count) %>%
  setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>% 
  addProviderTiles("OpenStreetMap.BlackAndWhite") %>%  
  addPolygons(
    fillColor = ~pal(sex_count$Female),
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


# also facet counts per year
il_year <- il_demog %>% 
  arrange(NAME) %>% 
  group_by(NAME, year) %>% 
  count() %>% 
  ungroup()

il_year <- il_year %>% 
  spread(key = year, value = n)

year_count <-full_join(il_year, full_il, by = "NAME") %>% 
  st_as_sf()

# FUNCTION for map outputs for different demographic indicators

map_outputs <- function(df, demog) {
  pal <- leaflet::colorFactor((viridis_pal(option = "inferno",
                                           begin = 1, end = 0.2)(4)), 
                              domain = demog)
  labels <- paste0('<strong>', df$NAME, '</strong>',
                   '<br/>', 'Count: ', '<strong>', demog, '</strong>', ' ') %>% 
    lapply(htmltools::HTML)
  
  map <- leaflet(df) %>%
    setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>% 
    addProviderTiles("OpenStreetMap.BlackAndWhite") %>%  
    addPolygons(
      fillColor = ~pal(demog),
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
      
  print(map)
}

#function check:
## df options: sex_count, race_count, age_count, year_count
### demog options are all categories within each

map_outputs(year_count, year_count$'2005')


