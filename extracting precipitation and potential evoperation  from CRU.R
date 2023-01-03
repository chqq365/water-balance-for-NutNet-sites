
## download, raster and intersect CRU timeseries monthly weather data for NutNet
## climate data downloaded from https://crudata.uea.ac.uk/cru/data/hrg/cru_ts_4.06/cruts.2205201912.v4.06/pet/
## read this article for introduction of the data https://www.nature.com/articles/s41597-020-0453-3
# useful background info netcdf datasets: http://www.image.ucar.edu/GSP/Software/Netcdf/

rm(list=ls())

## load packages needed
require(ncdf4)
require(data.table)
require(lubridate)
require(chron)
require(raster)
require(tidyverse)

setwd('H:/data from NutNet/SPEI/')

#  load NutNet geolocation data 
sites <- read.csv('comb-by-plot-clim-soil-2022-11-15.csv', header=T, sep=",")
sites2<-sites%>%dplyr::select("site_code", 'longitude','latitude')%>%distinct()

# take a variable to use: pet, pre, tmp, tmx, tmn, here focus on pre and pet
for (variable in c("pre", "pet")){
 
cruv <- variable
ncfile <- paste0('cru_ts4.06.1901.2021.',cruv,'.dat.nc')
nc <- nc_open(ncfile)
print(nc)

## adjust reference time to actual time using chron package
t <- ncvar_get(nc,'time')
nt <- dim(t)
tunits <- ncatt_get(nc,'time','units')$value
tustr <- strsplit(tunits, " ")
tdstr <- strsplit(unlist(tustr)[3],"-")
tmonth <- as.integer(unlist(tdstr)[2])
tday <- as.integer(unlist(tdstr)[3])
tyear <- as.integer(unlist(tdstr)[1])
realt <- chron(t,origin=c(tmonth,tday,tyear),format=c(dates="m/d/yyyy",times="h:m:s"))

# extract data for nutnet sites
sp <- SpatialPoints(sites2[,c('longitude','latitude')])
cru.rast <- raster(ncfile, band=2)
plot(cru.rast)
points(sp,cex=1.5,pch=16)

# make brick of all layers
cru.brick <- brick(ncfile)

nlayers(cru.brick) == nt # should equal number of months in time series

# extract each layer with lat-long points
NutNet.dat <- extract(cru.brick, sp)
dim(NutNet.dat) # sites=rows, times = cols
rownames(NutNet.dat) <- sites2$site_code
colnames(NutNet.dat) <- as.character(realt)
# any NAs
misng <- rownames(NutNet.dat[is.na(NutNet.dat[,1]),])

# reshape to long version data
# add year, month, date data
# add lon and lat data for all NutNet sites 
NutNet.dat1<-as.data.frame(NutNet.dat)
NutNet.dat1$site_code<-rownames(NutNet.dat1)
NutNet.dat.long <- NutNet.dat1%>%pivot_longer(cols = 1:1452, names_to = "date_time")%>%
  mutate(unit=ncatt_get(nc,cruv,'units')$value, years=substr(date_time, 8, 11), months=substr(date_time, 1,3), date=substr(date_time, 5,6)) %>%
  merge(sites2, by=c("site_code"))

# output the data
 write.csv(NutNet.dat.long, paste0('CRU-monthly-',cruv,'-1901-2021.csv'),row.names=F)

}

