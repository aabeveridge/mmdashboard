library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(memoise)


shinyUI(fluidPage(
  
  title = "Cluster Analysis",
  
  plotOutput('plot', width="auto", height="550px"),
  
  hr(),
  
  fluidRow(
    column(offset=1, width=5, height=1,
           sliderInput("freq", 
                       "Minimum Frequency:", 
                       min = 2,  max = 20, value = 20)),
    
    column(offset=1, width=5, height=1,
           sliderInput("words", 
                       "Number of Words in Cluster:",
                       min = 10, max = 50, value = 50))
    )
  )
)