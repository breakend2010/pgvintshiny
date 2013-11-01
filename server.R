# shiny server side code for each call
shinyServer(function(input, output, session){
     #update variable and group based on dataset
     observe({
          #if (is.null(input$dataset))
          #     return()

          obj<- VintageData #switch(input$dataset, "VintageData" = VintageData)
          var.opts<-namel(colnames(obj))
          updateSelectInput(session, "xaxis", choices = var.opts,selected="distance")
          updateSelectInput(session, "yaxis", choices = var.opts,selected="event_weight_csum_pct")
          updateSelectInput(session, "group", choices = var.opts)
          updateSelectInput(session, "left_facets", choices = var.opts)          
          updateSelectInput(session, "right_facets", choices = var.opts)
          
     })
     
     output$plot <- renderUI({
          plotOutput("p")
     })
     
     #plotting function using ggplot2
     output$p <- renderPlot({
          
          require(ggplot2)
          p <- PlotVintageData(VintageData,x=input$xaxis, y=input$yaxis, cond=input$group,facets='~region')
          print(p)
     })	
})