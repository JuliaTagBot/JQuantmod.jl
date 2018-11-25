library(quantmod)


get_irx_ratio <- function(from ,to){
    IRX = getSymbols("^IRX", from = from, to=to, 
            auto.assign=FALSE)
    IRX_Adj_Close = data.frame(IRX)$IRX.Adjust
    IRX_Annual_Return = (IRX_Adj_Close/100)[2:length(IRX_Adj_Close)]
    IRX_Annual_Log_Return = log(1+IRX_Annual_Return)
    IRX_Daily_Log_Return = IRX_Annual_Log_Return/252
    IRX_Daily_Log_Return
}

get_price <- function(s, to, from){
    INSTR = getSymbols(paste("^",s,sep=""), from = from, to=to, 
            auto.assign=FALSE)
    cmd = sprintf("data.frame(INSTR)$%s.Adjusted", s)
    INSTR_Adj_Close=eval(parse(text=cmd))
    
    INSTR_Adj_Close
}

get_price2 <- function(s, to, from){
    INSTR = getSymbols(s, from = from, to=to, 
            auto.assign=FALSE)
    cmd = sprintf("data.frame(INSTR)$%s.Adjusted", s)
    INSTR_Adj_Close=eval(parse(text=cmd))
    
    INSTR_Adj_Close
}