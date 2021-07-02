#' @importFrom fredr fredr
#' @importFrom purrr set_names
#' @importFrom Quandl Quandl
DownloadRate <- function(floating.data){
  Quandl::Quandl.api_key("5ydoG6gTCKjgzDpJp_1s")
  fredr::fredr_set_key("5b73de5f5f1ce46a60d5bd93e4e670bd")
  ifelse(grepl("FRED",floating.data$source),
         list(fredr::fredr(floating.data$floating.rate.code,
                           observation_start = floating.data$min.date,
                           observation_end = floating.data$max.date)),
         list(Quandl::Quandl(floating.data$floating.rate.code,
                             start_date = floating.data$min.date,
                             end_date = floating.data$max.date) %>%
                purrr::set_names(c("date", "value"))))
}

DownloadRateOffline <- function(input, variable.ts) {
  variable.ts |>
    dplyr::mutate(DATE = as.Date(DATE)) |>
    dplyr::select(DATE, dplyr::matches(input$floating.rate.code)) |>
    dplyr::filter(DATE >= input$min.date,
                  DATE <= input$max.date) |>
    dplyr::rename_all(~c("date", "value")) |>
    list()
}

#' @importFrom dplyr group_by summarise left_join ungroup mutate select
#' @importFrom purrr map_chr map_depth map compact flatten reduce
#' @importFrom tibble tibble
#' @importFrom tidyr replace_na nest
VariableRateDownload <- function(swap.portfolio, cashflows, today,
                                 variable.ts) {
  currency <- unname(purrr::map_chr(swap.portfolio,"currency"))
  time.unit <- unname(unlist(purrr::map_depth(swap.portfolio, 1, "floating.freq")))

  fixing.date <- cashflows %>%
    purrr::map_depth(2, "fixing.date") %>%
    purrr::map(purrr::compact) %>%
    tidyr::replace_na() %>%
    purrr::flatten() %>%
    purrr::reduce(c)

  if (is.null(attributes(fixing.date))) {
    fixing.date %<>%
      as.Date(origin = "1970-01-01")
  }

  floating.rate <- tibble::tibble(currency = currency,
                 time.unit = time.unit,
                 fixing.date = fixing.date) %>%
    stats::na.omit(.data) %>%
    dplyr::group_by(currency, time.unit) %>%
    dplyr::summarise(min.date = min(fixing.date, na.rm = TRUE),
                     max.date = max(fixing.date, na.rm = TRUE)) %>%
    dplyr::left_join(swap.standard.rates, by = c("currency", "time.unit")) %>%
    dplyr::ungroup()

  if (length(setdiff(unique(floating.rate$currency), "EUR")) > 0) {
    check <- floating.rate[!grepl("EUR", floating.rate$currency), "max.date"] %>%
      purrr::reduce(c) %>%
      max
    if (check > (today - 7)) {
      warning("FRED data has a one week lag, we use the latest available rate to
            calculate the accrual of the floating leg")
    }
  }

  floating.rate <- floating.rate %>%
    tidyr::nest(-currency, -time.unit) %>%
    dplyr::mutate(rate.data = purrr::map(.data$data, ~DownloadRateOffline(.x, variable.ts))) %>%
    dplyr::select(-.data$data)
}
