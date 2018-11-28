
# load libraries

library(tidyverse)
library(tigris)
library(ggplot2)
library(ggthemes)
library(sf)
library(leaflet)
library(sp)


# bring in polgyon info for IL counties

# IL FIPS = 17
il_counties <- counties(state = "IL", cb = TRUE, class = "sf") %>% 
  st_set_crs(NA) %>% 
  st_set_crs(4326)

il_sp <- sf:::as_Spatial(il_counties)

il_skeleton <- il_counties %>% 
  ggplot() +
  geom_sf(data = il_counties) 


#leaflet package

il <- leaflet(il_sp) %>%
  addPolygons() %>% 
  # setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>% 
  addProviderTiles("OpenStreetMap.BlackAndWhite") # %>%  
  # addPolygons(color = "black", weight = 1, fillOpacity = 0)

il

