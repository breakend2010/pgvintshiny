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
          tags$textarea(id="facets", rows=3, cols=40, "Default value")          
     ),	
     
     # output				
     mainPanel(
          h3(textOutput("caption")),
          #h3(htmlOutput("caption")),
          uiOutput("plot") # depends on input 
     )
))