library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)

shinyServer(function(input, output, session) {

  #Set the data to reactive so that it updates when new file is selected
  dataInput <- reactive({
            
    #Analyze new CSV file when users click "Analyze Data"
    input$action
                            
      isolate({
        #Provide progress bar for users while app reads the CSV file
        withProgress(message="PLEASE WAIT...", detail="reading data", {
                                
        #Increment progress artificially so the user "sees" that it is working
        incProgress(0.1, detail="reading data")
        Sys.sleep(0.3)
        incProgress(0.5, detail="reading data")
                                
        #Use dtm() function from global.R to turn selected CSV file into Document Term Matrix
        if (!is.null(input$select))
        setwd("~/massmine/data")
        dtm(input$select)
        })
      })
  })
      
  #Create cluster graph for Cluster Analysis tab      
  output$plot <- renderPlot({
        
    #Set the reactive data input from selected file to data.analysis variable
    #This keeps the data from reloading every time a new tab is selected
    data.analysis <- dataInput()
          
    #Call a list of attributions to change the look of the cluster graph
    defAttrs <- getDefaultAttrs()
        
    #Creates cluster analysis using Rgraphviz
    plot(data.analysis, terms=findFreqTerms(data.analysis, lowfreq=input$freq)[1:input$words], 
             corThreshold=0.0, attrs=list(node=list(shape = "ellipse", fixedsize = FALSE, 
                                            fillcolor="lightblue", height="2.6", width="10.5", 
                                            fontsize="14")))
  })
})
