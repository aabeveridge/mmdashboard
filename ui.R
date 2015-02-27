library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)

shinyUI(navbarPage("MassMine",
                   
                    tabPanel("Data",
                             sidebarLayout(
                                 sidebarPanel(
                                    fileInput("file1", "Select File for Analysis",
                                             accept = c(".csv"
                                             )
                                    ),
                                   
                                    actionButton("action", "Analyze Data")
                                 ),

                                mainPanel(width=7,
                                  includeMarkdown("~/massmine/dashboard/filepage.md")
                                )
                              )
                    ),
                    tabPanel("Summary",
                            dataTableOutput("table")
                    ),
                    tabPanel("Frequency",
                            dataTableOutput("table1")
                    ),
                    tabPanel("Cluster",
                            sidebarPanel("Adjust", width=2,                     
                              
                              sliderInput("freq", 
                                          "Minimum Frequency:", 
                                          min = 2,  max = 20, value = 20),
                   
                              sliderInput("words", 
                                          "# of Words in Cluster",
                                          min = 10, max = 50, value = 50)
                            ),
                            
                            mainPanel(width=10,
                            
                              plotOutput("plot")
                            )
                    ),
                    tabPanel("Export",
                            dataTableOutput("table2")
                    ),
                    tabPanel("Help",
                            
                            navlistPanel("Help", widths=c(3, 3, 3),
                              
                              #List of options/pages for the navigation panel           
                              tabPanel("Overview",
                                       h3(width=7,
                                         includeMarkdown("~/massmine/dashboard/help.md"))     
                              ),
                              tabPanel("Data Selection",
                                       h3("This is the third panel")
                              ),
                              tabPanel("Data Summary",
                                       h3("This is the second panel")
                              ),
                              tabPanel("Frequency Analysis",
                                       h3("This is the third panel")
                              ),         
                              tabPanel("Cluster Analysis",
                                       h3("This is the third panel")
                              ),
                              tabPanel("Research Export",
                                       h3("This is the third panel")
                              )
                            )
                      )
        )
)