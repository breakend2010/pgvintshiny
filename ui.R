shinyUI(pageWithSidebar(
     # title
     headerPanel("Analysis setup"),
     
     #input
     sidebarPanel
     (
          selectInput("source_slicers","Source Slicers:", "Loading...",multiple=TRUE),
          sliderInput("vintage_filter","Display each Nth distance:",min=1,max=12,step=1,value=1),          
          selectInput("xaxis","X Axis:", "Loading..."),
          selectInput("yaxis","Y Axis:", "Loading..."),
          selectInput("group","Group:" , "Loading..."),
          selectInput("left_facets","Left-side formula facets:" , "Loading...",multiple=TRUE,),          
          selectInput("right_facets","Right-side formula facets:" , "Loading...",multiple=TRUE)
     ),	
     
     # output				
     mainPanel(
          h3('Vintage Plot'),
          downloadLink('d', 'Download vintage data'),
          uiOutput("plot"),
          h3('Vintage Data'),
          uiOutput("table")          

     )
))