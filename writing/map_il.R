library(tidyverse)
library(tigris)
library(ggplot2)
library(ggthemes)
library(sf)
library(leaflet)
#bring in polgyon info for IL counties
#IL FIPS = 17
il_counties <- counties(state = "IL", cb = TRUE, class = "sf") %>% 
  st_set_crs(NA) %>% st_set_crs(4326)

il_sp <- sf:::as_Spatial(il_counties)

il_skeleton <- il_counties %>% 
  ggplot() +
  geom_sf(data = il_counties) 


#leaflet package

<<<<<<< HEAD
il <- leaflet() %>%
  addPolygons(data = il_sp) %>% 
  addProviderTiles("OpenStreetMap.BlackAndWhite") 


il

#add latitude and longitude to original dataset

library(readr)
data_il <- read_csv("data/data_il.csv") %>% 
  rename(NAME = il)

il_counties_2 <- il_counties %>% 
  select(STATEFP, COUNTYFP, geometry, NAME) 

full_il <- inner_join(data_il, il_counties, by = "NAME")
=======
il <- leaflet(il_counties) %>%
  setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>% 
  addProviderTiles("OpenStreetMap.BlackAndWhite") %>%  
  addPolygons(color = "black", weight = 1, fillOpacity = 0)

il

>>>>>>> eabc2323fb179ca2081ee8ca333109a9476f1a17
