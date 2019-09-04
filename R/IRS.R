AdvanceDate <- function(dates, currency, eom.check) {
  holiday <- holidays[[currency]]
  check <- TRUE %in% ((dates %in% holiday) |
                        (weekdays(dates) %in% "Saturday") |
                        (weekdays(dates) %in% "Sunday"))
  if (check) {
    repeat {
      if (eom.check) {
        dates <- dplyr::case_when((dates %in% holiday) ~ dates - 1,
                                      (weekdays(dates) %in% "Saturday") ~ dates - 1,
                                      (weekdays(dates) %in% "Sunday") ~ dates - 2,
                                      TRUE ~ dates)
      } else {
        dates <- dplyr::case_when((dates %in% holiday) ~ dates + 1,
                                      (weekdays(dates) %in% "Saturday") ~ dates + 2,
                                      (weekdays(dates) %in% "Sunday") ~ dates + 1,
                                      TRUE ~ dates)
      }
      check <- TRUE %in% ((dates %in% holiday) |
                            (weekdays(dates) %in% "Saturday") |
                            (weekdays(dates) %in% "Sunday"))
      if (!check) {
        return(dates)
      }
    }
  } else {
    return(dates)
  }
}


#' A function that calculates the main set of dates for a given leg of the
#' contract
#'
#' This function calculates the following set of dates (then converted into year
#' fractions from the valuation date if needed): 1) future cashflows 2) starting
#' date of the current accrual period 3) the fixing date for the variable rate
#'
#' @param today The Date at which the analysis is being carried out
#' @param start.date The settlement date of the contract
#' @param maturity.date The maturity date of the contract
#' @param type Type of leg (ie. floating or fixed)
#' @param time.unit Number of months for the frequency of the leg (ie. monthly
#' would have a time.unit of 1, quarterly of 3, semiannual of 6 and annual of 12)
#' @param dcc Day Count Convention as per the RQuantLib doc
#' @param calendar Character with the holiday's calendar as per the RQuantLib doc
#' @param currency The ISO code of the swap's currency
#'
#' @return A list which contains 1) future cashflows 2) starting date
#' of the current accrual period 3) the fixing date for the variable rate
#'
#' @importFrom lubridate ceiling_date days year %m+%
#' @importFrom stringr str_detect
#' @importFrom fmdates year_frac
#' @importFrom tibble tibble
#'

#' @export
CashflowCalculation  <- function(today, start.date, maturity.date, type,
                                     time.unit, dcc, calendar, currency) {
  eom.check <- (lubridate::ceiling_date(start.date, "month") - lubridate::days(1)) == start.date
  s <- lubridate::year(start.date)
  m <- lubridate::year(maturity.date)

  months.forward <- ((seq_len((m - s) * (12/time.unit) + 1) - 1) * time.unit)
  cashflows <- (start.date %m+% months(months.forward, abbreviate = TRUE)) %>%
    AdvanceDate(currency, eom.check)

  if (start.date < today) cashflows <- c(cashflows, today)

  accrual.date <- cashflows[today - cashflows > 0]

  if (!identical(as.double(accrual.date), double(0))) {
    accrual.date  %<>%  max()
    if (stringr::str_detect(type, "floating")) {
      lag <- swap.standard.calendar[
        grepl(currency,  swap.standard.calendar$currency),][["lag"]]
      fixing.date <- AdvanceDate(accrual.date - lag, currency, TRUE)
    } else {
      fixing.date <- NULL
    }
    accrual.yf <- -fmdates::year_frac(today, accrual.date, dcc)
  } else {
    fixing.date <- NULL
    accrual.yf <- 0
  }

  cashflows <- fmdates::year_frac(today, cashflows, dcc)
  cashflows <- sort(cashflows[cashflows >= 0])
  cashflows <- tibble::tibble(yf = cashflows)

  return(list(cashflows = cashflows, accrual.yf = accrual.yf,
              fixing.date = fixing.date))
}

