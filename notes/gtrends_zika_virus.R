library (gtrendsR)
keywords=c("Zika Virus")
channel='web'
geo="BR"
time=("2014-01-01 2018-12-31")
trends = gtrends(keywords, gprop=channel, geo=geo, time=time, low_search_volume=TRUE)
city_trend=trends$interest_by_city
city_trend
