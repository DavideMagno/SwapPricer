
<!-- README.md is generated from README.Rmd. Please edit that file -->

# SwapPricer

<!-- badges: start -->

[![Project
Status:Active](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)

<!-- badges: end -->

The goal of SwapPricer is to allow you to price a book of interest rate
swaps (IRS). IRS is the most traded over the counter financial
derivative in the world and now you can easily price it in R. More
details can be found
[here](https://en.wikipedia.org/wiki/Interest_rate_swap)

## Installation

<!-- You can install the released version of SwapPricer from [CRAN](https://CRAN.R-project.org) with: -->

<!-- ``` r -->

<!-- install.packages("SwapPricer") -->

<!-- ``` -->

You can for now just install the development version from
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
#>   swap.id  clean.mv  dirty.mv accrual.pay accrual.receive      par    pv01
#>   <chr>       <dbl>     <dbl>       <dbl>           <dbl>    <dbl>   <dbl>
#> 1 1        -881815.  -874994.       5441.           1379.  0.00771 -12394.
#> 2 2         233692.   124000.     -97222.         -12470   0.0111   20867.
#> 3 3         222083.   236147.       6702.           7361. -0.00138  -5724.
#> 4 4         360095.   360095.          0               0   0.0118  -11163.
#> 5 5       -2588829. -2867345.    -263836.         -14681.  0.0107   27914.
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

1

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

2

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

3

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

4

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

5

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
