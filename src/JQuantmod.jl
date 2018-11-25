__precompile__()

module JQuantmod

export get_price, get_irx, get_sp500, get_log_return, get_log_return_sp500, get_log_irx

using RCall
using Printf

function init()
    R"""
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
"""
end

"""
    get_log_return(s::String, from::String, to::String)

    Return the daily log price for symbol `s` from `from` to `to`
"""
function get_log_return(s::String, from::String, to::String)
    init()
    p = get_price(s, from, to)
    return log.(p[2:end])-log.(p[1:end-1])
end

"""
    get_price(s::String, from::String, to::String)

    Return the daily price for symbol `s` from `from` to `to`
"""
function get_price(s::String, from::String, to::String)
    init()
    if s[1]=='^'
        s = (s[2:end])
        reval(@sprintf("r = get_price('%s',from='%s',to='%s')", s, from, to))
    else
        reval(@sprintf("r = get_price2('%s',from='%s',to='%s')", s, from, to))
    end
    @rget r
    r
end

"""
    get_log_irx(from::String, to::String)

    Return the daily risk-free log return from `from` to `to`
"""
function get_log_irx(from::String, to::String)
    init()
    reval(@sprintf("r = get_irx_ratio('%s','%s')", from, to))
    @rget r
    r
end

"""
    get_irx(from::String, to::String)

    Return the daily risk-free return from `from` to `to`
"""
function get_irx(from::String, to::String)
    init()
    r = get_log_irx(from, to)
    return exp.(r) .- 1
end

"""
    get_sp500(from::String, to::String)

    Return the daily return for S&P500 from `from` to `to`
"""
function get_sp500(from::String, to::String)
    init()
    return get_price("^GSPC", from, to)
end

"""
    get_log_return_sp500(from::String, to::String)

    Return the daily log return for S&P500 from `from` to `to`
"""
function get_log_return_sp500(from::String, to::String)
    init()
    return get_log_return("^GSPC", from, to)
end
end
