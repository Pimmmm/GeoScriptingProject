# Team: "Hello World!"
# Members: Pim Arendsen & Michel Kroeze
# Geoscripting project 2019

# This function performs an inverse distance weighting interpolation on the input stations 
# and returns a masked raster of the interpolation. 
#
# Input args:
#   - i: loops through the sequence of sample hours based on a rasterbrick containing the interpolated raster maps
#   - station_input: a SpatialPointsDataFrame containing the location and measurement values of each airquality measurement station
#   - rasterbrick: a rasterbrick containing the interpolated airquality rastermaps
#
# Output:
#   - masked interpolation raster

# Installing packages
if (!require('leaflet'))
{install.packages("leaflet")}

# Calling libraries
library(leaflet)

LeafletMaps <- function(i, station_input, rasterbrick){
  m <- leaflet() %>% setView(lng = 4.8951679, lat = 52.3702157, zoom = 12)
  m <- m %>% addProviderTiles(providers$Stamen.Toner) %>%
    addRasterImage(rasterbrick[[i]], opacity = 0.9, colors = pal) %>%
    addProviderTiles(providers$Stamen.TonerLines,
                     options = providerTileOptions(opacity = 0.5)) %>%
    addProviderTiles(providers$Stamen.TonerLabels) %>%
    addAwesomeMarkers(data = station_input, icon=my_icon, popup = paste((station_input$value),(station_input$formula),'μg/m3')) %>%
    addControl(paste("The effect of fireworks on particulate matter (PM) pollution in the centre of Amsterdam<br>",
                     "Date:",station_input$date[[1]]," Time:", station_input$time[[1]]), position = "topright") %>%
    addLegend(pal= pal ,values = values(rasterbrick),
              title = paste("Air Polution<br>",station_input[[4]][1], 'μg/m3'), opacity = 1)
  date <- station_input$date[[1]]
  time <- station_input$time[[1]]
  saveWidget(m, file=paste0(getwd(),'/output/',date,'T',time,'.html'))
}

