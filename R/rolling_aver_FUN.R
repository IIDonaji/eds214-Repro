# Function

moving_average <- function(focal_date, dates, conc, win_size_wks) {
  is_in_window <- (dates > focal_date - (win_size_wks / 2) * 7) &
    (dates < focal_date + (win_size_wks /2) *7)
  conc_window <- conc[is_in_window]
  result <- mean(conc_window, na.rm = TRUE)
  
  return(result)
}

