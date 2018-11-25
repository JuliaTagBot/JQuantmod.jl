__precompile__()

module Jquantmod

export get_price, get_irx, get_sp500, get_log_return, get_log_return_sp500, get_log_irx

using RCall
using Printf

function init()
    R"""source('sharpe.r')"""
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
