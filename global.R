#initialize
library(datasets)
library(ggplot2) 
#VintageData <- VintageData
#helper function (convert vector to named list)
namel<-function (vec){
     tmp<-as.list(vec)
     names(tmp)<-as.character(unlist(vec))
     tmp
}