#' Calculates the Par Swap Rate and Annuity
#'
#' Calculates the Par Swap Rate and Annuity using  the old "one curve"
#' construction methodology
#'
#' @param swap.cf A 2 column swap cashflow tibble with coupon dates (in terms of
#' year fractions) and discount factors
#'
#' @return A list containing the par swap rate and the annuity
OLDParSwapRateAlgorithm <- function(swap.cf){

  num <- (swap.cf$df[1] - swap.cf$df[dim(swap.cf)[1]])
  annuity <- (sum(diff(swap.cf$yf)*swap.cf$df[2:dim(swap.cf)[1]]))
  return(list(swap.rate = num/annuity,
              annuity = annuity))
}

#' A function that prepares the data for the swap rate and annuity calculation
#'
#' This function in particular selects the leg that is paying fixed as the old
#' calculation methodology considers the discount factor curve and the forward
#' curve to be the same. This makes the floating leg always pricing at par. It
#' then interpolates the discount factor over the cashflow dates using the log
#' linear interpolation methodology.
#'
#' @param swap.dates A list of lists with the main cashflow information for
#' both the legs
#' @param swap A list with the swap's charachteristics
#' @param df.table A tibble with the discount factor curve information
#'
#' @return A list containing the par swap rate and the annuity
#'
#' @importFrom dplyr mutate
#' @importFrom purrr pluck
#' @importFrom stats approx
#'
#' @export


OLDParSwapRateCalculation <- function(swap.dates, swap, df.table) {
  browser()
  switch(swap$type$pay,
         "fixed" = swap.dates$pay$cashflows,
         "floating" = swap.dates$receive$cashflows) %>%
    dplyr::mutate(df = stats::approx(df.table$t2m, log(df.table$df), .data$yf,
                                     ties = mean) %>%
                    purrr::pluck("y") %>%
                    exp) %>%
    OLDParSwapRateAlgorithm
}

#' A function that calculates the accrual amounts for each leg
#'
#' This function calculates the accrual for each leg by also downloading the
#' floating leg paramater using the Quandl package and datafeed. Currently the
#' function considers only EUR contracts on 6 months floating leg
#'
#' @param swap.dates A list of lists with the main cashflow information for
#' both the legs
#' @param leg.type A char that describes whether the leg is payer or
#' receiver
#' @param swap A list with the swap's charachteristics
#' @param direction A parameter that gets a value of 1 for receiver swaps and -1
#' for payer swaps
#' @param floating.history A table downloaded automatically from Quandl with the
#' historical floating rates
#'
#' @return The accrual amount
#'
#' @importFrom purrr pluck
AccrualCalculation <- function(swap.dates, leg.type, swap, direction,
                             floating.history) {
  if (!is.null(swap.dates$fixing.date)) {
    floating.history <- floating.history[
      grepl(swap$currency, floating.history$currency) &
        floating.history$time.unit == swap$time.unit[[leg.type]], "rate.data"]
    floating.history <- purrr::flatten(floating.history$rate.data)[[1]]

    fixing.row <- floating.history[floating.history$date %in%
                                     swap.dates$fixing.date,]

    if (nrow(fixing.row) == 0) {
      closest.dates <- (floating.history$date - swap.dates$fixing.date)
      fixing.row <- floating.history[
        which(closest.dates == max(closest.dates[closest.dates < 0])),]
    }

    rate <- fixing.row[["value"]]/100

  } else {
    rate <- swap$strike
  }

  swap.dates %>%
    purrr::pluck("accrual.yf") %>%
    `*`(swap$notional * rate * switch(leg.type, "pay" = -1, "receive" = 1))
}

