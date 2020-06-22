
"""
team: "Hello World!"
members: Pim Arendsen & Michel Kroeze
Geoscripting project 2019

This main python script is aimed at collecting all the necessary airquality measurement
data from the Luchtmeetnet API. Each hour during which airquality data is sampled is written
to a csv file for further analysis and visualization in R. 
"""

# Importing scripts
from scripts.timestamps import GetTimeStampList
from scripts.WriteCSVfiles import WriteCSVperHour

# Import libraries
import os

# Create directory structure
if not os.path.exists('data'):
    os.makedirs('data')
if not os.path.exists('output'):
    os.makedirs('output')
    
# Stations in Amsterdam according to the API with all stations. These are selected manually.
stations_data = {'name': ["Amsterdam-Einsteinweg",
                          "Amsterdam-Florapark",
                          "Amsterdam-Haarlemmerweg", 
                          "Amsterdam-Jan van Galenstraat",
                          "Amsterdam -Kantershof",
                          "Amsterdam-Nieuwendammerdijk", 
                          "Amsterdam-Ookmeer",
                          "Amsterdam-Oude Schans",
                          "Amsterdam-Prins Bernhardplein",
                          "Amsterdam-Stadhouderskade",
                          "Amsterdam-Van Diemenstraat",
                          "Amsterdam-Vondelpark",
                          "Amsterdam-Westerpark"],
                 'code': ["NL49007",
                          "NL10520",
                          "NL49002",
                          "NL49020",
                          "NL49021",
                          "NL49003",
                          "NL49022",
                          "NL49019",
                          "NL10544",
                          "NL49017",
                          "NL49012",
                          "NL49014",
                          "NL49016"],

            }


# Create a list of the hourly ISOtimestamps, which is used to write measurement values to CSV files
ISOtimestamps = GetTimeStampList(stations_data,'2016-12-31T20:00:00Z','2017-01-01T08:00:00Z','PM10')
WriteCSVperHour(stations_data, ISOtimestamps, 'PM10')