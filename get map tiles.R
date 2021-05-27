#
# get map tiles - code for downloading schools' vicinity map tiles 
#

library(ggmap)
library(RColorBrewer)

# put your API_key instead of %%%%%%%%% to register the service 
register_google("%%%%%%%%%")

# reading data sheets with various school locations data
lokacije=read.csv("lokacije_2020.csv",header=T,
                  stringsAsFactors = F,sep=";",
                  encoding = "UTF-8")


# if there is a correct official location, it should be in the center of the tile
niz=1:dim(lokacije)[1]
for (i in niz) {
  df=data.frame(long=lokacije$g_duzina,lat=lokacije$g_sirina)[i,]
  loc=as.numeric(df)
  if (!any(is.na(loc))) {
    mapImage <- get_map(location = loc,
                        color = "color",
                        source = "google",
                        maptype = "hybrid",
                        zoom = 17)
    print(paste(i,": ",Sys.time()))
    save(mapImage,file=paste(lokacije$id_lokacije[i],".RData",sep=""))
      }
}

# if there is no official location, use location from the cadastre
niz=which(is.na(lokacije$g_duzina) & !is.na(lokacije$rgz_long))
for (i in niz) {
  df=data.frame(long=lokacije$rgz_long,lat=lokacije$rgz_lat)[i,]
  loc=as.numeric(df)
  if (!any(is.na(loc))) {
    mapImage <- get_map(location = loc,
                        color = "color",
                        source = "google",
                        maptype = "hybrid",
                        zoom = 17)
    print(paste(i,": ",Sys.time()))
    save(mapImage,file=paste(lokacije$id_lokacije[i],".RData",sep=""))
  }
}


# if official location is not in the contour, use location from the cadastre
niz=which(lokacije$u_konturi==FALSE & !is.na(lokacije$rgz_long))
for (i in niz) {
  df=data.frame(long=lokacije$rgz_long,lat=lokacije$rgz_lat)[i,]
  loc=as.numeric(df)
  if (!any(is.na(loc))) {
    mapImage <- get_map(location = loc, # lon = 20.91068 , lat = 44.21075),
                        color = "color",
                        source = "google",
                        maptype = "hybrid",
                        zoom = 17)
    print(paste(i,": ",Sys.time()))
    save(mapImage,file=paste(lokacije$id_lokacije[i],".RData",sep=""))
  }
}


# if there is no available contoure, use official location
bezkonture <- which(is.na(lokacije$u_konturi))
niz <- bezkonture
for (i in niz) {
  df=data.frame(long=lokacije$g_duzina,lat=lokacije$g_sirina)[i,]
  loc=as.numeric(df)
  if (!any(is.na(loc))) {
    mapImage <- get_map(location = loc,
                        color = "color",
                        source = "google",
                        maptype = "hybrid",
                        zoom = 17)
    print(paste(i,": ",Sys.time()))
    save(mapImage,file=paste(lokacije$id_lokacije[i],".RData",sep=""))
  }
}


# if birh official and cadastre locations are out of contoure, 
# use location based on school name and settlement
po_skolama=which(lokacije$u_konturi==FALSE & lokacije$u_konturi_rgz==0 & 
                   !is.na(lokacije$gs_long))
for (i in po_skolama) {
  df=data.frame(long=lokacije$gs_long,lat=lokacije$gs_lat)[i,]
  loc=as.numeric(df)
  if (!any(is.na(loc))) {
    mapImage <- get_map(location = loc,
                        color = "color",
                        source = "google",
                        maptype = "hybrid",
                        zoom = 17)
    print(paste(i,": ",Sys.time()))
    save(mapImage,file=paste(lokacije$id_lokacije[i],".RData",sep=""))
  }
}

# if everything else fails, use location based on address
po_adresama=which(lokacije$u_kutiji==FALSE & lokacije$u_konturi_gs==FALSE & 
                    lokacije$u_konturi_ga==TRUE)
for (i in po_adresama) {
  df=data.frame(long=lokacije$ga_long,lat=lokacije$ga_lat)[i,]
  loc=as.numeric(df)
  if (!any(is.na(loc))) {
    mapImage <- get_map(location = loc,
                        color = "color",
                        source = "google",
                        maptype = "hybrid",
                        zoom = 17)
    print(paste(i,": ",Sys.time()))
    save(mapImage,file=paste(lokacije$id_lokacije[i],".RData",sep=""))
  }
}

# check if there some tiles are missing
nedostaje=c()
for (i in niz) {
  filename=paste(lokacije$X.U.FEFF.id_lokacije[i],".RData",sep="")
  print(paste(i,": ",lokacije$id_lokacije[i],file.exists(filename)))
  if (!file.exists(filename)) nedostaje2=c(nedostaje2, i)
}

