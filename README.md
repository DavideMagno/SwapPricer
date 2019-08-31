
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

Please note that as at version 0.2.0 the toolbox is able to price using
just a one-curve framework but is able to price multiple currencies (ie.
CHF, EUR, GBP, JPY and USD) and any convention in terms of coupon
frequency, day count convention and holiday calendar.

**We are working to introduce all these issues in the next releases**

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

1)  A table with the characteristics of the swap

2)  The date at which the swaps are being priced

3)  A table with the discounting factor curve

Examples of items 1 and 3 have been provided with the package.

``` r
today <- lubridate::ymd(20190414)
library(SwapPricer)
#> Registered S3 method overwritten by 'xts':
#>   method     from
#>   as.zoo.xts zoo
SwapPricer::SwapPortfolioPricing(SwapPricer::swap.basket, today, 
                                 SwapPricer::EUR.curves, SwapPricer::GBP.curves,
                                 SwapPricer::USD.curves) 
#> # A tibble: 9 x 8
#>   swap.id currency clean.mv dirty.mv accrual.pay accrual.receive     par
#>   <chr>   <chr>       <dbl>    <dbl>       <dbl>           <dbl>   <dbl>
#> 1 Swap 2… EUR       -8.82e5  -8.75e5       5441.           1379. 7.71e-3
#> 2 Swap 3… GBP        1.05e5   1.05e5      -4712.           4280. 1.54e-2
#> 3 Swap 1… USD       -1.19e5  -1.26e5      -7630.            736. 2.43e-2
#> 4 Swap 2… GBP       -9.46e4  -9.46e4          0               0  1.59e-2
#> 5 Swap n… EUR       -2.59e6  -2.86e6    -263836.          -5988. 1.07e-2
#> 6 Swap 1… EUR       -1.63e4  -2.99e4      -3808.          -9787. 6.82e-4
#> 7 Swap 3… GBP        8.84e4   1.06e5      -2057.          19452. 1.54e-2
#> 8 Swap 1… USD       -1.19e5  -1.27e5      -7795.            712. 2.44e-2
#> 9 Swap 2… EUR       -3.61e5  -3.61e5          0               0  1.18e-2
#> # … with 1 more variable: pv01 <dbl>
```

This function returns a table that can be easily used for reporting like
below

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

\-881,814.61

</td>

<td style="text-align:right;">

\-874,994.32

</td>

<td style="text-align:right;">

5,441.11

</td>

<td style="text-align:right;">

1,379.18

</td>

<td style="text-align:right;">

0.77%

</td>

<td style="text-align:right;">

\-12,393.65

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

104,984.18

</td>

<td style="text-align:right;">

104,552.11

</td>

<td style="text-align:right;">

\-4,712.33

</td>

<td style="text-align:right;">

4,280.26

</td>

<td style="text-align:right;">

1.54%

</td>

<td style="text-align:right;">

1,948.79

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

\-119,319.23

</td>

<td style="text-align:right;">

\-126,213.40

</td>

<td style="text-align:right;">

\-7,630.28

</td>

<td style="text-align:right;">

736.11

</td>

<td style="text-align:right;">

2.43%

</td>

<td style="text-align:right;">

\-548.15

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

\-94,592.58

</td>

<td style="text-align:right;">

\-94,592.58

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

\-10,394.43

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

\-2,591,763.24

</td>

<td style="text-align:right;">

\-2,861,586.52

</td>

<td style="text-align:right;">

\-263,835.62

</td>

<td style="text-align:right;">

\-5,987.67

</td>

<td style="text-align:right;">

1.07%

</td>

<td style="text-align:right;">

27,917.04

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

\-16,340.53

</td>

<td style="text-align:right;">

\-29,935.87

</td>

<td style="text-align:right;">

\-3,808.22

</td>

<td style="text-align:right;">

\-9,787.12

</td>

<td style="text-align:right;">

0.07%

</td>

<td style="text-align:right;">

5,132.42

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

88,396.87

</td>

<td style="text-align:right;">

105,791.96

</td>

<td style="text-align:right;">

\-2,056.96

</td>

<td style="text-align:right;">

19,452.05

</td>

<td style="text-align:right;">

1.54%

</td>

<td style="text-align:right;">

\-1,941.30

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

\-119,490.54

</td>

<td style="text-align:right;">

\-126,573.22

</td>

<td style="text-align:right;">

\-7,795.01

</td>

<td style="text-align:right;">

712.33

</td>

<td style="text-align:right;">

2.44%

</td>

<td style="text-align:right;">

\-545.96

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
