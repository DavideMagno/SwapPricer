#' Formatting the swap table
#'
#' This function converts a tabular input into the relevant lists
#'
#' @param swap.tabular a list which includes the user defined characteristics
#' of a swap contract
#'
#' @return a formatted version of the contract that is readable by the functions
#' in the toolbox
#'
#' @importFrom purrr discard
#' @importFrom stringr str_detect str_sub
SwapPortfolioFormatting <- function(swap.tabular) {
  swap.tabular %<>%
    purrr::discard(is.na)

  test <- stringr::str_sub(swap.tabular$type,1,1)
  if (grepl("P|p", test)) {
    swap.tabular$type <- list(pay = "fixed", receive = "floating")
  } else if (grepl("R|r", test)) {
    swap.tabular$type <- list(pay = "floating", receive = "fixed")
  }

  if (swap.tabular$standard == TRUE) {
    swap.tabular %<>%
      ApplyStandardConventions(test)
  } else {
    swap.tabular$time.unit <- list(pay = swap.tabular$time.unit.pay,
                                   receive = swap.tabular$time.unit.receive)
    swap.tabular$dcc <- list(pay = swap.tabular$dcc.pay,
                             receive = swap.tabular$dcc.receive)
  }

  if (grepl("P|p", test)) {
    swap.tabular$floating.freq <- swap.tabular$time.unit$receive
  } else if (grepl("R|r", test)) {
    swap.tabular$floating.freq <- swap.tabular$time.unit$pay
  }

  swap.tabular %<>%
    purrr::discard(stringr::str_detect(swap.tabular %>% names,
                                       "pay|receive|standard|ID") == TRUE)
}


#' Helper function to format standard swaps
#'
#' This function calls other helper functions to format a swap list from the
#' tabular version to the target one
#'
#' @param swap.tabular a list which includes the user defined characteristics
#' of a swap contract
#' @param test a character (`r` or `p`) representing if the swap if receiver or
#' payer
#'
#' @return a formatted version of the contract that is readable by the functions
#' in the toolbox
ApplyStandardConventions <- function(swap.tabular, test) {

  swap.standard <- swap.standard[grepl(swap.tabular$currency,
                                       swap.standard$currency),]

  if (nrow(swap.standard) == 0) {
    stop(paste0("The toolbox currently doesn't model swaps denominated in ",
                swap.tabular$currency), call. = FALSE)
  }

  swap.tabular$time.unit <- swap.tabular %>%
    GetStandardList("time.unit", test, swap.standard)

  swap.tabular$dcc <- swap.tabular %>%
    GetStandardList("dcc", test, swap.standard)

  swap.tabular$calendar <-
    swap.standard.calendar[grepl(swap.tabular$currency,
                                 swap.standard.calendar$currency),][["calendar"]]

  return(swap.tabular)
}

#' Helper function to format standard swaps
#'
#' This function calls other helper functions to format a swap list from the
#' tabular version to the target one
#'
#' @param swap.tabular a list which includes the user defined characteristics
#' of a swap contract
#' @param variable the contract feature that is being converted
#' @param test a character (`r` or `p`) representing if the swap if receiver or
#' payer
#' @param swap.standard an internal data.table filtered for the currency of the
#' swap
#'
#' @return a list of standard characteristics for both the legs
GetStandardList <- function(swap.tabular, variable, test, swap.standard) {

  if (grepl("R|r", test)) {
    convention <-
      list(pay = swap.standard[grepl("floating", swap.standard$leg),][[variable]],
           receive = swap.standard[grepl("fixed",swap.standard$leg),][[variable]])
  } else {
    convention <-
      list(pay = swap.standard[grepl("fixed", swap.standard$leg),][[variable]],
           receive = swap.standard[grepl("floating", swap.standard$leg),][[variable]])
    }
  return(convention)
}


#' @importFrom purrr flatten
ExtractFromList <- function(swap.portfolio, item) {
  swap.portfolio %>%
    purrr::map(purrr::pluck(item)) %>%
    flatten %>%
    purrr::reduce(c)
}

CalculateCurvesDCC <- function(curves, swap.portfolio, today){
  dcc.tibble <- tibble::tibble(
    currency = rep(ExtractFromList(swap.portfolio, "currency"), each = 2),
    type = ExtractFromList(swap.portfolio, "type"),
    dcc = ExtractFromList(swap.portfolio, "dcc")
  ) %>%
    dplyr::filter(grepl("fixed", .data$type)) %>%
    dplyr::distinct()

  for (row in purrr::transpose(dcc.tibble)) {
    curves[[row$currency]]$discount %<>%
      dplyr::mutate(!!row$dcc := fmdates::year_frac(today, .data$Date, row$dcc))
  }

  discount.curves <- map(curves, ~.x$discount %>%
                           select(-Date) %>%
                           {rbind(c(1,rep(0, ncol(.x$discount) - 1)),.)})

  list(discount = discount.curves)
}
