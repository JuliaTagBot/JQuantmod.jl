# JQuantmod
An easy way to get financial data based on quantmod


## Motivation

Yahoo!Finance and Google Finance were deprecated. Although in Python people have some alternatives such as [pandas-datareader](https://github.com/pydata/pandas-datareader), there is still much pain: the data sources may require you to subscribe (provide an API key), or have only a limited one year range. In R, [quantmod](https://www.quantmod.com/) is excellent: it works with fewer constraints. 

This script is an interface of `quantmod` for `julia`.

## Instruction

* Install R
* Install [quantmod](https://www.quantmod.com/) library in R
* Install `RCall` in `julia`
* Copy the two files: `JQuantmod.jl` and `sharpe.r` into your workspace
* In the `julia` code, include the file: `include("JQuantmod.jl")`

Then you have access to the following functions
* `p = get_price(symbol, start_date, end_date)` returns the price of the instrument `symbol`
* `p = get_log_return(symbol, start_date, end_date)` returns the log return of the instrument `symbol`
* `p = get_irx( start_date, end_date)` returns riskless log return 
* `p = get_sp500( start_date, end_date)` returns SP500 price

See examples in the Jupyter Notebook.

## Note

This script is so simple but fits my needs. I would be happy to extend it based on feedback. 
