#
# school geocode - code for collecting available locations from Google maps
#


# you should register for Google Geocoding API at https://developers.google.com
# and get your own API_key

library(ggmap)

# put your API_key instead of %%%%%%%%% to register the service 
register_google("%%%%%%%%%")

# reading data sheets with school data: school id, school name, address, 
# settlement and municipality names
lokacije=read.csv("lokacije.csv",header=T,sep="\t",
                  stringsAsFactors = F,
                  quote="'",encoding = "UTF-8")

# looking for school locations based on school addresses
#
ga_location=data.frame(lokacije$id_lokacije,NA,NA)
for (i in 1:dim(lokacije)[1]) {
  if (!lokacije$adresa[i]=="") {
    adresa=paste(lokacije$adresa[i],",",
                 lokacije$naselje[i],",",lokacije$opstina[i])
    a=geocode(adresa, output = "all")
    ga_location[i,2]=a$results[[1]]$geometry$location$lng 
    ga_location[i,3]=a$results[[1]]$geometry$location$lat 
    Sys.sleep(runif(1)*3) # wait a little between requests
  }
  print(i)
}
names(ga_location)=c("id_lokacije","ga_long","ga_lat")

# looking for locations based on school and settlement names
#
schword="школа" # word for school in local language
gs_location=data.frame(lokacije$id_lokacije,NA,NA)
for (i in 1:dim(lokacije)[1]) {
  zgrada=paste(schword,lokacije$naziv_ustanove[i],",",
               lokacije$naselje[i])
  a=geocode(zgrada, output = "all")
  if (!is.na(a[[1]])) {
    gs_location[i,2]=a$results[[1]]$geometry$location$lng 
    gs_location[i,3]=a$results[[1]]$geometry$location$lat 
  }
  Sys.sleep(runif(1)*3)
  print(i)
}
names(gs_location)=c("id_lokacije","gs_long","gs_lat")

# writing down these additional locations
gags=cbind(ga_location,gs_location[,-1])
write.csv(gags,"gags.csv")



