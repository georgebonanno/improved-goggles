library(ggmap)

source("visualizations.R")

updateGeoLocWithNAs <- function(geoLocs,meanPriceLoc) {
  uniques <- unique(meanPricePerLocation$location)
  
  for (unLoc in uniques) {
    if (is.na(geoLocs[unLoc,]$location)) {
      geoLocs <- rbind(geoLocs,data.frame(location=c(unLoc),
                                          lat=c(NA),
                                          long=c(NA)))
    }
  }
  return(geoLocs)
}

 showMapWithMeanPriceLocation <- function(meanPricePerLocation) {
  geoLocs <- read.csv('geoLocations.csv',
                      colClasses = c('character','numeric','numeric'))
  
  geoLocs <- updateGeoLocWithNAs(geoLocs,meanPricePerLocation)
  meanPricePerLocation <- merge(meanPricePerLocation,geoLocs,by="location")
  meanPricePerLocation <- meanPricePerLocation[!is.na(meanPricePerLocation$lat),]
  
  maltaMap <- get_map(location = "malta", maptype = "roadmap", zoom = 11)
  
  print(meanPricePerLocation)
  
  meanPriceMap <- 
    ggmap(maltaMap) +
    geom_point(data = meanPricePerLocation, 
               aes(x = long, y = lat,
               size=price_euro),colour="blue",alpha = (0.5))
  
  return(meanPriceMap)
  
 }
 
 meanPricePerLocation <- 
   calculateMeanPricePerLocation(propDetails)
 showMapWithMeanPriceLocation(meanPricePerLocation)


