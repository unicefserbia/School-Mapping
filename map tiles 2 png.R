#
# map tiles 2 png - converts map tiles to png and marks known locations
#

library(ggmap)

# reading data sheets with school various school locations data
lokacije=read.csv("./za GitHub/lokacije_2020.csv",header=T,
                  stringsAsFactors = F,sep=";",
                  encoding = "UTF-8")

# creating png files with colored circles denoting known locations
niz=1:dim(lokacije)[1]
for (i in niz) {
  filename=paste(lokacije$id_lokacije[i],".RData",sep="")
  print(paste(i,": ",Sys.time(),file.exists(filename)))
  if (file.exists(filename)) {
    mapiImage=load(filename)
    df=data.frame(long=c(lokacije$g_duzina[i],lokacije$ga_long[i],lokacije$gs_long[i],lokacije$long[i]),
                  lat=c(lokacije$g_sirina[i],lokacije$ga_lat[i],lokacije$gs_lat[i],lokacije$lat[i]))
    
    mapImage %>% ggmap()+
      geom_point(data = df,mapping = aes(x = long,  y= lat),
                 colour=c("red","cyan","yellow","white"),alpha=.30,size=5,stroke=.5) +
      ggtitle(paste(lokacije$id_lokacije[i],": ",lokacije$naselje[i],"\n",
                    "\"",lokacije$naziv_ustanove[i],"\"",sep="")) +
      theme(legend.position="none",plot.title = element_text(size=10))
    
        # with + x11() opens possiblity for gglocator()
    
    ggsave(paste(lokacije$id_lokacije[i],".png",sep=""),dpi=320,width=4,height=4)
  }
}
