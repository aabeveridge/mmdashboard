library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(markdown)

shinyUI(navbarPage("MassMine",
                   
                    #Main page
                    tabPanel("Welcome",
                             mainPanel(
                                      includeMarkdown("./other_files/filepage.md"))),
                    
                    #navbarMenu() function allows a tab at the top of the page
                    #to become a drop down menut
                    navbarMenu("Topic",
                  
                      #Each tabPanel() is an item on the navbarMenu()
                      tabPanel("Summary", 
                            
                              #These are the inputs for the summary page--their actual
                              #variables are the first word in quotes inside the function
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
                            
                            #This is the main output page for the Summary tab
                            mainPanel(
                                tableOutput("table1")
                            )
                      ),
                      
                      #Another item in the drop down menu--this is empty so far
                      tabPanel("Frequency",
                              dataTableOutput("table2")
                      ),
                      
                      #This one is for your time series analysis
                      tabPanel("Time Series",
                              dataTableOutput("table3")
                      ),
                      
                      #The cluster analysis
                      tabPanel("Cluster",
                             
                               #This tabsetPanel() function allows there to be separate tabs on a
                               #single selected page within the drop down menue
                               tabsetPanel(type = "tabs", 
                                           
                                           #First tab for this page
                                           tabPanel("Cluster",
                                              
                                              #The wellPanel() function allows the controls to be
                                              #vertically distributed in the same page--this allows
                                              #the cluster analysis to fill the full page width below
                                              wellPanel(
                                                sliderInput("words",
                                                            "Number of Words in Cluster",
                                                            min = 10, max = 100, value = 50)
                                                
                                              ),
                                              plotOutput("plot", width="auto", height="600px")
                                           ),
                                           
                                           #Second tab for this page. I know what I want to do with
                                           #this page, but I haven't filled it in yet
                                           tabPanel("Word Correlations", plotOutput("plot.cor"))
                    ))),
                    
                    #This is location analysis--similar to what we are doing with our Twitter publication
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
