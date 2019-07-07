#' A portfolio of swaps
#'
#' A table containing a sample portfolio to be used as reference when using
#' custom portfolios
#'
#' @format A tibble with 5 rows and 13 columns:
#' \describe{
#'     \item{ID}{A custom ID for the swap (either numeric or string)}
#'     \item{currency}{the currency of the swap, in ISOcode}
#'     \item{notional}{notional amount in double}
#'     \item{start.date}{start date of the swap, in dmy format}
#'     \item{maturity.date}{maturity date of the swap, in dmy format}
#'     \item{strike}{strike rate (numerico, not in percentage terms)}
#'     \item{type}{a string, either `receiver` or `payer`}
#'     \item{standard}{a logical entry, TRUE for standard swaps, FALSE otherwise}
#'     \item{time.unit.pay}{only if not standard, number of months of payer
#'     coupons' payment}
#'     \item{time.unit.receive}{only if not standard, number of months of
#'     receiver coupons' payment}
#'     \item{dcc.pay}{only if not standard, day count convention of payer leg
#'     as a string}
#'     \item{dcc.receive}{only if not standard, day count convention of receiver
#'     leg as a string}
#'     \item{calendar}{only if not standard, a string with the name of the
#'     holiday's calendar}
#' }
"swap.basket"
#' A discount factor term structure
#'
#' A table containing the discount factor term structure
#'
#' @format A tibble with 26 rows and 2 columns:
#' \describe{
#'    \item{t2m}{a day fraction representing the time to maturity of the
#'    instruments used for constructing the discount factor curve}
#'    \item{df}{the level of the discount factor for that time to maturity}
#'}
#' @source Bloomberg SWPM page as at the 15th of April 2019
"df.table"
