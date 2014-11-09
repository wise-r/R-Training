source("R/grab_main.R")

## CFFEX Starts From 2010-04-16
grab_main(exchange = "cffex", st.date = "2010-01-01", end.date = "2014-10-10")

## SHFE Starts From 2002-01-04
grab_main(exchange = "shfe", st.date = "2001-01-01", end.date = "2014-10-10")

## DCE Starts From 2000-05-08
grab_main(exchange = "dce", st.date = "2000-01-01", end.date = "2014-10-10")

## CZCE Starts From 2010-01-04
grab_main(exchange = "czce", st.date = "2008-01-01", end.date = "2014-10-10")

# grab_today()



