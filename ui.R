shinyUI(pageWithSidebar(
     # title
     headerPanel("Analysis setup"),
     
     #input
     sidebarPanel
     (
          selectInput("source_slicers","Source Slicers:", "Loading...",multiple=TRUE),
          selectInput("time_agg_unit","Time Aggregation:", "Loading..."),
          selectInput("xaxis","X Axis:", "Loading..."),
          selectInput("yaxis","Y Axis:", "Loading..."),
          selectInput("group","Group:" , "Loading..."),
          selectInput("left_facets","Left-side formula facets:" , "Loading...",multiple=TRUE,),          
          selectInput("right_facets","Right-side formula facets:" , "Loading...",multiple=TRUE)
     ),	
     
     # output				
     mainPanel(
          h3('Vintage Analysis'),
          uiOutput("plot")
     )
))