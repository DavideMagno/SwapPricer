
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SwapPricer <img src="man/figures/SwapPricerHex.png" align="right" height="149" width="128.5"/>

<!-- badges: start -->

[![Project
Status:Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![CRAN\_Status\_Badge](https://www.r-pkg.org/badges/version/SwapPricer)](https://CRAN.R-project.org/package=SwapPricer)

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
SwapPricer::SwapPortfolioPricing(SwapPricer::swap.basket, today, 
                                 SwapPricer::EUR.curves, SwapPricer::GBP.curves,
                                 SwapPricer::USD.curves) 
#> # A tibble: 9 x 8
#>   swap.id currency clean.mv dirty.mv accrual.pay accrual.receive      par
#>   <chr>   <chr>       <dbl>    <dbl>       <dbl>           <dbl>    <dbl>
#> 1 Swap 2… EUR       -8.82e5  -8.75e5       5441.           1379.  7.71e-3
#> 2 Swap 3… GBP        2.28e5   2.24e5     -47123.          42820.  1.11e-2
#> 3 Swap 1… USD        2.22e5   1.53e5     -76303.           7361. -1.38e-3
#> 4 Swap 2… GBP        3.65e5   3.65e5          0               0   1.17e-2
#> 5 Swap n… EUR       -2.59e6  -2.86e6    -263836.          -5988.  1.07e-2
#> 6 Swap 1… EUR       -1.60e4  -2.96e4      -3808.          -9787.  6.88e-4
#> 7 Swap 3… GBP        1.85e6   2.03e6     -20550.         194521.  1.11e-2
#> 8 Swap 1… USD        2.22e5   1.52e5     -77950.           7123. -1.38e-3
#> 9 Swap 2… EUR       -3.60e5  -3.60e5          0               0   1.18e-2
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

228,431.26

</td>

<td style="text-align:right;">

224,128.43

</td>

<td style="text-align:right;">

\-47,123.29

</td>

<td style="text-align:right;">

42,820.46

</td>

<td style="text-align:right;">

1.11%

</td>

<td style="text-align:right;">

20,937.20

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

222,182.33

</td>

<td style="text-align:right;">

153,240.66

</td>

<td style="text-align:right;">

\-76,302.78

</td>

<td style="text-align:right;">

7,361.11

</td>

<td style="text-align:right;">

\-0.14%

</td>

<td style="text-align:right;">

\-5,728.51

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

364,537.92

</td>

<td style="text-align:right;">

364,537.92

</td>

<td style="text-align:right;">

\-0.00

</td>

<td style="text-align:right;">

0.00

</td>

<td style="text-align:right;">

1.17%

</td>

<td style="text-align:right;">

\-11,202.52

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

\-2,588,828.67

</td>

<td style="text-align:right;">

\-2,858,651.96

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

27,914.07

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

\-15,988.79

</td>

<td style="text-align:right;">

\-29,584.13

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

5,132.39

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

1,853,676.17

</td>

<td style="text-align:right;">

2,027,646.72

</td>

<td style="text-align:right;">

\-20,550.00

</td>

<td style="text-align:right;">

194,520.55

</td>

<td style="text-align:right;">

1.11%

</td>

<td style="text-align:right;">

\-20,879.14

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

222,451.38

</td>

<td style="text-align:right;">

151,624.53

</td>

<td style="text-align:right;">

\-77,950.14

</td>

<td style="text-align:right;">

7,123.29

</td>

<td style="text-align:right;">

\-0.14%

</td>

<td style="text-align:right;">

\-5,739.49

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

\-359,616.46

</td>

<td style="text-align:right;">

\-359,616.46

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

11,169.71

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
