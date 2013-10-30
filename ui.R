shinyUI(pageWithSidebar(
     # title
     headerPanel("Select Options"),
     
     #input
     sidebarPanel
     (
          selectInput("dataset","Data:", list(VintageData = "VintageData")),
          selectInput("xaxis","X Axis:", "Loading..."),
          selectInput("yaxis","Y Axis:", "Loading..."),
          selectInput("group","Group:" , "Loading..."),
          tags$textarea(id="facets", rows=1, cols=40, "Default value")          
          #selectInput("plot.type","Plot Type:", list(boxplot = "boxplot", histogram = "histogram", density = "density", bar = "bar")),
          #checkboxInput("show.points", "show points", TRUE),
     ),	
     
     # output				
     mainPanel(
          h3(textOutput("caption")),
          #h3(htmlOutput("caption")),
          uiOutput("plot") # depends on input 
     )
))