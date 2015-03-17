library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)

shinyServer(function(input, output, session) {
    
  #This is the output for the summary tab
  #The input for this tab are mapped from the table1 and file1 inputs
  #from the UI page
  output$freqtable <- renderTable({
    
    #The withProgress() function lets the user know that the
    #system is working. There are ways to make it more
    #complex by embedding the function in an if statement
    #while 
    withProgress(message="PLEASE WAIT...", {
      incProgress(0.3, detail="working")
      
      #Loading the file into shiny with the browse function
      infile <- input$filerda
      if (is.null(infile)) {
        return(NULL)
      }
      
      #The "datapath" is where the input$file1 actually saves
      #the loaded file in memory/temp
      load(infile$datapath)
      
      #This creates the word frequency table on summary page
      freq <- colSums(as.matrix(dtm))
      ord <- order(freq)
      freq1 <- as.data.frame(freq[tail(ord, input$freqsl)])
      names(freq1) <- c("Total")
      freq1
    })
  })
  
  #This doesn't work yet, and I don't remember what I was making...lol
#   output$table.hash <- renderTable({
#     withProgress(message="PLEASE WAIT...", {
#       incProgress(0.3, detail="working")
#       infile <- input$filerda
#       if (is.null(infile)) {
#         return(NULL)
#       }
#       load(infile$datapath)
#       
#       ## Let's dig the hashtags out of the dtm
#       
#       head(d$text)
#       ## This retrieves the indices of hashtags
#       raw_hashtags = unlist(str_extract_all(d$text,
#                                             "#[[:alpha:]][[:alnum:]_]+ "))
#       ## Number of occurences for each hashtag
#       hashtags = as.data.frame(sort(table(raw_hashtags),
#                                  decreasing=TRUE))
#       names(hashtags) = c("Total")
#       
#       ## Display result
#       hashtags
#       
#     })
#   }) 
  
  #This is the output for the Time Series tab in the UI
  #You can change this to renderPlot or other reactive
  #functionality depending on your output
#   output$series <- renderTable({
#   }) 
  
  #Create cluster graph for Cluster Analysis tab      
  output$clust <- renderPlot({
    
    #Call a list of attributions to change the look of the cluster graph
    defAttrs <- getDefaultAttrs()
    
    infile <- input$filerda
    if (is.null(infile)) {
      return(NULL)
    }
    load(infile$datapath)
    
    #Provide progress bar while plot is being created
    withProgress(message="PLEASE WAIT...", {
      incProgress(0.3, detail="working")
      
      #Creates cluster analysis using Rgraphviz
      plot(dtm, terms=findFreqTerms(dtm, lowfreq=20)[1:input$clust.sl], 
           corThreshold=0.0, attrs=list(node=list(shape = "ellipse", fixedsize = FALSE, 
                                                  fillcolor="lightblue", height="2.6", width="10.5", 
                                                  fontsize="14")))
      #Increment progress 100%
      incProgress(1, detail="complete")
    })
  })

  output$corr <- renderTable({
    withProgress(message="PLEASE WAIT...", {
      incProgress(0.3, detail="working")
      
      #Loading the file into shiny with the browse function
      infile <- input$filerda
      if (is.null(infile)) {
        return(NULL)
      }
      
      #The "datapath" is where the input$file1 actually saves
      #the loaded file in memory/temp
      load(infile$datapath)
      
      d <- findAssocs(dtm, input$text, corlimit=0.0)
      head(d, input$corr.sl)
    })
  })
})