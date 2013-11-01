# shiny server side code for each call
shinyServer(function(input, output, session){
     #update variable and group based on dataset
     observe({
          obj<- VintageData #switch(input$dataset, "VintageData" = VintageData)
          var.opts<-namel(colnames(obj))
          var.opts.slicers <- var.opts[!(var.opts %in% c("vintage_unit_weight","vintage_unit_count",
                                                         "event_weight","event_weight_pct","event_weight_csum",
                                                         "event_weight_csum_pct","rn"))]
          var.none <- 'None'
          names(var.none) <- 'None'
          updateSelectInput(session, "source_slicers", choices = var.opts.slicers,selected= var.opts.slicers)
          updateSelectInput(session, "xaxis", choices = var.opts,selected="distance")
          updateSelectInput(session, "yaxis", choices = var.opts,selected="event_weight_csum_pct")
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
               p <- PlotVintageData(VintageData,x=input$xaxis, y=input$yaxis,facets='~region')     
          } else {
               p <- PlotVintageData(VintageData,x=input$xaxis,y=input$yaxis,cond=input$group, facets='~region')     
          }
          
          print(p)
     })	
})