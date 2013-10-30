# shiny server side code for each call
shinyServer(function(input, output, session){
     #update variable and group based on dataset
     observe({
          #if (is.null(input$dataset))
          #     return()

          objects <- as.vector(sapply(sapply(ls(), get), is.data.frame))
          df.opts <- names(objects[objects])          
          
          #obj<-switch(input$dataset, df.opts)
          updateSelectInput(session, "dataset", choices = df.opts)
          updateSelectInput(session, "xaxis", choices = var.opts)
          updateSelectInput(session, "yaxis", choices = var.opts)
          updateSelectInput(session, "group", choices = var.opts)          
          
     })
     
     output$caption<-renderText({
          switch(input$plot.type,
                 "boxplot" 	= 	"Boxplot",
                 "histogram" =	"Histogram",
                 "density" 	=	"Density plot",
                 "bar" 		=	"Bar graph")
     })
     
     
     output$plot <- renderUI({
          plotOutput("p")
     })
     
     #plotting function using ggplot2
     output$p <- renderPlot({
          
     
          #dynamic plotting options
          plot.type<-switch(input$plot.type,
                            "boxplot" 	= 	geom_boxplot(),
                            "histogram" =	geom_histogram(alpha=0.5,position="identity"),
                            "density" 	=	geom_density(alpha=.75),
                            "bar" 		=	geom_bar(position="dodge")
          )
          
          require(ggplot2)

          cat(plot.obj$axis,'\n')
          p <- PlotVintageData(VintageData,x=input$xaxis, y=input$yaxis, cond=input$group,facets="~region")
          print(p)
     })	
})