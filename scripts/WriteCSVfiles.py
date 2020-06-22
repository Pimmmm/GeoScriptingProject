
"""
team: "Hello World!"
members: Pim Arendsen & Michel Kroeze
Geoscripting project 2019

"""

# Importing scripts and libraries
from scripts.API_specific_station import getDataSpecificStation
from scripts.API_general_data_from_station import getStationData
from scripts.formatData import formatResultsToDictionary
from scripts.Reproject import reproject
import pandas as pd

def WriteCSVperHour(stations_code, time_list, formula):
        
    """
    This function writes hourly measurement data to separate CSV files containing the station codes, station coordinates, 
    pollutant formula and pollutant values.
    
    Input args:
    - stations_code: this should be a dictionary which has a key with all the station codes 
    - time_list: this should be a list of timestamps in the ISO8601 representation
    - formula: this is the formula of the pollutant as a string
    
    Output:
    - CSV file for each hourly timestamp
    """
   
    for time in time_list:
        
        # Defining dictionary keys which will become column names for the CSV files
        data_dict = {'station_code': [],
                     'value':[],
                     'formula':[],
                     'x':[],
                     'y':[],
                     'time':[],
                     'date':[]
                    }
        
        
        airq_list = []
        # Download the airquality data per station from the Luchtmeetnet API and append it to a list
        for station_code in stations_code['code']:
            airq_data = getDataSpecificStation(station_code, time, time, formula)
            airq_list.append(airq_data['data'])
            
        # Format the API data to a dictionary of stations, where the value of each station is a dictionary 
        # containing a list for the value from each report as well as its corresponding timestamp.
        # So collect the constant part first, then gather the values in a list.
        airq_per_station = formatResultsToDictionary(airq_list)
          
        # Append the needed data to the data dictionary by looping through the value of each station (which is a dictionary)
        for station in airq_per_station:
            data_dict['station_code'].append(station)
            data_dict['value'].append(airq_per_station[station]['value'][0])
            data_dict['formula'].append(airq_per_station[station]['formula'])
            data_dict['time'].append(airq_per_station[station]['timestamp_measured'][0][11:19])
            data_dict['date'].append(airq_per_station[station]['timestamp_measured'][0][:10])    
            
        
        
        # Add the coordinates in RD_New projection for each station
        for name in data_dict['station_code']:
            data = getStationData(name)
            lat, lon = data['data']['geometry']['coordinates']
            x, y = reproject(lat, lon)
            data_dict['x'].append(x)
            data_dict['y'].append(y)
        
        # Export the data_dict to a CSV file with the timestamp as name
        
        timestamp_df = pd.DataFrame(data_dict)
        timestamp_df.to_csv('data/%s.csv' %time)
        
            
