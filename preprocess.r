library(tm)
library(SnowballC)
library(Rgraphviz)
library(stringr)

## Helper function, taken from qdap package. This allows for matching
## and replacement of multiple regexps. Otherwise, it functions as
## gsub 
mgsub <- function (pattern, replacement, text.var, leadspace = FALSE, 
                   trailspace = FALSE, fixed = TRUE, trim = TRUE, order.pattern = fixed, 
                   ...) {

    if (leadspace | trailspace) replacement <- spaste(replacement, trailing = trailspace, leading = leadspace)

    if (fixed && order.pattern) {
        ord <- rev(order(nchar(pattern)))
        pattern <- pattern[ord]
        if (length(replacement) != 1) replacement <- replacement[ord]
    }
    if (length(replacement) == 1) replacement <- rep(replacement, length(pattern))
    
    for (i in seq_along(pattern)){
        text.var <- gsub(pattern[i], replacement[i], text.var, fixed = fixed, ...)
    }

    if (trim) text.var <- gsub("\\s+", " ", gsub("^\\s+|\\s+$", "", text.var, perl=TRUE), perl=TRUE)
    text.var
}

## Optimized processing of 1000 tweets
## Current best time:
##   user  system elapsed 
##  3.717   0.087   3.530
##
## Of the above time, the following amount is taken up by
## stemCompletion alone:
##   user  system elapsed 
##  2.123   0.000   2.104

## This is an improvement over the previous version, which, for the
## same 1000 tweets, took:
##    user  system elapsed 
##   8.712   0.050   8.688 

process_data <- function(twitfile, doStemCompletion = TRUE) {
    ## Pull in the Twitter data
    d <- read.csv(twitfile, header=TRUE, sep=",", stringsAsFactors = FALSE)

    ## ##################################################################
    ## Create a dtm structure
    ## ##################################################################

    ## Set all characters to UTF-8
    corpus1 = iconv(d$text, "", "UTF-8")

    ## Make all letters lower case
    corpus1 <- tolower(corpus1)
    ## Remove stop words
    corpus1 <- removeWords(corpus1, stopwords(kind="en"))
    ## Remove and save URLs
    ##http <- unique(unlist(str_extract_all(corpus1, "http://[^ ]+ ")
    corpus1 <- str_replace_all(corpus1, "(http|https)([^/]+).*", " ")
    ## Remove colons and additional punctuation causing problems
    corpus1 <- str_replace_all(corpus1, "\\|", " ")
    corpus1 <- str_replace_all(corpus1, "[:.,!]", "")

    ## Creates unique list of hashtags and usernames
    usrhash = unique(unlist(str_extract_all(corpus1,
        "[#|@][[:alpha:]][[:alnum:]_]+ ")))
    ## We don't want extra whitespace in the usrhash. This regexp
    ## removes leading and trailing whitespace
    usrhash = gsub("^\\s+|\\s+$", "", usrhash)
    ## Removes and dummy codes hashtags and usernames
    codes = sapply(1:(length(usrhash)), 
        function (x) paste("c", x, " ", sep=""))
    corpus1 <- multigsub(usrhash, subs, corpus1)

    ## Remove other words
    ## other.words <- c("rt", "na", "s", "2015", "2014", "er", "em", "http")
    ## corpus1 <- removeWords(corpus1, other.words)

    ## Remove punctuation
    corpus1 <- removePunctuation(corpus1)
    ## Strip additional white space
    corpus1 <- stripWhitespace(corpus1)
    ## Document stemming and stem completion
    corpus2 <- corpus1
    corpus1 <- wordStem(corpus1, language="english")

    ## Stem completion takes a lot of time. The user can optionally
    ## skip this step.
    if (doStemCompletion) {
        corpus1 <- stemCompletion(corpus1, corpus2)
    } 

    corpus1 <- as.vector(corpus1)
    ## Change corpus variable into vector source corpus accoding to TM
    corpus1 <- VCorpus(VectorSource(corpus1))
    ## Create the Document Term Matrix
    dtm <- DocumentTermMatrix(corpus1)
    ## Substitute the original hashtags and @usernames back into the dtm
    suppressWarnings(
        for (i in 1:(length(dtm$dimnames$Terms))) {
            if (substring(dtm$dimnames$Terms[i], 1, 1) == "c" &
                !is.na(as.numeric(substring(dtm$dimnames$Terms[i], 2)))) {
                dtm$dimnames$Terms[i] = usrhash[as.numeric(substring(dtm$dimnames$Terms[i], 2))]
            }
        })

    ## ##################################################################
    ## Hashtag frequencies
    ## ##################################################################

    ## This retrieves the indices of hashtags
    raw_hashtags = unlist(str_extract_all(iconv(d$text, to="UTF-8"),
        "#[[:alnum:]][[:alnum:]_]+ "))

    ## Number of occurences for each hashtag
    hashtags = as.data.frame(sort(table(raw_hashtags),
        decreasing=TRUE))
    ## Add name for pretty printed in dashboard
    names(hashtags) = c("Frequency")

    ## ##################################################################
    ## Username frequencies
    ## ##################################################################

    ## This retrieves the indices of @usernames
    raw_usernames = unlist(str_extract_all(iconv(d$text, to="UTF-8"),
        "@[[:alnum:]][[:alnum:]_]+ "))

    ## Number of occurences for each username
    usernames = as.data.frame(sort(table(raw_usernames),
        decreasing=TRUE))
    names(usernames) = c("Frequency")

    ## ##################################################################
    ## Time series preparations
    ## ##################################################################

    ## Turn timestamp data into internally-recognized timestamp data
    ## type in R
    d$created = as.POSIXct(d$created)

    ## ##################################################################
    ## Finish up
    ## ##################################################################

    ## We save the relevant data structures:
    ## dtm       : for cluster and word frequency 
    ## hashtags  : sorted hashtag frequencies
    ## usernames : sorted @username frequencies
    ## d         : full data for time series (consider replacing)
    save(list=c("dtm", "hashtags", "usernames", "d"), file="mmdashboard.rda")
} ## End of function process_data



