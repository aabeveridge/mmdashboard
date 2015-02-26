library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(memoise)

#########################################################################
# Code was taken from: http://shiny.rstudio.com/gallery/word-cloud.html #
#########################################################################

  shinyServer(function(input, output) {
      
      withProgress(message="PLEASE WAIT...", detail="reading data", {
      incProgress(0.5, detail="reading data")
      pldata <- dtm("~/trend_monitor/data/sinkhole.csv")
      incProgress(1, detail="complete")
      
      })
      
      output$plot <- renderPlot({
        defAttrs <- getDefaultAttrs()
        
        plot(pldata, terms=findFreqTerms(pldata, lowfreq=input$freq)[1:input$words], 
             corThreshold=0.0, attrs=list(node=list(shape = "ellipse", fixedsize = FALSE, 
                                            fillcolor="lightblue", height="2.6", width="10.5", 
                                            fontsize="14")))
  })
})