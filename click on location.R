#
# click on location - code enables manual correction of school geolocations
#

library(ggmap)

lokacije=read.csv("./za GitHub/lokacije_2020.csv",header=T,
                  stringsAsFactors = F,sep=";",quote = "'",
                  encoding = "UTF-8")

# click with the mouse on the most likely location of school
koordinate=data.frame()
niz=1:dim(lokacije)[1]
for (i in niz) {
  print(paste(i,": ",Sys.time()))
  filename=paste(lokacije$id_lokacije[i],".RData",sep="")
  if (file.exists(filename)) {
    mapiImage=load(filename)
    df=data.frame(long=as.numeric(c(lokacije$g_duzina[i],lokacije$ga_long[i],lokacije$gs_long[i],lokacije$long[i])),
                  lat=as.numeric(c(lokacije$g_sirina[i],lokacije$ga_lat[i],lokacije$gs_lat[i],lokacije$lat[i])))
    
    x11() # this works on Windows
    m=mapImage %>% ggmap(extent = "panel")+
      geom_point(data = df,mapping = aes(x = long,  y= lat),
                 colour=c("red","cyan","yellow","white"),
                 alpha=.25,size=5,stroke=1.2) +
      ggtitle(paste(lokacije$id_lokacije[i],": ",lokacije$naselje[i],"\n",
                    lokacije$naziv_ustanove[i],sep="")) +
      theme(legend.position="none",plot.title = element_text(size=10))
    print(m)
    
    a=gglocator()
    dev.off()
    koordinate=rbind(koordinate,c(lokacije$id_lokacije[i],a[[1]],a[[2]]))
  }
  names(koordinate)=c("id_lokacije","manual_long","manual_lat")
  write.csv(koordinate,"manualy corrected locations.csv")
}

