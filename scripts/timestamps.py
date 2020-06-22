
"""
team: "Hello World!"
members: Pim Arendsen & Michel Kroeze
Geoscripting project 2019

"""

# Importing scripts
from scripts.API_specific_station import getDataSpecificStation
from scripts.formatData import formatResultsToDictionary

def GetTimeStampList(stations_codes, start_time, end_time, formula):
    
    """
    This functions returns a list of the different timestamps in ISO8601 representation 
    during which which pollutant values were measured.
    
    Input args:
    - stations_codes, this should be a dictionary which has a key with all the station codes
    - start_time, this is the starting time of the measurements in ISO8601 representation as a string
    - end_time, this is the end time of the measurements in ISO8601 representation as a string
    - formula, this is the formula of the pollutant as a string
    
    """
    # airq = air quality
    airq_list = [] 
    
    # Download the airquality data per station from the Luchtmeetnet API and append it to a list
    for station_code in stations_codes['code']:
        airq_data = getDataSpecificStation(station_code, start_time, end_time, formula)
        airq_list.append(airq_data['data'])
        
    # Format the downloaded API data to a dictionary of stations, where the value of each station is a dictionary 
    # containing a list for the value from each report as well as its corresponding timestamp. 
    # So collect the constant part first, then gather the values in a list.
    airq_per_station = formatResultsToDictionary(airq_list)
    
    timestamps = []
    for station in airq_per_station:
        for timestamp in airq_per_station[station]['timestamp_measured']:
            timestampISO = timestamp[:-6] + 'Z' # converting timestamps to ISO8601 representation
            if timestampISO not in timestamps:
                timestamps.append(timestampISO)
    return timestamps
                
