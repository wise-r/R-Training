library(plyr)
library(dplyr)
library(pipeR)

source("R/grab_funs.R")

## Example
# exchange <- "shfe"
# st.date <- "2014-01-01"
# end.date <- "2014-02-01"

grab_main <- function(exchange, st.date, end.date){
  
  dates <- seq(from=as.Date(st.date), to=as.Date(end.date), by=1) %>>%
    stringr::str_replace_all( pattern="-", replacement="")
  
  message( paste0("Grab Date Start From ", st.date, ", Ends At ", end.date) )
  
  conn <- dbConnect(SQLite(), "dbGrab/dbGrab.sqlite")
  message( "Data Base Connected" )
  
  log <- ldply(dates, .fun=function(date){
    
    data <- do.call(paste0(exchange, "_grab"), list(date) )
    if( data != "Not a Trading Day." ) {     
      dbWriteTable(conn, exchange, data, append=TRUE) 
      return( c(date=as.numeric(date), nrow=nrow(data)) )      
    } else {      
      return( c(date=as.numeric(date), nrow=NA) )     
    }
    
  })
    
  dbDisconnect(conn)
  message( paste0( sum(na.omit(log$nrow)), " lines of data has been written out.") )
  message( "Database Disconnected." )
  
  write.csv(log, paste0("dbGrab/", exchange, "_log.csv") )
  message( paste0(nrow(log), " lines of log has been written out."))
  message( "Done.")
  
  return(TRUE)
}








