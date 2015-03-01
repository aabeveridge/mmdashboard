library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)

shinyUI(navbarPage("MassMine",
                    tabPanel("Welcome",
                             mainPanel(
                                      includeMarkdown("./other_files/filepage.md"))),
                    navbarMenu("Topic",
                      tabPanel("Summary", 
                            sidebarPanel("Additional Adjustments",
                                         fileInput("file1", "Select File for Analysis",
                                                   multiple=FALSE, accept = c(".rda"
                                                   )),                               
                                         sliderInput("sparse", 
                                                     "Remove Sparse Words",
                                                     min = 0.01, max = .1, value = 0.05, step=.01),
                                         sliderInput("length1",
                                                     "Display Most Frequent Words",
                                                     min = 10, max = 100, value = 10)
                            ),
                            mainPanel(
#                               column(4,
                                tableOutput("table1")
#                               column(4,
#                                 tableOutput("table2"))
                            )
                      ),
                      tabPanel("Frequency",
                              dataTableOutput("table2")
                      ),
                      tabPanel("Cluster",
                             
                            wellPanel(
                               sliderInput("words",
                                           "Number of Words in Cluster",
                                           min = 10, max = 100, value = 50)
                             ),                           
                            plotOutput("plot", width="auto", height="600px")
                             
                        )),
                    navbarMenu("Location",
                              tabPanel("Data"),
                              tabPanel("Summary"),
                              tabPanel("Map"),
                              tabPanel("Analysis")),
                               
                    tabPanel("Help",
                          mainPanel(
                              includeMarkdown("./other_files/help.md")))
)

        )
