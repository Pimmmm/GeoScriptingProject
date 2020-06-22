# Team: "Hello World!"
# Members: Pim Arendsen & Michel Kroeze
# Geoscripting project 2019

# This main Rscript reads the airquality data csv files, creates interpolation rasters and visualizes the
# rasters in leaflet. The leaflet maps are then written to html outputs, as well as PNG images.

# Output:
#   - 13 leaflet airquality maps written to HTML files
#   - 13 airquality maps to PNG images

# Installing packages
if (!require("sp"))
{install.packages("sp")}

if (!require("raster"))
{install.packages('raster')}

if (!require("RColorBrewer"))
{install.packages('RColorBrewer')}

if (!require("htmlwidgets"))
{install.packages('htmlwidgets')}

if (!require("webshot"))
{install.packages('webshot')}


# Calling the libraries
library(sp)
library(raster)
library(RColorBrewer)
library(htmlwidgets)
library(webshot)

# Import functions
source('Rscripts/downloadWFS.R')
source('Rscripts/csvtospatial.R')
source('Rscripts/create_interpolation_raster.R')
source('Rscripts/createLeafletMaps.R')


# Neighbourhoods in Amsterdam
neighbourhoods <- c("Burgwallen-Nieuwe Zijde", 'Burgwallen-Oude Zijde', "Nieuwmarkt/Lastage", "Haarlemmerbuurt", "Grachtengordel-West",
                    "Jordaan", 'Grachtengordel-Zuid', 'De Weteringschans', 'Weesperbuurt/Plantage', 'Oostelijke Eilanden/Kadijken', 'Spaarndammer- en Zeeheldenbuurt',
                    'Houthavens','Sloterdijk', 'Staatsliedenbuurt', 'Centrale Markt', 'Frederik Hendrikbuurt', 'Landlust', 'Erasmuspark', 'Geuzenbuurt', 'Van Galenbuurt',
                    'Hoofdweg e.o.', 'Chassébuurt', 'Da Costabuurt', 'Kinkerbuurt', 'Van Lennepbuurt', 'Westindische Buurt', 'Overtoomse Sluis', 'Helmersbuurt', 'Vondelbuurt',
                    'Hoofddorppleinbuurt', 'Schinkelbuurt', 'Stadionbuurt', 'Willemspark', 'Museumkwartier', 'Apollobuurt', 'Prinses Irenebuurt e.o.', 'Oude Pijp', 'Nieuwe Pijp',
                    'Zuid Pijp', 'IJselbuurt', 'Scheldebuurt', 'Rijnbuurt', 'Omval/Overamstel', 'Betondorp', 'Frankendael', 'Weesperzijde', 'Oosterparkbuurt', 'Transvaalbuurt',
                    'Middenmeer', 'Indische Buurt Oost', 'Dapperbuurt', 'Indische Buurt West', 'Oostelijk Havengebied', 'Noordelijke IJ-oevers Oost', 'IJplein/Vogelbuurt', 
                    'Volewijck', 'Noordelijke IJ-oevers West', 'Tuindorp Oostzaan', 'Oostzanerwerf', 'Kadoelen', 'Banne Buiksloot', 'Elzenhagen', 'Buikslotermeer', 'Waterlandpleinbuurt',
                    'Tuindorp Nieuwendam', 'Tuindorp Buiksloot', 'Nieuwendammerdijk/Buiksloterdijk', 'Westelijk Havengebied')

# Create an outline of Amsterdam and use it as mask
amsterdam_mask <- getOutline('https://www.cbs.nl/-/media/cbs/dossiers/nederland%20regionaal/wijk-en-buurtstatistieken/2018/shape%202018%20versie%2010.zip', neighbourhoods)
amsterdam_mask <- spTransform(amsterdam_mask, CRS("+init=epsg:28992"))

# List all the CSV files that were created in the Python script
csv_files <- list.files(path = "data", pattern = glob2rx('*.csv'), full.names = TRUE)

# Create an empty raster to store the interpolated values as rasterlayer                     
all_rasters <- brick()

# Start a count for the 'for-loop'
i = 1

# For every CSV file a interpolation is performed. This interpolation raster is added to the main raster
for (file in csv_files){
  csv_read <- read.csv(file, header=TRUE)
  
  # Convert the CSV file to a SpatialPointDataFrame
  stations <- convertCSVtoSpatial(csv_read, 28992)
  
  # Perform the interpolation on the stations with a mask 
  interpolation_raster <- stationInterpolation(stations, amsterdam_mask, 10000, 3.0)
  
  # Resample all the interpolation rasters to the first interpolation raster
  if (i>1){
    interpolation_raster <- resample(interpolation_raster, all_rasters[[1]])
  }
  
  all_rasters <- addLayer(all_rasters, interpolation_raster)
  i = i+1
}


# Set up variables for Leaflet: create a color palette and costum markers
pal <- colorNumeric(palette = colorRampPalette(brewer.pal(9,"YlOrRd"))(100), 
                    reverse=FALSE, domain = c((min(minValue(all_rasters))-1):(max(maxValue(all_rasters))+1)), na.color = '#00000000')
my_icon <- awesomeIcons(icon = "angle-double-down", library = 'fa',
                        markerColor = "blue")

# For each sequential hour during which airquality data was sampled, read the CSV file,
# convert it to an SP dataframe with WGS84 projection. The leaflet maps are written to the output
# folder as HTML's.
sampleHours <- seq(1, dim(all_rasters)[3], by = 1)
for (i in sampleHours){
  csv_read <- read.csv(csv_files[i], header=TRUE)
  stationsWGS84 <- convertCSVtoSpatial(csv_read, 4326)
  LeafletMaps(i, stationsWGS84, all_rasters)
}


# Write the output .html files to a list, then write each .html file to a .png
html_files <- list.files(path = "output/", pattern = glob2rx('*.html'), full.names = TRUE)
# The webshot package requires manual installation of the phantomJS package:
webshot::install_phantomjs()
for(file in html_files){
  webshot(file, paste0(file,'.png'))
  }

