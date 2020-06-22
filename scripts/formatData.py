
"""
team: "Hello World!"
members: Pim Arendsen & Michel Kroeze
Geoscripting project 2019

"""

def formatResultsToDictionary(airq_list):
    
    """ 
    Function to format the downloaded API data into one easily accessible dictionary
    
    Input args:
        - airq_list: the output of the getDataSpecificStation function is written to the airq_list. 
                     This contains the raw airquality measurement of each selected station
        
    Output:
        - A dictionary of stations, where the value of each station is a dictionary containing a list 
        for the value from each report as well as its corresponding timestamp. 
    """
    
    
    # Removing empty lists from the input airquality_list
    airq_list2 = [x for x in airq_list if x != []]
    
    airq_per_station = dict()
    
    for station in airq_list2:
        # Copy the fixed info
        fixed = station[0]
        name = fixed["station_number"]
        this_station = { "formula": fixed["formula"], 
                               "station_number": name,
                               "value": [],
                               'timestamp_measured':[]
                             }
        # Now collect the values
        for record in station:
            this_station['timestamp_measured'].append(record['timestamp_measured'])
            this_station["value"].append(record["value"])
    
        # Save the station in our main dict
        airq_per_station[name] = this_station
    return airq_per_station