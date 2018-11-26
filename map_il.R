library(tidyverse)
library(tigris)
library(ggplot2)
library(ggthemes)
library(sf)
library(leaflet)
#bring in polgyon info for IL counties
#IL FIPS = 17
il_counties <- counties(state = "IL", cb = TRUE, class = "sf")

il_skeleton <- il_counties %>% 
  ggplot() +
  geom_sf(data = il_counties) 

#leaflet package

il <- leaflet(il_counties) %>%
  setView(lng = -89.3985, lat = 40.6331, zoom = 8) %>% 
  addProviderTiles("OpenStreetMap.BlackAndWhite") %>%  
  addPolygons(color = "black", weight = 1, fillOpacity = 0)