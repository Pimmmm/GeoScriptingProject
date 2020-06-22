# Team: "Hello World!"
# Members: Pim Arendsen & Michel Kroeze
# Geoscripting project 2019

# This function performs an inverse distance weighting interpolation on the input stations 
# and returns a masked raster of the interpolation. 
#
# Input args:
#   - input_stations: preferably the returned value of the convertCSVtoSpatial function
#   - mask: the outline for the interpolation raster
#   - cells_in_grid: numeric value, number of cells in the interpolation raster
#   - idwpower: numeric value, the inverse distance weighting power
#
# Output:
#   - masked interpolation raster

# Install packages
if (!require("gstat"))
  {install.packages("gstat")}

if (!require("sp"))
  {install.packages("sp")}

# Calling libraries
library(sp)
library(gstat)

stationInterpolation <- function(input_stations, mask, cells_in_raster, idwpower){
  
  # Set bounding box of the stations to that of the mask
  input_stations@bbox <- mask@bbox
  
  # Create an empty grid where n is the total number of cells
  grd              <- as.data.frame(spsample(input_stations, "regular", n=cells_in_raster))
  names(grd)       <- c("X", "Y")
  coordinates(grd) <- c("X", "Y")
  gridded(grd)     <- TRUE  # Create SpatialPixel object
  fullgrid(grd)    <- TRUE  # Create SpatialGrid object
  
  # Add stations' projection information to the empty grid
  proj4string(grd) <- proj4string(input_stations)
  
  # Perform the IDW interpolation and mask it
  stations.idw <- gstat::idw(value ~ 1, input_stations, newdata=grd, idp=idwpower)
  r <- raster(stations.idw)
  
  extent(r) <- extent(mask)
  r.m <- mask(r, mask)
  
  return(r.m)  
}
