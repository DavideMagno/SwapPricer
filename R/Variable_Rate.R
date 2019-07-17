VariableRateDownload <- function(swap.portfolio) {
  currency <- purrr::map_depth(2, "fixing.date") %>%
    purrr::map(purrr::compact) %>%
    purrr::flatten() %>%
    unique
}
