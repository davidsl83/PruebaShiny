####################################
#### Google Analytics - server.R ###
####################################

library(shiny)
library(plyr)
library(ggplot2)

load("analytics.Rdata") # load the dataframe
load("EntornoMARIACRISTINA.Rdata") # load the dataframe

shinyServer(function(input, output) { # server is defined within these parentheses
  
  # prep data once and then pass around the program
  
  passData <- reactive({
    
    analytics <- analytics[analytics$Date %in% seq.Date(input$dateRange[1], input$dateRange[2], by = "days"),]
    
    analytics <- analytics[analytics$Hour %in% as.numeric(input$minimumTime) : as.numeric(input$maximumTime),]
    
    if(class(input$domainShow)=="character"){
      
      analytics <- analytics[analytics$Domain %in% unlist(input$domainShow),]
      
    }
    
    analytics
    
  })
  
  output$monthGraph <- renderPlot({
    
    graphData <- ddply(passData(), .(Domain, Date), numcolwise(sum))
    
    if(input$outputType == "visitors"){
      
      theGraph <- ggplot(graphData, aes(x = Date, y = visitors, group = Domain, colour = Domain)) + geom_line() +
        ylab("Unique visitors")
      
    }
    
    if(input$outputType == "bounceRate"){
      
      theGraph <- ggplot(graphData, aes(x = Date, y = bounces / visits * 100, group = Domain, colour = Domain)) +
        geom_line() + ylab("Bounce rate %")
      
    }
    
    if(input$outputType == "timeOnSite"){
      
      theGraph <- ggplot(graphData, aes(x = Date, y = timeOnSite / visits, group = Domain, colour = Domain)) +
        geom_line() + ylab("Average time on site")
      
    }
    
    if(input$smoother){
      
      theGraph <- theGraph + geom_smooth()
      
    }
    
    print(theGraph)
    
  })
  
  output$hourGraph <- renderPlot({
    
    graphData = ddply(passData(), .(Domain, Hour), numcolwise(sum))
    
    if(input$outputType == "visitors"){
      
      theGraph <- ggplot(graphData, aes(x = Hour, y = visitors, group = Domain, colour = Domain)) + geom_line() +
        ylab("Unique visitors")
      
    }
    
    if(input$outputType == "bounceRate"){
      
      theGraph <- ggplot(graphData, aes(x = Hour, y = bounces / visits * 100, group = Domain, colour = Domain)) +
        geom_line() + ylab("Bounce rate %")
      
    }
    
    if(input$outputType == "timeOnSite"){
      
      theGraph <- ggplot(graphData, aes(x = Hour, y = timeOnSite / visits, group = Domain, colour = Domain)) +
        geom_line() + ylab("Average time on site")
      
    }
        
    if(input$smoother){
      
      theGraph <- theGraph + geom_smooth()
      
    }
    
    print(theGraph)
    
  })
  
  
  output$textDisplay <- renderText({ 
    
    paste(
      length(seq.Date(input$dateRange[1], input$dateRange[2], by = "days")),
      " days are summarised. There were", sum(passData()$visitors), "visitors in this time period. - ", input$k_decimal
    )
    
  })
  
  
  
  
  
  output$CurvaPrediccion <- renderPlot({
    
	envelopea = NULL
	envelopea = rbind(envelopea,data.frame(timestamp = test$timestamp, EnvelopDownValue = test$Forecast - (test$ErrorSuave * input$k_decimal),
		EnvelopUpValue = test$Forecast + (test$ErrorSuave * input$k_decimal), K = input$k_decimal))
	
	test_graf_envelope = ggplot()
	test_graf_envelope = test_graf_envelope + geom_line(data=test, aes(x=timestamp,y=value),colour="#000099")
	test_graf_envelope = test_graf_envelope + geom_ribbon(data=envelopea[envelopea$K == input$k_decimal,], aes(x=timestamp, ymin = EnvelopDownValue, ymax = EnvelopUpValue),fill = "#00FF00", alpha = 0.3)		
	test_graf_envelope = test_graf_envelope + ggtitle(paste("Detección para K = ", input$k_decimal, sep=""))					
	test_graf_envelope = test_graf_envelope + theme(plot.title = element_text(size = 7),legend.position="top",legend.title = element_text(size = 7), legend.text = element_text(size = 7),axis.text=element_text(size = 7), axis.title=element_text(size = 7))					
        
    print(test_graf_envelope)
    
  })
  
  
  
  
})