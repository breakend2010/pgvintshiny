# shiny server side code for each call
shinyServer(function(input, output, session){
     #update variable and group based on dataset
     observe({

          require(pgvint)
          require(sqldf)
          require(WriteXLS)

          if (is.null(input$source_slicers)) {

               VintageDataTmp <<- AggregateVintageData(VintageData,Slicers=NA)     
          } else {
               VintageDataTmp<<-AggregateVintageData(VintageData,Slicers=input$source_slicers)     
          }
          
          mdist <- max(VintageDataTmp$distance)
          
          if (input$vintage_filter != 1) {
               VintageDataTmp <<- VintageDataTmp[VintageDataTmp$distance %in% seq(input$vintage_filter - 1 , mdist, input$vintage_filter), ]
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
          updateSliderInput(session, "vintage_filter", value=input$vintage_filter)
          updateSelectInput(session, "xaxis", choices = var.opts,selected="distance")
          updateSelectInput(session, "yaxis", choices = var.opts.measures,selected="event_weight_csum_pct")
          updateSelectInput(session, "group", choices = c(var.none,var.opts.slicers),selected=input$source_slicers[1])
          updateSelectInput(session, "left_facets", choices = var.opts.slicers, selected = var.opts.left.slicers)          
          updateSelectInput(session, "right_facets", choices = var.opts.slicers, selected = var.opts.right.slicers)
          
     })
     

     output$all <- renderUI({

          list(plotOutput("p"),tableOutput("t"))

     })
     
     #table function
     output$t <- renderTable({
          tmp <- c (input$source_slicers, input$time_agg_unit, input$vintage_filter)
          t <- PrintVintageData(VintageDataTmp,Digits=2)[[6]]
          t
          })

     output$d <- downloadHandler( 
          filename = function() {
               paste('data-', Sys.Date(), '.xls', sep='')
          },
          content = function(file) {          
               tmp <- c (input$source_slicers, input$time_agg_unit, input$vintage_filter)
               PrintVintageData(VintageDataTmp,Result='xls',File=file)
          },
          'application/vnd.ms-excel'
     )
     
     #plotting function using ggplot2
     output$p <- renderPlot({
          require(ggplot2)
          tmp <- c(input$time_agg_unit, input$vintage_filter)
          if (length(input$right_facets) == 0 & length(input$left_facets) != 0) {
               frm_text <- paste0('~',paste0(input$left_facets,collapse="+"))
          } else if (length(input$right_facets) != 0 & length(input$left_facets) ==0) {
               frm_text <- paste0('~',paste0(input$right_facets,collapse="+"))
          } else if (length(input$right_facets) != 0 & length(input$left_facets) !=0) {
               frm_text <- paste0(paste0(input$left_facets,collapse="+"),'~',paste0(input$right_facets,collapse="+"))
          } else {
               frm_text <- NULL
          }
          
          
          if (input$group == 'None') {
               p <- PlotVintageData(VintageDataTmp,x=input$xaxis, y=input$yaxis, facets=frm_text)     
          } else {
               p <- PlotVintageData(VintageDataTmp,x=input$xaxis,y=input$yaxis,cond=input$group, facets=frm_text)
          }
          
          print(p)
     })	
})