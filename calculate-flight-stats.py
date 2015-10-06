import numpy as np
import pandas as pd

df = pd.read_csv('data/2014-Jan.csv', header=0)
df.rename(columns={
	'ORIGIN_AIRPORT_ID': 'AirportID',
	'ARR_DEL15': 'Delayed',
	'CANCELLED': 'Cancelled'}, inplace=True)
df = df[['AirportID', 'Delayed', 'Cancelled']]

df.loc[df.Delayed.isnull(), 'Delayed'] = 0

dfStat = df.groupby('AirportID', as_index=False).mean()

airports = pd.read_csv('airports.csv')
airports.rename(columns={'AIRPORT_ID': 'AirportID',
						 'LATITUDE': 'Lat',
						 'LONGITUDE': 'Lon',
						 'AIRPORT_IS_LATEST': 'IsLatest'}, inplace=True)
airports = airports.loc[airports.IsLatest == 1, ['AirportID', 'Lat', 'Lon']]

joinedDF = pd.merge(dfStat, airports, on='AirportID')
joinedDF.to_csv('build/flights-stat.csv', index=False)