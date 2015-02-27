library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)

shinyServer(function(input, output, session) {

  #Set the data to reactive so that it updates when new file is selected
  dataInput <- reactive({
  infile <- input$file1
  if (is.null(infile)) {
        
  # User has not uploaded a file yet
  return(NULL)
  }
  read.csv(infile$datapath, header=TRUE, sep=",")
  
  })
  
#   d.1 <- reactive({
#   input$action
#   inData <- dataInput()
#   if (is.null(inData)) {
#   return(NULL)
#   }
#   withProgress({
#   incProgress(0.3, detail="WORKING...")
#   Sys.sleep(0.4)
#   incProgress(0.5, detail="WORKING...")
#   dtm(dataInput())
#   incProgress(1, detail="COMPLETE")
#   })
#   })
#   dataDtm <- reactive({
#   
#     #Analyze new CSV file when users click "Analyze Data"
#     input$action
#                               
#         isolate({
#           #Provide progress bar for users while app reads the CSV file
#           withProgress({
#           setProgress(message="working")
#           dtm(dataInput())
#           setProgress(message="complete")
#           })
#         })
#   })

  #Create cluster graph for Cluster Analysis tab      
  output$plot <- renderPlot({
        
    #Call a list of attributions to change the look of the cluster graph
    defAttrs <- getDefaultAttrs()
    
    withProgress({
      incProgress(0.3, detail="WORKING...")
      Sys.sleep(0.4)
      incProgress(0.5, detail="WORKING...")
    d.1 <- dtm(dataInput())
      incProgress(1, detail="COMPLETE")
    })
        
    #Creates cluster analysis using Rgraphviz
    plot(d.1, terms=findFreqTerms(d.1, lowfreq=input$freq)[1:input$words], 
             corThreshold=0.0, attrs=list(node=list(shape = "ellipse", fixedsize = FALSE, 
                                            fillcolor="lightblue", height="2.6", width="10.5", 
                                            fontsize="14")))
  })
})
