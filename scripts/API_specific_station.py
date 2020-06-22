
"""
team: "Hello World!"
members: Pim Arendsen & Michel Kroeze
Geoscripting project 2019

"""

import requests
import json

def getDataSpecificStation(station_number, start_date_time, end_date_time, formula='', page='1', order='formula', order_direction='asc'):
    
    """ 
    Function to get data from a specific station connected to Luchtmeetnet.
    
    Input args:
        - station_number, this is a specific number for the station 
        - start_date_time, this is the IS08601 representation of the start of the measurements
        - end_date_time, this is the IS08601 representation of the end of the measurements
        #### maximum time span of 7 days
        - forumula, the formula of a specific component for which to list the measurements, by default all components are requested
        - page, the page number of the results, request different pages when they are available, by default page = '1'
        - order, order the results by either 'formula' or 'timestamp_measured', by default order='formula'
        - order_direction, either 'asc' or 'desc', by default order_direction='asc'
        
    Output:
        - the request response model is converted to a json file, which is in this case a dictionary
    """

    url = 'https://api.luchtmeetnet.nl/open_api/measurements?start=%s&end=%s&station_number=%s&formula=%s&page=%s&order_by=%s&order_direction=%s' % (start_date_time, end_date_time, station_number, formula, page, order, order_direction)
    headers = {}
    payload = {}
    response = requests.request('GET', 
                                url, 
                                headers = headers, 
                                data = payload, 
                                allow_redirects=True)
                            
    json_data = json.loads(response.text)
    return json_data
