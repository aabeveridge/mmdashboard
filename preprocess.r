library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)

## Function for creating Document Term Matrix
dtm <- function(twitfile) {
  ## Pull in the Twitter data
  d <- read.csv(twitfile, header=TRUE, sep=",", stringsAsFactors = FALSE)
  ## For use with Twitter data with incomplete string errors
  ## data <- read.csv("~/Desktop/twitterdata.csv", quote = "",
  ## row.names=NULL, stringsAsFactors = FALSE)
  ## Set all characters to UTF-8
  corpus1 = iconv(d$text, "", "UTF-8")
  ## Make all letters lower case
  corpus1 <- tolower(corpus1)
  ## Remove stop words
  corpus1 <- removeWords(corpus1, stopwords(kind="en"))
  ## Remove colons -- additional punctuation causing problems
  corpus1 = str_replace_all(corpus1, "[:.,!]", "")
  ## Remove and save URLs
  ##http <- unique(unlist(str_extract_all(corpus1, "http://[^ ]+ ")
  corpus1 <- str_replace_all(corpus1, "http://[^ ]+ ", " ")
  ## Creates unique list of hashtags and usernames
  usrhash = unique(unlist(str_extract_all(corpus1,
                                          "[#|@][[:alpha:]][[:alnum:]_]+ ")))
  ## We don't want extra whitespace in the usrhash. This regexp
  ## removes leading and trailing whitespace
  usrhash = gsub("^\\s+|\\s+$", "", usrhash)
  ## Removes and dummy codes hashtags and usernames
  for (i in 1:(length(corpus1))) {
    for (j in 1:(length(usrhash))) {
      corpus1[i] = gsub(usrhash[j], paste("c", j, " ", sep=""), corpus1[i])
    }
  }
  ## Remove other words
  other.words <- c("rt", "na", "s", "2015", "2014", "er", "em", "http")
  corpus1 <- removeWords(corpus1, other.words)
  ## Remove punctuation
  corpus1 <- removePunctuation(corpus1)
  ## Strip additional white space
  corpus1 <- stripWhitespace(corpus1)
  ## Document stemming and stem completion
  corpus2 <- corpus1
  corpus1 <- wordStem(corpus1, language="english")
  corpus1 <- stemCompletion(corpus1, corpus2)
  corpus1 <- as.vector(corpus1)
  ## Change corpus variable into vector source corpus accoding to TM
  corpus1 <- VCorpus(VectorSource(corpus1))
  ## Create the Document Term Matrix
  dtm <- DocumentTermMatrix(corpus1)
  ## Substitute the original hashtags and @usernames back into the dtm
  for (i in 1:(length(dtm$dimnames$Terms))) {
    if (substring(dtm$dimnames$Terms[i], 1, 1) == "c" &
          !is.na(as.numeric(substring(dtm$dimnames$Terms[i], 2)))) {
      dtm$dimnames$Terms[i] = usrhash[as.numeric(substring(dtm$dimnames$Terms[i], 2))]
    }
  }
  save(dtm, file="mmdashboard.rda")
}