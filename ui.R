shinyUI(pageWithSidebar(
     # title
     headerPanel("Select Options"),
     
     #input
     sidebarPanel
     (
          selectInput("xaxis","X Axis:", "Loading..."),
          selectInput("yaxis","Y Axis:", "Loading..."),
          selectInput("group","Group:" , "Loading..."),
          selectInput("left_facets","Left-side formula facets:" , "Loading...",multiple=TRUE),          
          selectInput("right_facets","Left-side formula facets:" , "Loading...",multiple=TRUE),   
          tags$textarea(id="facets", rows=3, cols=40, "Default value")          
     ),	
     
     # output				
     mainPanel(
          h3(textOutput("caption")),
          uiOutput("plot") # depends on input 
     )
))