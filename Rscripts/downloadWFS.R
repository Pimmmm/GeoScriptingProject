# team: "Hello World!"
# members: Pim Arendsen & Michel Kroeze
# Geoscripting project 2019

# This function downloads Dutch neighbourhood boundaries from the CBS. 
#
# Input args:
#   - url: url location of the neighborhoods zip file
#   - neighbourhood_list: list of neighourhoods on which the interpolation raster can be masked
#
# Output:
#   - outline of the listed neighbourhoods

# Installing packages
if (!require("rgdal"))
  {install.packages("rgdal")}

# Calling libraries

library(rgdal)

getOutline <- function(url, neighbourhood_list){
  # Download the zipfile and unzip it if it doesnt exists
  
  if (!file.exists('data/NLboundaries')){
    download.file(url, destfile = 'data/NLboundaries', method = 'auto')
    unzip('data/NLboundaries', exdir = 'data')
  }
  
  # Read the file
  nb <- readOGR(dsn = "data/Uitvoer_shape", layer = "wijk_2018")

  neighbourhoods <- nb[which(nb$WK_NAAM %in% neighbourhood_list),]
  outline <- aggregate(rbind(neighbourhoods))
  return(outline) 
}
