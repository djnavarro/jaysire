
#' Toggle fullscreen mode in the browser
#'
#' @description The \code{fullscreen} function is used to toggle fullscreen mode in the browser.
#'
#' @param fullscreen_mode If TRUE, sets browser in full screen mode. Default: TRUE.
#' @param message This is the message that is displayed in the browser to inform of the switch to fullscreen mode.
#' @param button_label This is label of the button to acknowledge the switch.
#' @param delay_after Time period in ms after the switch to proceed with the following element in the timeline.
#'
#' @export
fullscreen <- function(
  fullscreen_mode = TRUE,
  message = "<p>The experiment will switch to full screen mode when you press the button below</p>",
  button_label = "Continue",
  delay_after = 1000
) {
  drop_nulls(
    trial(
      type = "fullscreen",
      fullscreen_mode = fullscreen_mode,
      message = message,
      button_label = button_label,
      delay_after = delay_after
    )
  )
}
