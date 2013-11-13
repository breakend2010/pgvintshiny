# shiny server side code for each call
shinyServer(function(input, output, session){
     #update variable and group based on dataset
     observe({

          require(pgvint)
          require(sqldf)

          if (input$time_agg_unit == 'Loading...') {
               time_agg_unit <- 1
          } else {
               time_agg_unit <- input$time_agg_unit
          }
          
          cat(time_agg_unit)

          if (is.null(input$source_slicers)) {

               VintageDataTmp <<- AggregateVintageData(VintageData,Slicers=NA
                                                       ,TimeAggregationUnit=time_agg_unit
                                                       )     
          } else {
               VintageDataTmp<<-AggregateVintageData(VintageData,Slicers=input$source_slicers
                                                     ,TimeAggregationUnit=time_agg_unit
                                                     )     
          }
          
          var.opts<-namel(colnames(VintageDataTmp))
          var.opts.original.slicers <- namel(colnames(VintageData))

          non.slicers <- c("vintage_unit_weight","vintage_unit_count","event_weight",
                           "event_weight_pct","event_weight_csum","event_weight_csum_pct","rn")
          
          var.opts.slicers <- var.opts[!(var.opts %in% non.slicers)]
          var.opts.original.slicers <- var.opts.original.slicers[!(var.opts.original.slicers %in% c(non.slicers,'distance'))]
          var.opts.measures <- var.opts[var.opts %in% non.slicers]
          
          var.opts.left.slicers <- NA
          var.opts.right.slicers <- NA          
          
          if (length(input$source_slicers) == 2) {
               var.opts.left.slicers <- input$source_slicers[2]
          } else if (length(input$source_slicers) == 3) {
               var.opts.left.slicers <- input$source_slicers[2]
               var.opts.right.slicers <- input$source_slicers[3]               
          } else if (length(input$source_slicers) > 3) {
               var.opts.left.slicers <- input$source_slicers[2:3]
               var.opts.right.slicers <- input$source_slicers[4:length(input$source_slicers)]
          }
                    
          var.none <- 'None'
          names(var.none) <- 'None'
          updateSelectInput(session, "source_slicers", choices = var.opts.original.slicers, selected=var.opts.slicers)
          updateSelectInput(session, "time_agg_unit", choices = namel(1:10), selected=input$time_agg_unit)
          updateSelectInput(session, "xaxis", choices = var.opts,selected="distance")
          updateSelectInput(session, "yaxis", choices = var.opts.measures,selected="event_weight_csum_pct")
          updateSelectInput(session, "group", choices = c(var.none,var.opts.slicers),selected=input$source_slicers[1])
          updateSelectInput(session, "left_facets", choices = var.opts.slicers, selected = var.opts.left.slicers)          
          updateSelectInput(session, "right_facets", choices = var.opts.slicers, selected = var.opts.right.slicers)
          
     })
     
     output$plot <- renderUI({
          plotOutput("p")
     })
     
     #plotting function using ggplot2
     output$p <- renderPlot({
          require(ggplot2)
     
          if (length(input$right_facets) == 0 & length(input$left_facets) != 0) {
               frm_text <- paste0('~',paste0(input$left_facets,collapse="+"))
          } else if (length(input$right_facets) != 0 & length(input$left_facets) ==0) {
               frm_text <- paste0('~',paste0(input$right_facets,collapse="+"))
          } else if (length(input$right_facets) != 0 & length(input$left_facets) !=0) {
               frm_text <- paste0(paste0(input$left_facets,collapse="+"),'~',paste0(input$right_facets,collapse="+"))
          } else {
               frm_text <- NULL
          }
          cat(paste(unique(c(input$right_facets, input$left_facets,input$group, input$xaxis),collapse=',')),'\n')
          
          
          if (input$group == 'None') {
               p <- PlotVintageData(VintageDataTmp,x=input$xaxis, y=input$yaxis, facets=frm_text)     
          } else {
               p <- PlotVintageData(VintageDataTmp,x=input$xaxis,y=input$yaxis,cond=input$group, facets=frm_text)
          }
          
          print(p)
     })	
})