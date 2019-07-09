
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

Please note that as at version 0.1.0 the toolbox is able to price:

1)  EUR swaps that pay semi-annually on the floating leg

2)  Using a one-curve framework

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
library(SwapPricer)
SwapPortfolioPricing(SwapPricer::swap.basket, lubridate::ymd(20190414), SwapPricer::df.table)
#> # A tibble: 5 x 7
#>   swap.id    clean.mv dirty.mv accrual.pay accrual.receive      par    pv01
#>   <chr>         <dbl>    <dbl>       <dbl>           <dbl>    <dbl>   <dbl>
#> 1 Swap 25y    -8.82e5  -8.75e5       5441.           1379.  0.00771 -12394.
#> 2 Swap 30y     2.34e5   1.24e5     -97222.         -12470   0.0111   20867.
#> 3 Swap 10y     2.22e5   2.36e5       6702.           7361. -0.00138  -5724.
#> 4 Swap 2y16y   3.60e5   3.60e5          0               0   0.0118  -11163.
#> 5 Swap non …  -2.59e6  -2.87e6    -263836.         -14681.  0.0107   27914.
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

<td style="text-align:right;">

233,691.75

</td>

<td style="text-align:right;">

123,999.52

</td>

<td style="text-align:right;">

\-97,222.22

</td>

<td style="text-align:right;">

\-12,470.00

</td>

<td style="text-align:right;">

1.11%

</td>

<td style="text-align:right;">

20,867.00

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 10y

</td>

<td style="text-align:right;">

222,083.28

</td>

<td style="text-align:right;">

236,146.61

</td>

<td style="text-align:right;">

6,702.22

</td>

<td style="text-align:right;">

7,361.11

</td>

<td style="text-align:right;">

\-0.14%

</td>

<td style="text-align:right;">

\-5,724.42

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap 2y16y

</td>

<td style="text-align:right;">

360,095.21

</td>

<td style="text-align:right;">

360,095.21

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

\-11,163.37

</td>

</tr>

<tr>

<td style="text-align:left;">

Swap non standard

</td>

<td style="text-align:right;">

\-2,588,828.67

</td>

<td style="text-align:right;">

\-2,867,344.97

</td>

<td style="text-align:right;">

\-263,835.62

</td>

<td style="text-align:right;">

\-14,680.68

</td>

<td style="text-align:right;">

1.07%

</td>

<td style="text-align:right;">

27,914.07

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
