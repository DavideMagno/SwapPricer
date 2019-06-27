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
#'
#' @return A list which contains 1) future cashflows 2) starting date
#' of the current accrual period 3) the fixing date for the variable rate
#'
#'
#' @importFrom lubridate year as_date
#' @importFrom purrr map_dbl
#' @importFrom RQuantLib advance yearFraction
#' @importFrom stringr str_detect
#' @importFrom tibble tibble
#' @importFrom dplyr filter
#' @importFrom magrittr "%>%" "%<>%"
#'
#' @export
SwapCashflowCalculation  <- function(today, start.date, maturity.date, type,
                                     time.unit, dcc, calendar) {
  s <- lubridate::year(start.date)
  m <- lubridate::year(maturity.date)
  cashflows <- ((seq_len((m - s) * (12/time.unit) + 1) - 1) * time.unit)
  cashflows <- purrr::map_dbl(cashflows, ~RQuantLib::advance(calendar = calendar,
                                       dates = start.date,
                                       n = .x,
                                       timeUnit = 2,
                                       bdc = 1,
                                       emr = TRUE))
  cashflows <- lubridate::as_date(cashflows) %>%
    {if (start.date < today) append(today, .) else .}

  accrual.date <- cashflows[today - cashflows > 0]

  if (!identical(as.double(accrual.date), double(0))) {
    accrual.date  %<>%  max()
    if (stringr::str_detect(type, "floating")) {
      fixing.date <- accrual.date %>%
        {RQuantLib::advance(calendar = calendar,
                            dates = .,
                            n = -2,
                            timeUnit = 0,
                            bdc = 1,
                            emr = TRUE)}
    } else {
      fixing.date <- NULL
    }
    accrual.yf <- accrual.date %>%
      {RQuantLib::yearFraction(today, ., dcc)} %>%
      `*`(-1)
  } else {
    fixing.date <- NULL
    accrual.yf <- 0
  }

  cashflows %<>%
    purrr::map_dbl(~RQuantLib::yearFraction(today, .x, dcc)) %>%
    tibble::tibble(yf = .) %>%
    dplyr::filter(yf >= 0)

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
#'
#' @export
OLDParSwapRate <- function(swap.cf){

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
#' @param swap A list with the swap's carachteristics
#' @param df.table A tibble with the discount factor curve information
#'
#' @return A list containing the par swap rate and the annuity
#'
#' @importFrom dplyr mutate
#' @importFrom purrr pluck
OLDParSwapRateCalculation <- function(swap.dates, swap, df.table) {

  switch(swap$type$pay,
         "fixed" = swap.dates$pay$cashflows,
         "floating" = swap.dates$receive$cashflows) %>%
    dplyr::mutate(df = approx(df.table$t2m, log(df.table$df), .$yf) %>%
                    purrr::pluck("y") %>%
                    exp) %>%
    OLDParSwapRate
}

#' A function that calculates the accrual amounts for each leg
#'
#' This function calculates the accrual for each leg by also downloading the
#' floating leg paramater using the Quandl package and datafeed. Currently the
#' function considers only EUR contracts on 6 months floating leg
#'
#' @param swap.dates A list of lists with the main cashflow information for
#' both the legs
#' @param leg.type A charachter that describes whether the leg is payer or
#' receiver
#' @param swap A list with the swap's carachteristics
#' @param direction A parameter that gets a value of 1 for receiver swaps and -1
#' for payer swaps
#'
#' @return The accrual amount
#'
#' @importFrom dplyr filter select
#' @importFrom purrr pluck
#' @importFrom Quandl Quandl
#' @importFrom tibble as_tibble
#'
#' @export
CalculateAccrual <- function(swap.dates, leg.type, swap, direction,
                             floating.history) {

  if (!is.null(swap.dates$fixing.date)) {

    rate <- floating.history %>%
      dplyr::filter(Date == swap.dates$fixing.date) %>%
      dplyr::select(Value) %>%
      as.double %>%
      `/`(100)
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
#' @param swap A list that contains the contract information
#' @param df.table A tibble with the discount factor curve information
#' @param floating.history A df with the historical data downloaded from Quandl
#'
#' @return A list with all the main pricing information for the contract
#'
#' @importFrom purrr map
#'
#' @export
SwapCalculations <- function(swap.dates, swap, df.table, floating.history) {
  swap.par.pricing <- OLDParSwapRateCalculation(swap.dates, swap, df.table)

  direction <- switch(swap$type$pay, "fixed" = 1, "floating" = -1)

  mv <- swap$notional * swap.par.pricing$annuity *
    (swap.par.pricing$swap.rate - swap$strike) * direction

  accrual <- purrr::map2(swap.dates, names(swap$type),
                         ~CalculateAccrual(.x, .y, swap, direction,
                                           floating.history))

  pv01 <- swap$notional/10000 * swap.par.pricing$annuity * direction

  list(clean.mv = mv, accrual.pay = accrual$pay,
       accrual.receive = accrual$receive, par = swap.par.pricing$swap.rate,
       pv01 = pv01)
}

#' Main function that manages the pricing of one interest rate swap
#'
#' This function connects the cashflow generation to the swap pricing
#'
#' @param today The Date at which the analysis is being carried out
#' @param swap A list with the swap's carachteristics
#' @param df.table A tibble with the discount factor curve information
#'
#' @return A list with all the main pricing information for the contract
#'
#' @importFrom purrr pmap
#'
#' @export
CashFlowPricing <- function(today, swap, df.table) {
  purrr::pmap(list(x = swap$type, y = swap$time.unit, z = swap$dcc),
              ~SwapCashflowCalculation(today, swap$start.date,
                                       swap$maturity.date, ..1, ..2, ..3,
                                       swap$calendar))
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
#' @param df.table A tibble with the discount factor curve information. Please
#' refer to the vignette "Define the input data structures" for more details on
#' how to create it
#'
#' @return A list with all the main pricing information for the contract
#'
#' @importFrom dplyr mutate_at mutate select everything
#' @importFrom lubridate dmy
#' @importFrom purrr pmap map map_df set_names map_depth compact
#' @importFrom tibble is_tibble
#' @importFrom anytime anydate
#'
#' @export
SwapPortfolioPricing <- function(swap.portfolio, today, df.table) {

  if (tibble::is_tibble(swap.portfolio)) {
    swap.portfolio %<>%
      dplyr::mutate_at(.vars = dplyr::vars(start.date, maturity.date),
                       .funs = lubridate::ymd) %>%
      purrr::pmap(list) %>%
      purrr::set_names(purrr::map(., "ID")) %>%
      purrr::map(SwapPortfolioFormatting)
  }
  cashflows <- swap.portfolio %>%
    purrr::map(~CashFlowPricing(today, .x, df.table))

  # cashflows %>%
  #   purrr::map_depth(2, "fixing.date") %>%
  #   purrr::map(purrr::compact) %>%
  #   purrr::flatten(.) %>%
  #   {do.call("c", .)} %>%
  #   unname %>%
  #   {Quandl::Quandl("BOF/QS_D_IEUTIO6M",
  #                   start_date = min(.),
  #                   end_date = max(.))} %>%
  #   tibble::as_tibble(.) %>%
  #   {purrr::pmap_df(list(x = cashflows, y = swap.portfolio,
  #                        z = rep(list(.),length(cashflows))),
  #                   ~SwapCalculations(..1, ..2, df.table, ..3))} %>%
  #   dplyr::mutate(swap.id = names(swap.portfolio)) %>%
  #   dplyr::select(swap.id, dplyr::everything())
}
