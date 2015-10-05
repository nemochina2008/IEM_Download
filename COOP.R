library(jsonlite)

#
# Networks
add<-"http://mesonet.agron.iastate.edu/cgi-bin/request/coop.py?network="

networks<-c("ILCLIMATE","INCLIMATE","IACLIMATE","KSCLIMATE","KYCLIMATE","MICLIMATE","MNCLIMATE",
            "MOCLIMATE","NECLIMATE","OHCLIMATE","NDCLIMATE","SDCLIMATE","WICLIMATE")
#length(networks)
Stations<-data.frame()
Data<-data.frame()
## For all available networks
for(i in 1:length(networks)){
  ### get the stations in that netwrok
  a<-fromJSON(paste0("http://mesonet.agron.iastate.edu/geojson/network.php?network=",networks[i]))$features
  ## for the all stations in that netwrok get the data
  for(j in 1:length(a$id)){
  ### here you can change the stating  year, month and day (year1, month1, day1) and the same for end date(year2, month2, day2)
    add2<-paste0(add,networks[i],"&stations=",a$id[j],"&year1=1960&month1=1&day1=1&year2=2015&month2=1&day2=1&vars%5B%5D=apsim&what=view&delim=comma&gis=no&scenario_year=2013")
    filetxt<-read.csv(add2, skip = 10, sep = "")
    Data<-rbind(Data,cbind(rep(a$id[j],times=length(filetxt[,1])),filetxt))
    ### Save the station file for you
    write.csv(filetxt,paste0(networks[i],"_",a$id[j],".csv"))
  }
  
  ###### All stations
  cor<-a$geometry$coordinates
  Stations <- rbind(Stations,cbind(a$type,a$id,a$properties$sname,a$properties$sid,a$geometry$type,unlist(lapply(cor,function(x){unlist(x)[1]})),unlist(lapply(cor,function(x){unlist(x)[2]}))))
  
}
names(Data)<-c("SID","year","day","radn(MJ/m2)","maxt(c)","mint(c)","rain(mm)")
names(Stations)<-c("Type","id","sname","sid","gtype","long","lat")
## Write down the statiosn and weather data files
write.csv(Data,"ALLData.csv",row.names = FALSE)
write.csv(Stations,"Stations.csv")

