
"""
team: "Hello World!"
members: Pim Arendsen & Michel Kroeze
Geoscripting project 2019

"""

#import libraries
from pyproj import Proj, transform

def reproject(latitude, longitude):
    """
    Reproject from WGS84 to RD New
    
    Input args:
    -latitude
    -longitude
    
    Output:
    - x in m
    - y in m
    """
    
    inProj = Proj(init='epsg:4326') #WGS84
    outProj = Proj(init='epsg:28992') #RD New
    x, y = transform(inProj, outProj, longitude, latitude)
    return [x, y]