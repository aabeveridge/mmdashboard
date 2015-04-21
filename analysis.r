#########################################
#  Analysis Script for the MassMine GUI 
#########################################

library(tm)
library(gsubfn)
library(stringr)
library(SnowballC)

## Function for preprocessing data
process_data <- function(twitfile) {
  
  ## Pull in the Twitter data
  d <- read.csv(twitfile, header=TRUE, sep=",", stringsAsFactors = FALSE)
  
  ## For use with Twitter data with incomplete string errors
  ## data <- read.csv("~/Desktop/twitterdata.csv", quote = "",
  ## row.names=NULL, stringsAsFactors = FALSE)
  
  d <- d$text
  d <- as.character(d)
  d <- iconv(d, "", "UTF-8")

  #Make entire corpus lower case
  d <- tolower(d)
  
  #Remove stop words
  d <- removeWords(d, stopwords("english")) 
  
  #Separate URLs into separate list, and then remove them from corpus
  d.url <- strapply(d, "http://[^ ]+", empty="")
  d <- str_replace_all(d, "http://[^ ]+", "")

  #Separate usernames into separate list, and then remove them from corpus
  d.user <- strapply(d, "@[[:alnum:]][[:alnum:]_]+", empty="")
  
  d <- str_replace_all(d, "@[[:alnum:]][[:alnum:]_]+", "")
  
  #Separate hashtags into separate list, and then remove them from corpus
  d.hash <- strapply(d, "#[[:alnum:]][[:alnum:]_]+", empty="")
  
  d <- str_replace_all(d, "#[[:alnum:]][[:alnum:]_]+", "")
  
  ## Remove other words
  other.words <- c("rt", "na", "s", "2015", "2014", "er", "em", "http", "idk", "amp")
  d <- removeWords(d, other.words)
  
  ## Remove punctuation
  d <- removePunctuation(d)
  
  ## Strip additional white space
  d <- stripWhitespace(d)
  
  ## Document stemming and stem completion
  d1 <- d
  d <- wordStem(d, language="english")
  d <- stemCompletion(d, d1)
  d <- as.vector(d)
  
  #Recombine all data back into a vector
  d.url <- as.character(d.url)
  d.user <- as.character(d.user)
  d.hash <- as.character(d.hash)
  d <- str_c(d, d.url, d.user, d.hash, sep=" ", collapse=NULL)
  d <- as.vector(d)
  
  ## Change corpus variable into vector source corpus accoding to TM
  d <- VCorpus(VectorSource(d))
  
  ## Create the Document Term Matrix
  dtm <- DocumentTermMatrix(d)
  
  save(list=c("dtm", "d"), file="mmdashboard.rda")
}