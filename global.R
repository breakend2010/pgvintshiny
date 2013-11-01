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



PlotVintageData <- function(data=NULL,x="distance",y="event_weight_csum_pct",cond=NULL,facets=NULL) {
     
     #require(ggplot2)
     
     `%ni%` <- Negate(`%in%`)
     
     DisplayVars <- names(data)[!(names(data) %in% c("distance","vintage_unit_weight","vintage_unit_count","event_weight",
                                                     "event_weight_pct","event_weight_csum","event_weight_csum_pct",
                                                     "rn"))]  
     for (col in names(data)) {
          if (class(data[[col]])[1] %in% c("Date",'POSIXct','POSIXt')) {
               data[[col]] <- as.factor(data[[col]])
          }
     }
     
     BasicPlot <- ggplot(data, aes_string(x=x, y=y))
     
     if (x %ni% names(data)) stop (paste("Variable",x,"is not in data frame."))
     if (y %ni% names(data)) stop (paste("Variable",y,"is not in data frame."))
     if (length(cond)>1) stop (paste("Only one variable can be specified for conditioning."))
     if (length(cond)==1) {
          if (cond %ni% names(data)) stop (paste("Conditioning variable",cond,"is not in data frame."))
     }
     if(!is.null(facets) ) {
          # add sanity check
     }
     
     if (!is.null(cond)) {
          BasicPlot <- BasicPlot + geom_line(aes_string(group=cond, colour=cond))
     } else {
          BasicPlot <- BasicPlot + geom_line()
     }
     
     
     if(!is.null(facets)) {
          if (substr(facets,1,1) == "~" & !grepl("+",facets,fixed=TRUE)) {
               BasicPlot <- BasicPlot + facet_wrap(as.formula(facets))            
          } else {
               BasicPlot <- BasicPlot + facet_grid(as.formula(facets))      
          }
     }
     
     BasicPlot + 
          ylab("Vintage measure") +
          ggtitle("Vintage Analysis") 
     #scale_x_continuous(expand = c(0, 0)) + scale_y_continuous(expand = c(0, 0))
}


AggregateVintageData <- function(VintageData=NA,Slicers=NA,Type='include',TimeAggregationUnit=1,SQLModifier=NA, Verbose=FALSE) {
     
     if (!is.data.frame(VintageData)) {
          stop("Object specified as VintageData is not data frame.")
     }
     
     RawColumns <- c('distance', 'vintage_unit_weight','vintage_unit_count','event_weight',
                     'event_weight_pct','event_weight_csum','event_weight_csum_pct')
     
     if (!all(RawColumns %in% names(VintageData))) {
          stop("All columns available in result of GetVintageData have to be present in provided data frame.")
     } else {
          if(Verbose) cat("All required columns are available in VintageData.\n")
     }
     
     
     if (!all(is.na(Slicers))) {
          if (!all(Slicers %in% names(VintageData))) {
               stop("Some Slicer does not exist in VintageData.")
          } else {
               if(Verbose) cat("All Slicers found in VintageData.\n")
          }
          
     }
     
     AvailableSlicers <- names(VintageData)[!(names(VintageData) %in% c(RawColumns,'rn'))]
     
     
     if(Type=='include') {
          if(Verbose) cat("Specified Slicers will be included and all others excluded.\n")
          UsedSlicers <- Slicers
          if(Verbose) cat("Slicers required in results: ", UsedSlicers,"\n")
     } else if (Type == 'exclude') {
          if(Verbose) cat("Specified Slicers will be excluded and all other included.\n")
          UsedSlicers <- AvailableSlicers[!(AvailableSlicers %in% Slicers)]
          if(Verbose) cat("Slicers required in results: ", UsedSlicers,"\n")
     } else {
          stop("Type can be one of 'include' and 'exclude'.")
     }
     
     AggregationSQL <- paste(
          "select ",
          if(!all(is.na(UsedSlicers))) paste(paste(UsedSlicers," ",collapse=","),","), 
          "distance/",TimeAggregationUnit,"as distance,",
          "
        sum(vintage_unit_weight) as vintage_unit_weight,
        sum(vintage_unit_count) as vintage_unit_count,
        sum(event_weight) as event_weight,
        sum(event_weight)/sum(vintage_unit_weight) as event_weight_pct ,
        sum(event_weight_csum) as event_weight_csum,
        sum(event_weight_csum)/sum(vintage_unit_weight) as event_weight_csum_pct 
    from"
          , deparse(substitute(VintageData)), 
          "where",
          if(!is.na(SQLModifier)) SQLModifier else "1=1",
          "group by",
          if(!all(is.na(UsedSlicers))) paste(paste(UsedSlicers," ",collapse=","),","), 
          "distance"
     )
          
     if(Verbose) cat("Used SQL: \n", AggregationSQL,"\n")
     
     sqldf(AggregationSQL, drv='SQLite')
}