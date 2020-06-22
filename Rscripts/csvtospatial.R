# team: "Hello World!"
# members: Pim Arendsen & Michel Kroeze
# Geoscripting project 2019

# This function converts CSV files created with the Python script to a SpatialPointDataFrame. 
#
# Input args:
#   - CSV file: with x and y values as coordinates
#   - output crs
#
# Output:
#   - SpatialPointDataFrame

# Installing packages
if (!require("sf"))
  {install.packages("sf")}

# Calling libraries
library(sf)

convertCSVtoSpatial <- function(CSVfile, crs_output){
  points <- st_as_sf(x = CSVfile, 
                     coords = c("x", "y"),
                     crs = "+proj=sterea +lat_0=52.15616055555555 +lon_0=5.38763888888889 +k=0.9999079 +x_0=155000 +y_0=463000 +ellps=bessel +towgs84=565.4171,50.3319,465.5524,-0.398957,0.343988,-1.87740,4.0725 +units=m +no_defs")
  
  stations <- st_transform(points, crs= crs_output)
  stations <- as(stations, "Spatial")
  return(stations)
}

