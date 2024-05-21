# I extended climate data to not only precipitation, potential evoperation, but also temperature. This includes Precipitation rate (PREmm/month), Mean 2 m temperature (TMP), and Diurnal 2 m temperature range (DTR),
Potential evapo-transpiration (PET mm/day)

# data from 1900 to 2022 are downloaded from (https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.07/cruts.2304141047.v4.07/pre/)
# read the article for introduction of the data: https://www.nature.com/articles/s41597-020-0453-3
 "Potential Evapotranspiration (PET) is calculated using the Penman-Monteith formula25 explained in26 (p1071–1072). For this we use the CRU TS gridded values of mean temperature, vapour pressure, cloud cover and static (temporally invariant except for the annual cycle) 1961–90 average wind field values (further described in5)"

# note that potential evaporation was calculated as average per day, need to transform to monthly data to match the data of precipitation. 
month.df <- data.frame(month = c("Jan","Feb", "Mar", "Apr", "May","Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"),
                       month1 = seq(1, 12, 1),
                       days = c(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31))

# output data files can be found: https://drive.google.com/drive/folders/1bimfTdV94PQqEbWd2FbFLvDaivvx5Xp4?usp=sharing
output 1: CRU-monthly-pet-1901-2022.csv (values are the average per day; average within each month);
output 2: CRU-monthly-pre-1901-2022.csv (values are the sum per month)
