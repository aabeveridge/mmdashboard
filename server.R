library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)
library(zoo)
library(chron)

shinyServer(function(input, output, session) {
    
  ##This is the output for the summary tab
  ##The input for this tab are mapped from the table1 and file1 inputs
  ##from the UI page
  output$freqtable <- renderTable({
    
    ##The withProgress() function lets the user know that the
    ##system is working. There are ways to make it more
    ##complex by embedding the function in an if statement
    ##while 
    withProgress(message="PLEASE WAIT...", {
      incProgress(0.3, detail="working")
      
      ##Loading the file into shiny with the browse function
      infile <- input$filerda
      if (is.null(infile)) {
        return(NULL)
      }
      
      ##The "datapath" is where the input$file1 actually saves
      ##the loaded file in memory/temp
      load(infile$datapath)
      
      ## This creates the word frequency table on summary page
      ## Simplified sorting method that also lists words in decreasing
      ## frequency (NVH: 2015-03-25)
      freq <- data.frame(Total = sort(colSums(as.matrix(dtm)),
                             decreasing=TRUE)) 
      head(freq, input$freqsl)

    })
  })
  
  ## Hashtag frequencies
  output$hash <- renderTable({
      withProgress(message="PLEASE WAIT...", {
          incProgress(0.3, detail="working")
          infile <- input$filerda
          if (is.null(infile)) {
              return(NULL)
          }
          load(infile$datapath)
          
          ## Display result
          head(hashtags, input$freqsl)
          
      })
  }) 
  
  ### @User frequencies
  output$users <- renderTable({
      withProgress(message="PLEASE WAIT...", {
          incProgress(0.3, detail="working")
          infile <- input$filerda
          if (is.null(infile)) {
              return(NULL)
          }
          load(infile$datapath)
          
          ## Display result
          head(usernames, input$freqsl)
      })
  }) 


  ##This is the output for the Time Series tab in the UI
  ##You can change this to renderPlot or other reactive
  ##functionality depending on your output
  output$series <- renderPlot({

      infile <- input$filerda
      if (is.null(infile)) {
          return(NULL)
      }
      load(infile$datapath)

      breaks = input$series_radio

      ## Create a column for days (this could be weeks, hours, etc.). This
      ## gives a time-unit to each tweet
      ## d$day = cut(d$created, breaks = breaks)

      mindate = length(d$created) * (input$series.sl[1]/100)
      maxdate = length(d$created) - (length(d$created) * ((100 - input$series.sl[2]) / 100))

      ## Subset the data
      d = d[mindate:maxdate,]

      d$day = cut(d$created, breaks = breaks)

      ## Count number of tweets, binned by day
      tmp = sapply(levels(d$day),
          function(x) dim(d[d$day==x, ])[1]) 
      counts = as.vector(tmp)

      if (breaks == "hours") {
          days = hours(names(tmp))
          xlabel = days[seq(1, length(days), by=12)]

          ## Plot number of tweets by unit of time
          plot(1:(length(days)), counts,
               xlab= paste(toupper(substring(breaks, 1, 1)),
                   substring(breaks, 2), sep=""),
               ylab = "Number of tweets", type="o", axes=FALSE)
          ## Angled axis labels (get this working later perhaps)
          ## text(seq(1, length(days), by=12), par("usr")[3]-0.25, srt=60, adj=1,
          ##      xpd=TRUE, labels = xlabel, cex=1) 
          axis(1, at=seq(1, length(days), by=12), labels = days[seq(1,
                                                     length(days), by=12)])
          axis(2)
          box()
      } else {
          days = as.Date(names(tmp))  # as.Date from zoo library
          plot(days, counts,
               xlab= paste(toupper(substring(breaks, 1, 1)),
                   substring(breaks, 2), sep=""),
               ylab = "Number of tweets", type="o")
      }

  }) 
  
  ##Create cluster graph for Cluster Analysis tab      
  output$clust <- renderPlot({
    
    ##Call a list of attributions to change the look of the cluster graph
    defAttrs <- getDefaultAttrs()
    
    infile <- input$filerda
    if (is.null(infile)) {
      return(NULL)
    }
    load(infile$datapath)
    
    ##Provide progress bar while plot is being created
    withProgress(message="PLEASE WAIT...", {
      incProgress(0.3, detail="working")
      
      ## Creates cluster analysis using Rgraphviz (NVH:
      ## 2015-03-25. updated to include most popular terms after
      ## resizing
      plot(dtm, terms=findFreqTerms(dtm, lowfreq=input$clust.sl[1], highfreq=input$clust.sl[2]),
           corThreshold=0.0, attrs=list(node=list(shape = "ellipse", fixedsize = FALSE, 
                                                  fillcolor="lightblue", height="2.6", width="10.5", 
                                                  fontsize="14")))
      ##Increment progress 100%
      incProgress(1, detail="complete")
    })
  })

  output$corr <- renderTable({
    withProgress(message="PLEASE WAIT...", {
      incProgress(0.3, detail="working")
      
      ##Loading the file into shiny with the browse function
      infile <- input$filerda
      if (is.null(infile)) {
        return(NULL)
      }
      
      ##The "datapath" is where the input$file1 actually saves
      ##the loaded file in memory/temp
      load(infile$datapath)
      
      d <- findAssocs(dtm, input$text, corlimit=0.0)
      head(d, input$corr.sl)
    })
  })
})
