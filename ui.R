library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)

shinyUI(navbarPage("MassMine",
                   
                    #Main page
                    tabPanel("Load Data",
                             sidebarPanel(
                                          fileInput("filerda", "Load File",
                                                    multiple=FALSE, accept = c(".rda"
                                                    ))),
                             mainPanel(
                                      includeMarkdown("./other_files/filepage.md"))),
                    
                  
                    #Summary panel
                    tabPanel("Summary", 
                            
                            #These are the inputs for the summary page--their actual
                            #variables are the first word in quotes inside the function
                            sidebarPanel(
                                         sliderInput("freqsl",
                                                     "Display Most Frequent Words",
                                                     min = 10, max = 100, value = 10)
                            ),
                            
                            #This is the main output page for the Summary tab
                            mainPanel(
                                tableOutput("freqtable") #,
#                                 tableOutput("hash"),
#                                 tableOutput("user")
                            )
                      ),
                      
                      #This one is for your time series analysis
#                       tabPanel("Time Series",
#                               dataTableOutput("")
#                       ),
                      
                      #The cluster analysis
                      tabPanel("Cluster",
                                              
                              #The wellPanel() function allows the controls to be
                              #vertically distributed in the same page--this allows
                              #the cluster analysis to fill the full page width below
                              wellPanel(
                                        sliderInput("clust.sl",
                                                    "Number of Words in Cluster",
                                                    min = 10, max = 100, value = 50)
                                                
                                                    ),
                                        plotOutput("clust", width="auto", height="600px")
                                        ),
                                           
                      #Second tab for this page. I know what I want to do with
                      #this page, but I haven't filled it in yet
                      tabPanel("Correlation",
                               sidebarPanel(
                                            sliderInput("corr.sl", "Length of List",
                                                        min=10, max=100, value=20),
                                            textInput("text", "Text:", "text here")),
                               mainPanel("Word Correlations",
                               tableOutput("corr"))
                      )
                    )

        )
