# install.packages(c("jsonlite", "XML"))
# devtools::install_github("jeroenooms/jsonlite")

library(dplyr)
library(pipeR)
library(RSQLite)
library(httr)

shfe_grab <- function(date){
  dt.source <- paste0("http://www.shfe.com.cn/data/dailydata/kx/kx", date, ".dat")
  text <- content(GET(dt.source), as = "text", encoding = "UTF-8")
  
  first.char <- substr(text, 1, 1)
  if( first.char != "{" ) substr(text, 1, 1) <- " "
  
  data <- try( jsonlite::fromJSON(text)$o_curinstrument, silent=TRUE )
  if( nrow(data) == 1 || class(data) == "try-error" ) {
    return("Not a Trading Day.")
  } else{
    data <- filter(data, "小计" != data$DELIVERYMONTH & "" != data$DELIVERYMONTH)
    names(data) <- tolower(names(data))  
    data <- transform(data, productid=stringr::str_trim(productid),
                      productname=stringr::str_trim(productname),
                      openprice=as.numeric(openprice),
                      highestprice=as.numeric(highestprice),
                      lowestprice=as.numeric(lowestprice),
                      closeprice=as.numeric(closeprice),
                      date=date)
    
    return(data)
  }
}

to.numeric <- function(x){
  '[<-'(x, x=="-", NA)
  return(as.numeric(x))
}

dce_grab <- function(date){
  data <- paste0("http://www.dce.com.cn/PublicWeb/MainServlet?action=Pu00012_download&Pu00011_Input.trade_date=", date, "&Pu00011_Input.variety=all&Pu00011_Input.trade_type=0&Submit2=%CF%C2%D4%D8%CE%C4%B1%BE%B8%F1%CA%BD") %>>%
    readLines()
  
  if(data[1] == "") { return("Not a Trading Day.") 
  } else {
    data <- data[5:length(data)]
    data.split <- strsplit(data,"\\s+")
    data <- suppressWarnings(data.frame( do.call(rbind, data.split),stringsAsFactors=FALSE ))
    data <- filter(data, is.na( stringr::str_extract(as.character(X1), "小计") ) ) %>>% 
      filter( as.character(X1) != "总计" ) 
    names(data) <- c("ProductName", "DeliveryMonth", "Open", "High", "Low", "Close",
                     "PreSettlementPrice", "SettlementPrice", "WinLoss", "WinLoss1",
                     "Volume", "OpenInterest", "DiffOpenInterest", "Amount")
    data <- suppressWarnings( 
      transform(data, Open=to.numeric(Open), High=to.numeric(High), 
                Low=to.numeric(Low), Close=to.numeric(Close),
                Date=date)
    )
    
    return(data)
  }
}

czce_grab <- function(date){
  dt.source <- paste0("http://www.czce.com.cn/portal/exchange/", substr(date, 1, 4),  
                      "/datadaily/", date, ".txt")  
   
  data <- suppressWarnings( try( 
    read.csv(dt.source, skip=1, header=FALSE, sep=",", stringsAsFactors=FALSE), 
    silent = TRUE) )
  
  if( inherits(data, "try-error") == TRUE ) {
    return("Not a Trading Day.")
  } else {
    data <- filter(data, V1 != "小计" & V1 != "总计")
    names(data) <- c("IntrumentID", "PreSettlementPrice", 
                     "Open", "High", "Low", "Close", "WinLoss", 
                     "BuyHigh", "SellLow", "Volume", "OpenInterest", 
                     "SettlementPrice", "BuyVolume", "SellVolume")
    data <- transform(data, Date=date)
    return(data)
  }
}

cffex_grab <- function(date){
  dt.source <- paste0("http://www.cffex.com.cn/fzjy/mrhq/", 
                      substr(date, 1, 6), "/", substr(date, 7, 8), "/index.xml")
  xml <- suppressWarnings( try( XML::xmlParse(dt.source,isURL = TRUE, ), silent=TRUE ) )
  if( inherits(xml, "try-error") == TRUE ){
    return("Not a Trading Day.")
  } else {
    data <- XML::xmlToDataFrame(xml,stringsAsFactors = FALSE)
    data <- transform(data, instrumentid = stringr::str_trim(instrumentid),
                      productid = stringr::str_trim(productid), date=date)
    
    return(data)
  }
}

all_grab <- function(dates){
  
  conn <- dbConnect(SQLite(), "dbGrab/dbGrab.sqlite")
  
    for( date in dates ){
      czce <- czce_grab(date)
      if( czce != "Not a Trading Day." ) dbWriteTable(conn, "CZCE", czce, append=TRUE)

      cffex <- cffex_grab(date)
      if( cffex != "Not a Trading Day." ) dbWriteTable(conn, "CFFEX", cffex, append=TRUE)

      shfe <- shfe_grab(date)
      if( shfe != "Not a Trading Day." ) dbWriteTable(conn, "SHFE", shfe, append=TRUE)  

      dce <- dce_grab(date)
      if( dce != "Not a Trading Day." ) dbWriteTable(conn, "DCE", dce, append=TRUE)
    }
  
  dbDisconnect(conn)
  
}

today_grab <- function(){
  
  date <- Sys.Date() %>>%
    stringr::str_replace_all( pattern="-", replacement="")
  
  conn <- dbConnect(SQLite(), "dbGrab/dbGrab.sqlite")
  
    czce <- czce_grab(date)
    if( czce != "Not a Trading Day." ) dbWriteTable(conn, "CZCE", czce, append=TRUE)
    
    cffex <- cffex_grab(date)
    if( cffex != "Not a Trading Day." ) dbWriteTable(conn, "CFFEX", cffex, append=TRUE)
    
    shfe <- shfe_grab(date)
    if( shfe != "Not a Trading Day." ) dbWriteTable(conn, "SHFE", shfe, append=TRUE)  
    
    dce <- dce_grab(date)
    if( dce != "Not a Trading Day." ) dbWriteTable(conn, "DCE", dce, append=TRUE)
  
  dbDisconnect(conn)
  
}

## DCE: 商品名称 交割月份     开盘价     最高价     最低价     收盘价   前结算价     结算价       
## 涨跌      涨跌1        成交量        持仓量     持仓量变化             成交额  

## CZXE: 合约   昨结算   今开盘 	最高价 	最低价 	最新价 	涨跌 	最高买 	最低卖 	成交量(手) 	
## 持仓量 	今结算 	买盘量 	卖盘量


