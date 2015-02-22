library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(memoise)

shinyUI(fluidPage(
  
  # Application title
  headerPanel("Cluster Analysis"),
  
  # Sidebar with a slider and selection inputs
  sidebarPanel(width = 5,
               # Copy the line below to make a select box 
               # selectInput("select", label = h3("Select File"), 
              #             choices = list.files("~/Desktop/data"), 
               #            selected = head(list.files("~/Desktop/data"), 1)),
               #actionButton("update", "Change"),
               hr(),
               sliderInput("freq", 
                           "Minimum Frequency:", 
                           min = 2,  max = 20, value = 10),
               sliderInput("corThresh", 
                           "Correlation Threshold:", 
                           min = 0.0,  max = 1,  value = 0.09, step = .01),
               sliderInput("words", 
                           "Number of Words in Cluster:",
                           min = 10, max = 50, value = 20)
  ),
  
  # Display Cluster
  mainPanel(
    plotOutput("plot")
  )
))
