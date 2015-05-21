# Date: 2015-05-21
# Author: Erika Salomon
# Email: ecsalomon@gmail.com
# Purpose: Returns a vector of PubMed IDs for a given journal in a given year
# Packages used: XML, RSelenium
# Licence: CC BY-SA-NC

# Parameters:
# journal : A string of the exact journal title
# year : The publication year desired
# maxResults : The maximum number of results to return; defaults to 1000
# browser : the browser to use for obtaining PMIDs; options are "firefox", 
#           "chrome", "safari", "internet explorer", and "opera"; 
#           defaults to "firefox"

pullPMIDs <- function(journal, year, maxResults=1000, browser=c("firefox", 
                                                                "chrome", 
                                                                "safari",
                                                                "internet explorer", 
                                                                "opera") {
  ### Load packages ###
  suppressPackageStartupMessages(require(XML))
  suppressPackageStartupMessages(require(RSelenium))
  
  ### Start Selenium browser ###
  capture.output(RSelenium::checkForServer())
  capture.output(RSelenium::startServer())
  capture.output(remDr <- RSelenium::remoteDriver(browserName = browser))
  capture.output(remDr$open())
  
  ### Build the URI ###
  uri <- paste('http://eutils.ncbi.nlm.nih.gov/entrez/eutils/esearch.fcgi?db=pubmed&term=%22', 
               journal, '%22[Journal]+AND+', year, '[pdat]&retmax=', 
               maxResults, sep="")
  
  ### Get PubMed IDs ### 
  remDr$navigate(uri)
  pageSource <- remDr$getPageSource(header = TRUE)
  pageXML <- xmlTreeParse(pageSource, asText=TRUE)
  pageRoot <- xmlRoot(pageXML)  
  # count <- as.integer(xmlValue(pageRoot[[1]]))
  idList <- xmlChildren(pageRoot[[4]])
  ids <- as.integer(sapply(idList, xmlValue))
  
  ### Close Selenium Browser ###
  remDr$close()
  
  ### Return List of IDs ###
  return(ids)
}


  
  