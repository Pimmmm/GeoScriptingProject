
"""
team: "Hello World!"
members: Pim Arendsen & Michel Kroeze
Geoscripting project 2019

"""

import requests
import json

def getStationData(station_number):
    """
    Function to get specifics from a selected station
    
    Input args:
        - station_number, the station number of the selected station
        
    Output:
        - json file, as dictionary containing information about: year_start, organisation, components, location, 
        geometry, type, municipality, province, url 
        ## Only available if provided by the station
    """
    
    url = 'https://api.luchtmeetnet.nl/open_api/stations/%s' % station_number
    payload = {}
    headers = {}
    response = requests.request('GET', 
                                url, 
                                headers = headers, 
                                data = payload, 
                                allow_redirects=False)
                                
    station_data = json.loads(response.text)
    return station_data


station_data = getStationData('NL49014')                            
lat, lon = station_data['data']['geometry']['coordinates']

station_data
