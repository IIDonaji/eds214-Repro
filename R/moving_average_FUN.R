#' The following function calculates a 9-week moving-average window
#'
#' @param focal_date 
#' @param dates 
#' @param conc 
#' @param win_size_wks 
#'
#' @returns Stream-water concentration before and after Hurricane Hugo (1989)
#' @export
#'
#' @examples
#'  mutate(conc_aver = sapply(
#'           sample_date,
#'           moving_average,
#'          dates = sample_date,
#'           conc = water_conc,
#'             win_size_wks = 9 
#'                            )
#' 

moving_average <- function(focal_date, dates, conc, win_size_wks) { # creating a bin for the 9-week window
  is_in_window <- (dates > focal_date - (win_size_wks / 2) * 7) &
    (dates < focal_date + (win_size_wks /2) *7)
  conc_window <- conc[is_in_window]
  result <- mean(conc_window, na.rm = TRUE)
  
  return(result)
}