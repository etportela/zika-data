library (gtrendsR)
library(lubridate)
library(stringr)
library(dplyr)

city_trend = data.frame(location=character(),
                        hits=integer(),
                        keyword=character(),
                        geo=character(),
                        gprop=character(),
                        month_year=character(),
                        stringsAsFactors=FALSE)

region_trend = city_trend

keywords=c("zika virus")
channel='web'
geo="BR"

# coleta os dados do google trends por mes, partindo de 01/01/2015, ate 31/12/2016
month_list=seq(ymd(20160101), ymd(20161201), by ="month")
for (i in seq_along(month_list)){
  print(paste0("Processando mes/ano ", month(month_list[i]), "/", year(month_list[i]), "..."))
  s_date = month_list[i]
  l_date = ceiling_date(s_date, "month") - days(1)
  month_year = paste0(str_pad(month(s_date), 2, pad = "0"), "-", year(s_date))

  tmp_trend = gtrends(keywords, gprop=channel, geo=geo, time=paste(s_date, l_date), low_search_volume=TRUE)

  # city data
  tmp_city_trend = tmp_trend$interest_by_city
  if (typeof(tmp_city_trend) == "NULL"){
    print(">>> sem dados para a cidade")
  } else {
    tmp_city_trend['month_year'] = month_year
    city_trend = rbind(city_trend, tmp_city_trend)
  }
  # region data
  tmp_region_trend = tmp_trend$interest_by_region
  if (typeof(tmp_region_trend) == "NULL"){
    print(">>> sem dados para a regiao")
  } else {
    tmp_region_trend['month_year'] = month_year
    region_trend = rbind(region_trend, tmp_region_trend)
  }
}

# fill NA
city_trend[is.na(city_trend)] = 0
region_trend[is.na(region_trend)] = 0

# siglas de UF
gtrendsR_states = read.csv2(file = 'gtrendsR_states.csv', header = TRUE)

# join
region_trend = merge(region_trend, gtrendsR_states, by="location")

# save to csv
# write.csv2(city_trend,'city_trend.csv', row.names = FALSE, fileEncoding = "CP1252")
write.csv2(region_trend,'region_trend.csv', row.names = FALSE, fileEncoding = "CP1252")
