ImportCurve <- function(curve, today) {
  lag <- swap.standard.calendar[
    grepl(curve$currency,  swap.standard.calendar$currency),][["lag"]]
  settle.date <- RQuantLib::advance(calendar = calendar,
                                    dates = start.date,
                                    n = .x,
                                    timeUnit = ,
                                    bdc = 1,
                                    emr = TRUE)
}
