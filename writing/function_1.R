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


il_race <- il_demog %>% 
  arrange(NAME) %>% 
  group_by(NAME, race) %>% 
  count() %>% 
  ungroup()

il_race <- il_race %>% 
  spread(key = race, value = n)

race_count <-full_join(il_race, full_il, by = "NAME") %>% 
  st_as_sf()

# df for age group, first create df then spread so 1 row per county for merge 
# with spatial info, place 0 for all NA

il_age <- il_demog %>% 
  arrange(NAME) %>% 
  group_by(NAME, agegroup) %>% 
  count() %>% 
  ungroup()

il_age <- il_age %>% 
  spread(key = agegroup, value = n) # %>% 
# clean_names() # %>% # must exclude 'NAME' from change
# rename_all(str_remove("x", "_")) broken code to remove 'x'

age_count <-full_join(il_age, full_il, by = "NAME") %>% 
  st_as_sf()


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


#also facet counts per year
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