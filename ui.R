shinyUI(pageWithSidebar(
     # title
     headerPanel("Select Options"),
     
     #input
     sidebarPanel
     (
           selectInput("dataset","Data:", "Loading..." ),
           selectInput("xaxis","X Axis:", "Loading..."),
           selectInput("yaxis","Y Axis:", "Loading..."),
           selectInput("group","Group:" , "Loading..."),
          
          selectInput("plot.type","Plot Type:", 
                      list(boxplot = "boxplot", histogram = "histogram", density = "density", bar = "bar")
          ),
          checkboxInput("show.points", "show points", TRUE)
     ),	
     
     # output				
     mainPanel(
          h3(textOutput("caption")),
          #h3(htmlOutput("caption")),
          uiOutput("plot") # depends on input 
     )
))