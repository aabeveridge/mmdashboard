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
      pldata <- dtm("~/Desktop/data/advice_yj.csv")
      incProgress(1, detail="complete")
      
      })
      
      output$plot <- renderPlot({
        defAttrs <- getDefaultAttrs()
        
        plot(pldata, terms=findFreqTerms(pldata, lowfreq=input$freq)[1:input$words], 
             corThreshold=input$corThresh, attrs=list(node=list(shape = "box", fixedsize = FALSE, 
                                            fillcolor="lightblue", fontsize="30")))
  })
})