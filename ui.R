###############################
### Google Analytics - ui.R ###
###############################

library(shiny) 

shinyUI(pageWithSidebar( 
  
  headerPanel("Analisis de datos"), 
  
  sidebarPanel( 
    
    dateRangeInput(inputId = "dateRange",  
                   label = "Date range", 
                   start = "2013-04-01",
                   max = Sys.Date()
    ),
    
    #Slider para la selección de K
    sliderInput("k_decimal", "Valor de K:", 
                min = 0.1, max = 20, value = 5, step= 0.1,
				animate=animationOptions(interval=1000, loop=FALSE)),
	
	sliderInput(inputId = "minimumTime",
                label = "Hours of interest- minimum",
                min = 0,
                max = 23,
                value = 0,
                step = 1),
    
    sliderInput(inputId = "maximumTime",
                label = "Hours of interest- maximum",
                min = 0,
                max = 23,
                value = 23,
                step = 1),
    
    checkboxInput(inputId = "smoother",
                  label = "Add smoother?",
                  value = FALSE),
    
    checkboxGroupInput(inputId = "domainShow",
                       label = "Show NHS and other domain (defaults to all)?",
                       choices = list("NHS users" = "NHS",
                                      "Other" = "Other")
                       ),
    
    radioButtons(inputId = "outputType",
                 label = "Output required",
                 choices = list("Visitors" = "visitors",
                                "Bounce rate" = "bounceRate",
                                "Time on site" = "timeOnSite"))
  ),
  mainPanel(
    tabsetPanel( 
      tabPanel("Summary", textOutput("textDisplay")), 
      tabPanel("Monthly figures", plotOutput("monthGraph")),
      tabPanel("Hourly figures", plotOutput("hourGraph")),
	  tabPanel("Predicción y K", plotOutput("CurvaPrediccion"))
    )
  )
))