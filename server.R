# shiny server side code for each call
shinyServer(function(input, output, session){
     #update variable and group based on dataset
     observe({
          if (is.null(input$dataset))
               return()
          obj<-switch(input$dataset,
                      "iris" = iris,
                      "mtcars" = mtcars,
                      "VintageData" = VintageData)	 
          var.opts<-namel(colnames(obj))
          updateSelectInput(session, "xaxis", choices = var.opts)
          updateSelectInput(session, "yaxis", choices = var.opts)
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
          
          #xaxis <- get(input$dataset)[[input$xaxis]]
          #yaxis <- get(input$dataset)[[input$yaxis]]
          #if (is.null(xaxis) || is.null(yaxis))
          #     return(NULL)
          
          plot.obj<<-list() # not sure why input$X can not be used directly?
          plot.obj$data<<-get(input$dataset) 
          plot.obj$xaxis<<-with(plot.obj$data,get(input$xaxis)) 
          plot.obj$yaxis<<-with(plot.obj$data,get(input$yaxis)) 
          
          #dynamic plotting options
          plot.type<-switch(input$plot.type,
                            "boxplot" 	= 	geom_boxplot(),
                            "histogram" =	geom_histogram(alpha=0.5,position="identity"),
                            "density" 	=	geom_density(alpha=.75),
                            "bar" 		=	geom_bar(position="dodge")
          )
          
          require(ggplot2)

          cat(plot.obj$axis,'\n')
          p <- PlotVintageData(VintageData,x=input$xaxis, y=input$xaxis, cond="product",facets="~region")
          print(p)
     })	
})