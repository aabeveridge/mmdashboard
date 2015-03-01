library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)

shinyServer(function(input, output, session) {
    
  output$table1 <- renderTable({
    withProgress(message="PLEASE WAIT...", {
      incProgress(0.3, detail="working")
      
      infile <- input$file1
      if (is.null(infile)) {
        return(NULL)
      }
      load(infile$datapath)
      freq <- colSums(as.matrix(dtm))
      ord <- order(freq)
      freq1 <- as.data.frame(freq[tail(ord, input$length1)])
      names(freq1) <- c("Total")
      freq1
    })
  })
  
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