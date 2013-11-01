# shiny server side code for each call
shinyServer(function(input, output, session){
     #update variable and group based on dataset
     observe({

          require(pgvint)
          require(sqldf)
          cat(input$source_slicers)
          if (is.null(input$source_slicers)) {
               obj <- VintageData
          } else {
               obj<-AggregateVintageData(VintageData,Slicers=input$source_slicers)     
          }
          
          var.opts<-namel(colnames(obj))
          var.opts.original.slicers <- namel(colnames(VintageData))

          non.slicers <- c("vintage_unit_weight","vintage_unit_count","event_weight",
                           "event_weight_pct","event_weight_csum","event_weight_csum_pct","rn")
          
          var.opts.slicers <- var.opts[!(var.opts %in% non.slicers)]
          var.opts.original.slicers <- var.opts.original.slicers[!(var.opts.original.slicers %in% c(non.slicers,'distance'))]
          var.opts.measures <- var.opts[var.opts %in% non.slicers]
          
          var.none <- 'None'
          names(var.none) <- 'None'
          updateSelectInput(session, "source_slicers", choices = var.opts.original.slicers, selected=var.opts.slicers)
          updateSelectInput(session, "xaxis", choices = var.opts,selected="distance")
          updateSelectInput(session, "yaxis", choices = var.opts.measures,selected="event_weight_csum_pct")
          updateSelectInput(session, "group", choices = c(var.none,var.opts.slicers))
          updateSelectInput(session, "left_facets", choices = var.opts.slicers)          
          updateSelectInput(session, "right_facets", choices = var.opts.slicers)
          
     })
     
     output$plot <- renderUI({
          plotOutput("p")
     })
     
     #plotting function using ggplot2
     output$p <- renderPlot({
          
          require(ggplot2)
          if (input$group == 'None') {
               p <- PlotVintageData(AggregateVintageData(VintageData,Slicers=input$source_slicers)
                                    ,x=input$xaxis, y=input$yaxis)     
          } else {
               p <- PlotVintageData(AggregateVintageData(VintageData,Slicers=input$source_slicers)
                                    ,x=input$xaxis,y=input$yaxis,cond=input$group)     
          }
          
          print(p)
     })	
})