library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)

shinyServer(function(input, output, session) {
    
  #This is the output for the summary tab
  #The input for this tab are mapped from the table1 and file1 inputs
  #from the UI page
  output$table1 <- renderTable({
    
    #The withProgress() function lets the user know that the
    #system is working. There are ways to make it more
    #complex by embedding the function in an if statement
    #while 
    withProgress(message="PLEASE WAIT...", {
      incProgress(0.3, detail="working")
      
      #Loading the file into shiny with the browse function
      infile <- input$file1
      if (is.null(infile)) {
        return(NULL)
      }
      
      #The "datapath" is where the input$file1 actually saves
      #the loaded file in memory/temp
      load(infile$datapath)
      
      #This creates the word frequency table on summary page
      freq <- colSums(as.matrix(dtm))
      ord <- order(freq)
      freq1 <- as.data.frame(freq[tail(ord, input$length1)])
      names(freq1) <- c("Total")
      freq1
    })
  })
  
  #This doesn't work yet, and I don't remember what I was making...lol
  output$table2 <- renderTable({
      withProgress(message="PLEASE WAIT...", {
        incProgress(0.3, detail="working")
      
        infile <- input$file1
        if (is.null(infile)) {
          return(NULL)
        }
        load(infile$datapath)
        freq <- colSums(as.matrix(dtm))
        length(freq)
      })
  })
  
  #This is the output for the Time Series tab in the UI
  #You can change this to renderPlot or other reactive
  #functionality depending on your output
  output$table3 <- renderTable({
  }) 
  
  #Create cluster graph for Cluster Analysis tab      
  output$plot <- renderPlot({
    
    #Call a list of attributions to change the look of the cluster graph
    defAttrs <- getDefaultAttrs()
    
    infile <- input$file1
    if (is.null(infile)) {
      return(NULL)
    }
    load(infile$datapath)
    
    #Provide progress bar while plot is being created
    withProgress(message="PLEASE WAIT...", {
      incProgress(0.3, detail="working")
      
      #Creates cluster analysis using Rgraphviz
      plot(dtm, terms=findFreqTerms(dtm, lowfreq=20)[1:input$words], 
           corThreshold=0.0, attrs=list(node=list(shape = "ellipse", fixedsize = FALSE, 
                                                  fillcolor="lightblue", height="2.6", width="10.5", 
                                                  fontsize="14")))
      #Increment progress 100%
      incProgress(1, detail="complete")
    })
  })
})