#' A function that calculates the main characteristics of the contract
#'
#' This function calculates the market value, accruals and PV01. At the moment
#' it only prices swaps using a "one curve" methodology which is the old way of
#' pricing this type of contracts
#'
#' @param swap.dates A list of lists with the main cashflow information for
#' both the legs
#' @param today The Date at which the analysis is being carried out
#' @param swap A list that contains the contract information
#' @param floating.history A df with the historical data downloaded from Quandl
#' @param curves A list of curve sets (which are also lists which have to contain
#' a currency and a discount curve as specified in the vignette intro).
#'
#' @return A list with all the main pricing information for the contract
#'
#' @importFrom purrr map flatten map2
#' @importFrom dplyr case_when mutate select arrange
#' @importFrom data.table as.data.table
#' @importFrom tibble as_tibble
#'
#' @export
SwapPricing <- function(swap.dates, swap, today, floating.history, curves) {
  dcc <- dplyr::case_when(
    grepl("fixed", swap$type$pay) ~ swap$dcc$pay,
    grepl("fixed", swap$type$receive) ~ swap$dcc$receive
  )

  df.table <- curves$discount[[swap$currency]] %>%
    as.data.table
  df.table <- df.table[ ,c(dcc, "df"), with = FALSE] %>%
    as_tibble %>%
    purrr::set_names(c("t2m", "df"))

  swap.par.pricing <- OLDParSwapRateCalculation(swap.dates, swap, df.table)
  direction <- switch(swap$type$pay, "fixed" = 1, "floating" = -1)

  mv <- swap$notional * swap.par.pricing$annuity *
    (swap.par.pricing$swap.rate - swap$strike) * direction

  accrual <- purrr::map2(swap.dates, names(swap$type),
                         ~AccrualCalculation(.x, .y, swap, direction,
                                           floating.history))

  pv01 <- swap$notional/10000 * swap.par.pricing$annuity * direction

  list(currency = swap$currency, clean.mv = mv,
       dirty.mv = mv + accrual$pay + accrual$receive, accrual.pay = accrual$pay,
       accrual.receive = accrual$receive, par = swap.par.pricing$swap.rate,
       pv01 = pv01)
}

#' Main function that manages the pricing of one interest rate swap
#'
#' This function connects the cashflow generation to the swap pricing
#'
#' @param today The Date at which the analysis is being carried out
#' @param swap A list with the swap's charachteristics
#'
#' @return A list with all the main pricing information for the contract
#'
#' @importFrom purrr pmap
SwapCashFlowCalculation <- function(today, swap) {
  purrr::pmap(list(x = swap$type, y = swap$time.unit, z = swap$dcc),
              ~CashflowCalculation(today, swap$start.date,
                                       swap$maturity.date, ..1, ..2, ..3,
                                       swap$calendar, swap$currency))
}


#' Main function that manages the pricing of a portfolio of interest rate swap
#'
#' This function prices an entire portfolio of interest rate swaps. They can be
#' introduced either in tabular form or directly under the list structure.
#'
#' @param today The Date at which the analysis is being carried out
#' @param swap.portfolio A portfolio of swap contracts. Please refer to the
#' vignette "Define the input data structures" for more details on how to
#' create it
#' @param ... One curve sets (which are also lists which have to contain
#' a currency and a discount curve as specified in the vignette intro) for each
#' currency in the swap.portfolio.
#'
#' @return A list with all the main pricing information for the contract
#'
#' @importFrom dplyr mutate_at mutate select everything
#' @importFrom lubridate dmy
#' @importFrom purrr pmap map map_df set_names map_depth compact flatten
#' @importFrom tibble is_tibble
#' @importFrom tidyr replace_na
#' @importFrom Quandl Quandl
#'
#' @export
SwapPortfolioPricing <- function(swap.portfolio, today, ...) {

  # Manage swap portfolio

  if (tibble::is_tibble(swap.portfolio)) {
    swap.portfolio %<>%
      dplyr::mutate_at(.vars = dplyr::vars(.data$start.date,
                                           .data$maturity.date),
                       .funs = lubridate::dmy) %>%
      purrr::pmap(list) %>%
      purrr::set_names(swap.portfolio$ID) %>%
      purrr::map(SwapPortfolioFormatting)
  }

  # Manage curves

  curves <- purrr::set_names(list(...), purrr::map(list(...), "currency")) %>%
    CalculateCurvesDCC(swap.portfolio, today)

  # Manage cashflows

  cashflows <- swap.portfolio %>%
    purrr::map(~SwapCashFlowCalculation(today, .x))

  floating.history <- VariableRateDownload(swap.portfolio, cashflows, today)

  # Pricing

  purrr::map2_df(cashflows, swap.portfolio,
                 ~SwapPricing(.x, .y, today, floating.history, curves)) %>%
    dplyr::mutate(swap.id = names(swap.portfolio)) %>%
    dplyr::select(.data$swap.id, dplyr::everything())
}
