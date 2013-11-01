# shiny server side code for each call
shinyServer(function(input, output, session){
     #update variable and group based on dataset
     observe({
          #if (is.null(input$dataset))
          #     return()

          obj<- VintageData #switch(input$dataset, "VintageData" = VintageData)
          var.opts<-namel(colnames(obj))
          updateSelectInput(session, "xaxis", choices = var.opts)
          updateSelectInput(session, "yaxis", choices = var.opts)
          updateSelectInput(session, "group", choices = var.opts)          
          
     })
     
     output$plot <- renderUI({
          plotOutput("p")
     })
     
     #plotting function using ggplot2
     output$p <- renderPlot({
          
          require(ggplot2)
          p <- PlotVintageData(VintageData,x=input$xaxis, y=input$yaxis, cond=input$group,facets=input$facets)
          print(p)
     })	
})