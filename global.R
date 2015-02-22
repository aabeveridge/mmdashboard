##########################################
# Create Corpus from Tweet texts, clean, #
# and create a Document Term Matrix      #
##########################################

library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)
library(memoise)

#################################################################################
# notes:
# Create basic data overview function for students, create tables that display
# the length of time for their data collection, total number of tweets, etc.
#################################################################################

#Function for creating Document Term Matrix
dtm <- function(twitfile) {
  
  # Pull in the Twitter data
  data <- read.csv(twitfile)
  
  #For use with Twitter data with incomplete string errors
  #data <- read.csv("~/Desktop/twitterdata.csv", quote = "", 
  #                 row.names=NULL, stringsAsFactors = FALSE)
  
  # Create corpus variable from the $text vector
  corpus1 <- data$text
  
  # Set all characters to UTF-8
  corpus1 = iconv(corpus1, "", "UTF-8")
  
  # Make all letters lower case
  corpus1 <- tolower(corpus1)
  
  # Remove stop words
  corpus1 <- removeWords(corpus1, stopwords(kind="en"))
  
  # Remove colons -- additional punctuation causing problems
  corpus1 = str_replace_all(corpus1, "[:.,!]", "")
  
  # Remove and save URLs
  #http <- unique(unlist(str_extract_all(corpus1, "http://[^ ]+ ")
  corpus1 <- str_replace_all(corpus1, "http://[^ ]+ ", " ")
  
  # Creates unique list of hashtags and usernames
  #usrhash = unique(unlist(str_extract_all(corpus1, "[#|@][[:alpha:]][[:alnum:]_]+ ")))
  
  # Removes and dummy codes hashtags and usernames
  #for (i in 1:(length(corpus1))) {
  #  for (j in 1:(length(usrhash))) {
  #    corpus1[i] = gsub(usrhash[j], paste("c", j, " ", sep=""), corpus1[i])
  #  }
  #}
  
  #Remove other words
  other.words <- c("rt", "na", "s", "2015", "2014", "er", "em", "http")
  corpus1 <- removeWords(corpus1, other.words)
  
  #Remove punctuation
  corpus1 <- removePunctuation(corpus1)
  
  #Strip additional white space
  corpus1 <- stripWhitespace(corpus1)
  
  # Document stemming and stem completion
  corpus2 <- corpus1
  corpus1 <- wordStem(corpus1, language="english")
  corpus1 <- stemCompletion(corpus1, corpus2)
  corpus1 <- as.vector(corpus1)
  
  # Change corpus variable into vetor source corpus accoding to TM
  corpus1 <- VCorpus(VectorSource(corpus1))
  
  # Create the Document Term Matrix
  dtm <- DocumentTermMatrix(corpus1)
  
  # for (i in 1:(length(dtm$dimnames$Terms))) {
  #  if (substring(dtm$dimnames$Terms[i], 1, 1) == "c" &
  #        !is.na(as.numeric(substring(dtm$dimnames$Terms[i], 2)))) {   
  #    dtm$dimnames$Terms[i] = usrhash[as.numeric(substring(dtm$dimnames$Terms[i], 2))]
  #  }  
  # }
}

#Plot cluster analysis
# cluster.graph <- function(x, wordassoc) {
#   
#   # Remove sparse terms--the percentage used here           
#   # changes the rest of the results because making it 100%  
#   # removes all terms. As the percentage lowers, more terms 
#   # are included for analysis                               
#   dtms <- removeSparseTerms(x, 0.90)
# 
#   # Summarize the total number of each term remaining
#   # after removing the sparse terms
#   freq <- colSums(as.matrix(dtms))
# 
#   # Set the low frequecy threshold--this is the total number 
#   # of times a term repeats throughout the corpus
#   findFreqTerms(x, lowfreq=2)
# 
#   # Set the correlation limit for determining the correlations in the final visual
#   findAssocs(x, wordassoc, corlimit=0.075)
#   
#   # Calls for a list of allowable graph changes in Rgraphviz
#   defAttrs <- getDefaultAttrs()
# 
#   # Plot the correlations
#   plot(x, terms=findFreqTerms(x, lowfreq=15)[1:40], corThreshold=0.009, 
#        main=wordassoc, attrs=list(node=list(shape = "box", fixedsize = FALSE, 
#                                                      fillcolor="lightblue", fontsize="30")
#                                            ) 
#        )
# }