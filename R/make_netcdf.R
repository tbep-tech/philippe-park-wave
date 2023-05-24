library(readxl)
library(ncdf4)

pth <- '~/Desktop/206871_20221222_2048.xlsx'
shts <- excel_sheets(pth) %>% 
  grep('^Data', ., value = T)

out <- NULL
for(sht in shts){
  cat(sht, '\n')
  
  tmp <- read_excel(pth, sheet = sht, skip = 1)
  tmp$Time <- as.numeric(tmp$Time)
  names(tmp) <- c('time', 'pressure', 'pressure1', 'pressure2', 'pressure3', 'sea_pressure', 'depth')
  tmp <- tmp[, c('pressure', 'pressure1', 'pressure2', 'pressure3', 'sea_pressure', 'depth', 'time')]
  
  out <- rbind(out, tmp)
  dim(out)
  
}

time_dim <- ncdim_def("time", "milliseconds since 1970-01-01 00:00:00", out$time, longname = 'Time')

mv <- NA
pressure <- ncvar_def("pressure", "dbar", list(time_dim), missval = mv, longname = 'Sea water pressure')
pressure1 <- ncvar_def("pressure1", "dbar", list(time_dim), missval = mv, longname = 'Sea water pressure')
pressure2 <- ncvar_def("pressure2", "dbar", list(time_dim), missval = mv, longname = 'Sea water pressure')
pressure3 <- ncvar_def("pressure3", "dbar", list(time_dim), missval = mv, longname = 'Sea water pressure')
sea_pressure <- ncvar_def("sea_pressure", "dbar", list(time_dim), missval = mv, longname = 'Sea water pressure')
depth <- ncvar_def("depth", "m", list(time_dim), missval = mv, longname = 'Depth')

nc_create('~/Desktop/206871_20221222_2048.nc', list(pressure, pressure1, pressure2, pressure3, sea_pressure, depth))

