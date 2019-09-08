
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SwapPricer <img src="man/figures/SwapPricerHex.png" align="right" height="149" width="128.5"/>

<!-- badges: start -->

[![Project
Status:Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/SwapPricer)](https://CRAN.R-project.org/package=SwapPricer)
[![Travis build
status](https://travis-ci.org/DavideMagno/SwapPricer.svg?branch=master)](https://travis-ci.org/DavideMagno/SwapPricer)
<!-- badges: end -->

The goal of SwapPricer is to allow you to price a book of interest rate
swaps (IRS). IRS is the most traded over the counter financial
derivative in the world and now you can easily price it in R. More
details on the financial characteristics of this contract can be found
[here](https://en.wikipedia.org/wiki/Interest_rate_swap)

Please note that as at version 1.0.1 the toolbox is able to price using
just a one-curve framework but is able to price multiple currencies (ie.
CHF, EUR, GBP, JPY and USD) and any convention in terms of coupon
frequency and day count convention.

**We are working to introduce OIS Discounting in the next releases**

## Installation

For now, you can just install the development version from
[GitHub](https://github.com/) with:

``` r
# install.packages("devtools")
devtools::install_github("DavideMagno/SwapPricer")
```

## Example

The main function of the toolbox is `SwapPortfolioPricing` which uses
just three inputs:

1)  A table with the characteristics of the swap, like the following one

<table>

<caption>

Input Portfolio

</caption>

<thead>

<tr>

<th style="text-align:left;">

ID

</th>

<th style="text-align:left;">

currency

</th>

<th style="text-align:right;">

notional

</th>

<th style="text-align:left;">

start.date

</th>

<th style="text-align:left;">

maturity.date

</th>

<th style="text-align:right;">

strike

</th>

<th style="text-align:left;">

type

</th>

<th style="text-align:left;">

standard

</th>

<th style="text-align:right;">

time.unit.pay

</th>

<th style="text-align:right;">

time.unit.receive

</th>

<th style="text-align:left;">

dcc.pay

</th>

<th style="text-align:left;">

dcc.receive

</th>

<th style="text-align:left;">

calendar

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Swap 25y

</td>

<td style="text-align:left;">

EUR

</td>

<td style="text-align:right;">

1.0e+07

</td>

<td style="text-align:left;">

19/01/2007

</td>

<td style="text-align:left;">

19/01/2032

</td>

<td style="text-align:right;">

0.0005982

</td>

<td style="text-align:left;">

receiver

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 30y

</td>

<td style="text-align:left;">

GBP

</td>

<td style="text-align:right;">

1.0e+06

</td>

<td style="text-align:left;">

24/04/2012

</td>

<td style="text-align:left;">

24/04/2042

</td>

<td style="text-align:right;">

0.0100000

</td>

<td style="text-align:left;">

payer

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 10y

</td>

<td style="text-align:left;">

USD

</td>

<td style="text-align:right;">

2.0e+06

</td>

<td style="text-align:left;">

21/02/2012

</td>

<td style="text-align:left;">

21/02/2022

</td>

<td style="text-align:right;">

0.0025000

</td>

<td style="text-align:left;">

receiver

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 2y16y

</td>

<td style="text-align:left;">

GBP

</td>

<td style="text-align:right;">

7.5e+06

</td>

<td style="text-align:left;">

14/04/2021

</td>

<td style="text-align:left;">

14/04/2037

</td>

<td style="text-align:right;">

0.0150000

</td>

<td style="text-align:left;">

receiver

</td>

<td style="text-align:left;">

TRUE

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:right;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

NA

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap non standard

</td>

<td style="text-align:left;">

EUR

</td>

<td style="text-align:right;">

1.5e+07

</td>

<td style="text-align:left;">

26/05/2014

</td>

<td style="text-align:left;">

26/05/2039

</td>

<td style="text-align:right;">

0.0200000

</td>

<td style="text-align:left;">

payer

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:left;">

act/365

</td>

<td style="text-align:left;">

act/365

</td>

<td style="text-align:left;">

TARGET

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 10y semi fixed

</td>

<td style="text-align:left;">

EUR

</td>

<td style="text-align:right;">

1.0e+07

</td>

<td style="text-align:left;">

26/05/2014

</td>

<td style="text-align:left;">

26/05/2024

</td>

<td style="text-align:right;">

0.0010000

</td>

<td style="text-align:left;">

payer

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:left;">

act/365

</td>

<td style="text-align:left;">

act/365

</td>

<td style="text-align:left;">

TARGET

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 30y quarter floating

</td>

<td style="text-align:left;">

GBP

</td>

<td style="text-align:right;">

1.0e+06

</td>

<td style="text-align:left;">

24/04/2012

</td>

<td style="text-align:left;">

24/04/2042

</td>

<td style="text-align:right;">

0.0200000

</td>

<td style="text-align:left;">

receiver

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

3

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:left;">

act/360

</td>

<td style="text-align:left;">

act/365

</td>

<td style="text-align:left;">

UnitedKingdom

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 10y irregular

</td>

<td style="text-align:left;">

USD

</td>

<td style="text-align:right;">

2.0e+06

</td>

<td style="text-align:left;">

21/02/2012

</td>

<td style="text-align:left;">

21/02/2022

</td>

<td style="text-align:right;">

0.0025000

</td>

<td style="text-align:left;">

receiver

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

6

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:left;">

act/365

</td>

<td style="text-align:left;">

act/365

</td>

<td style="text-align:left;">

TARGET

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 2y16y

</td>

<td style="text-align:left;">

EUR

</td>

<td style="text-align:right;">

7.5e+06

</td>

<td style="text-align:left;">

14/04/2021

</td>

<td style="text-align:left;">

14/04/2037

</td>

<td style="text-align:right;">

0.0150000

</td>

<td style="text-align:left;">

payer

</td>

<td style="text-align:left;">

FALSE

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:right;">

12

</td>

<td style="text-align:left;">

act/365

</td>

<td style="text-align:left;">

act/360

</td>

<td style="text-align:left;">

TARGET

</td>

</tr>

</tbody>

</table>

2)  The date at which the swaps are being priced

3)  As many interest rate lists as per the currencies in the swap
    portfolio. The list is made of a string with the code of the
    currency and a with a tibble with the discounting factor curve with
    two columns: Dates and Discount Factors (df). Here is an example of
    interest rate list:

<!-- end list -->

``` r
SwapPricer::EUR.curves
#> $currency
#> [1] "EUR"
#> 
#> $discount
#> # A tibble: 26 x 2
#>    Date          df
#>    <date>     <dbl>
#>  1 2019-04-15  1   
#>  2 2019-04-23  1.00
#>  3 2019-05-16  1.00
#>  4 2019-07-16  1.00
#>  5 2019-10-16  1.00
#>  6 2020-04-16  1.00
#>  7 2020-10-16  1.00
#>  8 2021-04-16  1.00
#>  9 2022-04-19  1.00
#> 10 2023-04-17  1.00
#> # … with 16 more rows
```

Examples of items 1 and 3 have been provided with the package.

``` r
library(SwapPricer)
today <- lubridate::ymd(20190415)
SwapPricer::SwapPortfolioPricing(SwapPricer::swap.basket, today, 
                                 SwapPricer::EUR.curves, SwapPricer::GBP.curves,
                                 SwapPricer::USD.curves) 
```

This function returns a table that can be easily used for reporting like
below

    #> Called from: OLDParSwapRateCalculation(swap.dates, swap, df.table)
    #> debug at /Users/davidemagno/Documents/R/Pricingverse/SwapPricer/R/IRS.R#137: switch(swap$type$pay, fixed = swap.dates$pay$cashflows, floating = swap.dates$receive$cashflows) %>% 
    #>     dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), 
    #>         .data$yf, ties = mean) %>% purrr::pluck("y") %>% exp) %>% 
    #>     OLDParSwapRateAlgorithm
    #> Called from: OLDParSwapRateCalculation(swap.dates, swap, df.table)
    #> debug at /Users/davidemagno/Documents/R/Pricingverse/SwapPricer/R/IRS.R#137: switch(swap$type$pay, fixed = swap.dates$pay$cashflows, floating = swap.dates$receive$cashflows) %>% 
    #>     dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), 
    #>         .data$yf, ties = mean) %>% purrr::pluck("y") %>% exp) %>% 
    #>     OLDParSwapRateAlgorithm
    #> Called from: OLDParSwapRateCalculation(swap.dates, swap, df.table)
    #> debug at /Users/davidemagno/Documents/R/Pricingverse/SwapPricer/R/IRS.R#137: switch(swap$type$pay, fixed = swap.dates$pay$cashflows, floating = swap.dates$receive$cashflows) %>% 
    #>     dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), 
    #>         .data$yf, ties = mean) %>% purrr::pluck("y") %>% exp) %>% 
    #>     OLDParSwapRateAlgorithm
    #> Called from: OLDParSwapRateCalculation(swap.dates, swap, df.table)
    #> debug at /Users/davidemagno/Documents/R/Pricingverse/SwapPricer/R/IRS.R#137: switch(swap$type$pay, fixed = swap.dates$pay$cashflows, floating = swap.dates$receive$cashflows) %>% 
    #>     dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), 
    #>         .data$yf, ties = mean) %>% purrr::pluck("y") %>% exp) %>% 
    #>     OLDParSwapRateAlgorithm
    #> Called from: OLDParSwapRateCalculation(swap.dates, swap, df.table)
    #> debug at /Users/davidemagno/Documents/R/Pricingverse/SwapPricer/R/IRS.R#137: switch(swap$type$pay, fixed = swap.dates$pay$cashflows, floating = swap.dates$receive$cashflows) %>% 
    #>     dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), 
    #>         .data$yf, ties = mean) %>% purrr::pluck("y") %>% exp) %>% 
    #>     OLDParSwapRateAlgorithm
    #> Called from: OLDParSwapRateCalculation(swap.dates, swap, df.table)
    #> debug at /Users/davidemagno/Documents/R/Pricingverse/SwapPricer/R/IRS.R#137: switch(swap$type$pay, fixed = swap.dates$pay$cashflows, floating = swap.dates$receive$cashflows) %>% 
    #>     dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), 
    #>         .data$yf, ties = mean) %>% purrr::pluck("y") %>% exp) %>% 
    #>     OLDParSwapRateAlgorithm
    #> Called from: OLDParSwapRateCalculation(swap.dates, swap, df.table)
    #> debug at /Users/davidemagno/Documents/R/Pricingverse/SwapPricer/R/IRS.R#137: switch(swap$type$pay, fixed = swap.dates$pay$cashflows, floating = swap.dates$receive$cashflows) %>% 
    #>     dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), 
    #>         .data$yf, ties = mean) %>% purrr::pluck("y") %>% exp) %>% 
    #>     OLDParSwapRateAlgorithm
    #> Called from: OLDParSwapRateCalculation(swap.dates, swap, df.table)
    #> debug at /Users/davidemagno/Documents/R/Pricingverse/SwapPricer/R/IRS.R#137: switch(swap$type$pay, fixed = swap.dates$pay$cashflows, floating = swap.dates$receive$cashflows) %>% 
    #>     dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), 
    #>         .data$yf, ties = mean) %>% purrr::pluck("y") %>% exp) %>% 
    #>     OLDParSwapRateAlgorithm
    #> Called from: OLDParSwapRateCalculation(swap.dates, swap, df.table)
    #> debug at /Users/davidemagno/Documents/R/Pricingverse/SwapPricer/R/IRS.R#137: switch(swap$type$pay, fixed = swap.dates$pay$cashflows, floating = swap.dates$receive$cashflows) %>% 
    #>     dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), 
    #>         .data$yf, ties = mean) %>% purrr::pluck("y") %>% exp) %>% 
    #>     OLDParSwapRateAlgorithm

<table class="table table-striped table-hover table-condensed table-responsive" style="margin-left: auto; margin-right: auto;">

<caption>

Pricing results

</caption>

<thead>

<tr>

<th style="text-align:left;">

swap.id

</th>

<th style="text-align:left;">

currency

</th>

<th style="text-align:right;">

clean.mv

</th>

<th style="text-align:right;">

dirty.mv

</th>

<th style="text-align:right;">

accrual.pay

</th>

<th style="text-align:right;">

accrual.receive

</th>

<th style="text-align:right;">

par

</th>

<th style="text-align:right;">

pv01

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Swap 25y

</td>

<td style="text-align:left;">

EUR

</td>

<td style="text-align:right;">

\-881,831.25

</td>

<td style="text-align:right;">

\-874,952.12

</td>

<td style="text-align:right;">

5,483.33

</td>

<td style="text-align:right;">

1,395.80

</td>

<td style="text-align:right;">

0.77%

</td>

<td style="text-align:right;">

\-12,390.87

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 30y

</td>

<td style="text-align:left;">

GBP

</td>

<td style="text-align:right;">

105,100.25

</td>

<td style="text-align:right;">

104,665.66

</td>

<td style="text-align:right;">

\-4,739.73

</td>

<td style="text-align:right;">

4,305.14

</td>

<td style="text-align:right;">

1.54%

</td>

<td style="text-align:right;">

1,948.27

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 10y

</td>

<td style="text-align:left;">

USD

</td>

<td style="text-align:right;">

\-119,333.64

</td>

<td style="text-align:right;">

\-126,360.65

</td>

<td style="text-align:right;">

\-7,777.01

</td>

<td style="text-align:right;">

750.00

</td>

<td style="text-align:right;">

2.43%

</td>

<td style="text-align:right;">

\-547.60

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 2y16y

</td>

<td style="text-align:left;">

GBP

</td>

<td style="text-align:right;">

\-94,850.43

</td>

<td style="text-align:right;">

\-94,850.43

</td>

<td style="text-align:right;">

\-0.00

</td>

<td style="text-align:right;">

0.00

</td>

<td style="text-align:right;">

1.59%

</td>

<td style="text-align:right;">

\-10,393.05

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap non standard

</td>

<td style="text-align:left;">

EUR

</td>

<td style="text-align:right;">

\-2,590,941.00

</td>

<td style="text-align:right;">

\-2,861,713.60

</td>

<td style="text-align:right;">

\-264,657.53

</td>

<td style="text-align:right;">

\-6,115.07

</td>

<td style="text-align:right;">

1.07%

</td>

<td style="text-align:right;">

27,912.93

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 10y semi fixed

</td>

<td style="text-align:left;">

EUR

</td>

<td style="text-align:right;">

\-16,313.13

</td>

<td style="text-align:right;">

\-30,006.28

</td>

<td style="text-align:right;">

\-3,835.62

</td>

<td style="text-align:right;">

\-9,857.53

</td>

<td style="text-align:right;">

0.07%

</td>

<td style="text-align:right;">

5,129.68

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 30y quarter floating

</td>

<td style="text-align:left;">

GBP

</td>

<td style="text-align:right;">

88,228.04

</td>

<td style="text-align:right;">

105,652.23

</td>

<td style="text-align:right;">

\-2,082.67

</td>

<td style="text-align:right;">

19,506.85

</td>

<td style="text-align:right;">

1.55%

</td>

<td style="text-align:right;">

\-1,940.77

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 10y irregular

</td>

<td style="text-align:left;">

USD

</td>

<td style="text-align:right;">

\-119,608.54

</td>

<td style="text-align:right;">

\-126,827.43

</td>

<td style="text-align:right;">

\-7,944.92

</td>

<td style="text-align:right;">

726.03

</td>

<td style="text-align:right;">

2.44%

</td>

<td style="text-align:right;">

\-545.92

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 2y16y

</td>

<td style="text-align:left;">

EUR

</td>

<td style="text-align:right;">

\-361,098.10

</td>

<td style="text-align:right;">

\-361,098.10

</td>

<td style="text-align:right;">

\-0.00

</td>

<td style="text-align:right;">

0.00

</td>

<td style="text-align:right;">

1.18%

</td>

<td style="text-align:right;">

11,170.90

</td>

</tr>

</tbody>

</table>

## Learning More

The vignettes are a great place to learn more about SwapPricer.

If you are installing from github and want the vignettes, you’ll need to
run the following commands
first:

``` r
devtools::install_github("DavideMagno/SwapPricer", build_vignettes = TRUE)
library(SwapPricer)
```

You can then access them from R with the `vignette()` command.
