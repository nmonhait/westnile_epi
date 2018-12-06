################## HELPER FILE FOR ILLINOIS SHINY APP ##################


########################## LOAD LIBRARIES ##############################
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


############################ PREPARE RAW DATA #################################

########### COUNTY-LEVEL WEST NILE VIRUS COUNTS ############

# West nile df, only used to create full_il df 
# county counts from full data set 
il_wnv <- read_csv("../data/data_il.csv") %>% 
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


############ DEMOGRAPHIC DATA BY CASE #############

# demographics from full data set
# demography df to join with county location, used to create function dfs
il_demog <-read_csv("../data/data_il.csv") %>% 
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


############# SPATIAL DATA PER COUNTY #############


# spatial information to be connected by county
# Tigris IL df, arrange in alphabetical order, used for spatial info
il_counties <- counties(state = "IL", cb = TRUE, class = "sf") %>% 
  st_set_crs(NA) %>%
  st_set_crs(4326) %>% 
  arrange(NAME)


######## MERGE COUNTY COUNT WITH SPATIAL DATA #####

# merge county count df with spatial df for blank map
# merge il_wnv and il_counties for blank map highlighted by county name and boundary
full_il <- full_join(il_wnv, il_counties, by = "NAME") %>% 
  group_by(NAME) %>% 
  ungroup() %>% 
  st_as_sf() %>% 
  select(NAME, geometry)



##############################################################################



################# MAKE DFs PER FILTER OPTION (year, sex/age/race) ######


#################### RACE DF AND FILTER FUNCTION #####################

# df for race 
il_race <- il_demog %>% 
  arrange(NAME) %>% 
  group_by(NAME, race, year) %>% 
  count() %>% 
  ungroup()

# function for race filter
race_fun <- function(year_choice) {
  
  r_count <- il_race %>% 
    spread(key = year, value = n) %>% 
    group_by(race) %>% 
    select(year_choice, NAME) %>% 
    spread(key = race, value = year_choice) 
  
  race_count <-full_join(r_count, full_il, by = "NAME") %>% 
    st_as_sf() 
  print(race_count)
}


#################### AGE GROUP DF AND FILTER FUNCTION ################

# df for age group
il_age <- il_demog %>% 
  arrange(NAME) %>% 
  group_by(NAME, agegroup, year) %>% 
  count() %>% 
  ungroup()

# function for age filter
age_fun <- function(year_choice) {
  
  a_count <- il_age %>% 
    spread(key = year, value = n) %>% 
    group_by(agegroup) %>% 
    select(year_choice, NAME) %>% 
    spread(key = agegroup, value = year_choice)
  
  age_count <-full_join(a_count, full_il, by = "NAME") %>% 
    st_as_sf()
  print(age_count)
}



################### SEX/GENDER DF AND FILTER FUNCTION ###################


# df for sex
il_sex <- il_demog %>% 
  arrange(NAME) %>% 
  group_by(NAME, gender, year) %>% 
  count() %>% 
  ungroup()


# function for sex filter
sex_fun <- function(year_choice) {
  
  s_count <- il_sex %>% 
    spread(key = year, value = n) %>% 
    group_by(gender) %>% 
    select(year_choice, NAME) %>% 
    spread(key = gender, value = year_choice)
  
  sex_count <-full_join(s_count, full_il, by = "NAME") %>% 
    st_as_sf()
  print(sex_count)
}


######################### PLOT MAP FUNCTION ##############################


# interactive leaflet plot- BLANK

basic_map <- leaflet(full_il) %>%
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
      bringToFront = TRUE))


######################### MAP OUTPUT FUNCTION ############################

# FUNCTION for map outputs for different demographic indicators
## df race_count, sex_count, age_count filtered by year of interest
### demog is subset of race, sex, age of interest (filtered data)

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


############################ FUNCTION EXAMPLES ############################

# 
# # function examples: 
# ## women in 2011
# w_2011 <- sex_fun(year_choice = '2011') 
# map_outputs(w_2011, w_2011$Female)
# 
# ## asians in 2010
# a_2010 <- race_fun(year_choice = '2010') 
# map_outputs(a_2010, a_2010$Asian)

