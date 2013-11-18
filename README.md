# Interactive analysis of vintage data
`pgvintshiny` application can be used to interactively analyze vintage data.

## Pre-requisites
* R version 3.02 or higher
* PostgreSQL version 9.1 or higher
* ggplot2, sqldf, RPostgreSQL, devtools, XLSWrite, reshape2
* pgvint, shiny (>0.8, currently not in CRAN!)

## How to start
`pgvintshiny` can work with outputs from functions `GetVintageData` and `AggregateVintageData` in `pgvint` package. To make
this work, you need to have a data frame named `VintageData` in your workspace. This data frame needs to have fixed structure as
defined in `pgvint` documentation.

To install development version of `shiny` use:

     if (!require("devtools"))
       install.packages("devtools")
     devtools::install_github("shiny", "rstudio")

### Demo
!Caution: This will create data frame named VintageDataTmp in your global environment. Check that no binding is currently used for VintageDataTmp as the demo will overwrite object with this name.

If you would like to see the application with sample data, you can use:

    library(devtools)
    install_github("pgvint",username="tomasgreif")
    library(pgvint)  
    library(shiny) 
    data(VintageData) 
    runGitHub(repo="pgvintshiny",username="tomasgreif")     

This should result in:

![alt tag](http://www.analytikdat.cz/images/easyblog_images/923/20131020-get-vintage-data-postgresql-r/pgvintshiny-vintage-data-analysis-interactive-shiny-app.png)

### Usage
By default, all Slicers available in VintageData (see `pgvint` documentation if you do not understand what Slicer is) will be used to produce meaningfull output.
First Slicer will be used as a group, others will be used for facetting. By default, distance is on X axis and event_weight_csum_pct on Y axis.

If you select different combination of Source Slicers, than the underlying dataset is recalculated using `AggregateVintageData` function and new default view is displayed.

You can create your own view by selecting columns for X axis, Y axis, in-chart grouping (Group) and facetting.

#Important
This is important notice: All **selected** Source Slicers have to be used somewhere in the configuration! If you do not want to use some Source Slicer than deselect it first.