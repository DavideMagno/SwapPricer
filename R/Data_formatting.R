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
#'
#' @export
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
      ApplyStandardConventions
  } else {
    swap.tabular$time.unit <- list(pay = swap.tabular$time.unit.pay,
                                     receive = swap.tabular$time.unit.receive)
    swap.tabular$dcc <- list(pay = swap.tabular$dcc.pay,
                               receive = swap.tabular$dcc.receive)
  }

  swap.tabular %<>%
    purrr::discard(stringr::str_detect(names(.),
                                       "pay|receive|standard|ID") == TRUE)
}


#' Helper function to format standard swaps
#'
#' This function calls other helper functions to format a swap list from the
#' tabular version to the target one
#'
#' @param swap.tabular a list which includes the user defined characteristics
#' of a swap contract
#'
#' @return a formatted version of the contract that is readable by the functions
#' in the toolbox
#'
#' @export
ApplyStandardConventions <- function(swap.tabular) {
  swap.tabular$time.unit <- swap.tabular %>%
    GetStandardList("time.unit")

  swap.tabular$dcc <- swap.tabular %>%
    GetStandardList("dcc")

  swap.tabular$calendar <- swap.tabular %>%
    GetStandardCalendar

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
#'
#' @return a flist of standard characteristics for both the legs
#'
#' @importFrom purrr transpose flatten
#'
#' @export
GetStandardList <- function(swap.tabular, variable) {
  list(pay = GetStandard(swap.tabular, "pay", variable),
       receive = GetStandard(swap.tabular, "receive", variable)) %>%
    purrr::transpose(.) %>%
    purrr::flatten(.)
}

#' Helper function to format standard swaps
#'
#' This function calls other helper functions to format a swap list from the
#' tabular version to the target one
#'
#' @param swap.tabular a list which includes the user defined characteristics
#' of a swap contract
#' @param leg specifies whether the leg is payer or receiver
#' @param variable the contract feature that is being converted
#'
#' @return a standard feature for the contract
#'
#' @export
GetStandard <- function(swap.tabular, leg, variable) {
  swap.leg <- swap.tabular$type[leg] %>%
    as.character()

  SwapPricer::swap.standard %>%
    {.[grepl(swap.tabular$currency, .$currency) & grepl(swap.leg, .$leg),]} %>%
    .[[variable]]
}

#' Helper function to format standard swaps
#'
#' This function calls other helper functions to format a swap list from the
#' tabular version to the target one
#'
#' @param swap.tabular a list which includes the user defined characteristics
#' of a swap contract
#'
#' @return the standard calendar for the currency
#'
#' @export
GetStandardCalendar <- function(swap.tabular) {

  SwapPricer::swap.standard.calendar %>%
    {.[grepl(swap.tabular$currency, .$currency),]} %>%
    .[["calendar"]]
}
