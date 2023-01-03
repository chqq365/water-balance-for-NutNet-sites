# water-balance-for-NutNet-sites

# precipitation and potential evoperation data from 1900 to 2021 are downloaded from https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/cruts.2205201912.v4.06/pet/
# read the article for introduction of the data: https://www.nature.com/articles/s41597-020-0453-3
 "Potential Evapotranspiration (PET) is calculated using the Penman-Monteith formula25 explained in26 (p1071–1072). For this we use the CRU TS gridded values of mean temperature, vapour pressure, cloud cover and static (temporally invariant except for the annual cycle) 1961–90 average wind field values (further described in5)"

# note that potential evaporation was calculated as average per day, need to transform to monthly data to match the data of precipitation. 
month.df <- data.frame(month = c("Jan","Feb", "Mar", "Apr", "May","Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
                       month1 = seq(1, 12, 1),
                       days = c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))
