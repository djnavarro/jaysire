# file: helpers.R
# author: Danielle Navarro


#' Response is accepted with any key press
#'
#' @export
#' @details Many of the functions within the \code{trial_} family are designed
#' to allow participants to respond using a key press, generally by specifying a
#' a \code{choices} argument that indicates which keys will be accepted as valid
#' responses (e.g., \code{choices = c("f","j")}). There are also cases where
#' you may wish to allow every key to be a valid response (e.g., in situations
#' where "Press any key to continue" is a sensible prompt).
#' In those cases, specifying \code{choices = respond_any_key()} will
#' produce the desired behaviour.
#'
#' @seealso \code{\link{respond_no_key}}, \code{\link{trial_html_keyboard_response}},
#' \code{\link{trial_image_keyboard_response}}, \code{\link{trial_audio_keyboard_response}},
#' \code{\link{trial_video_keyboard_response}}
#'
respond_any_key <- function() {
  js_code("jsPsych.ANY_KEY")
}

#' Response is not accepted for any key press
#'
#' @export
#'
#' @details Many of the functions within the \code{trial_} family are designed
#' to allow participants to respond using a key press, generally by specifying a
#' a \code{choices} argument that indicates which keys will be accepted as valid
#' responses (e.g., \code{choices = c("f","j")}). There are also cases where
#' you may wish to disable this, so that no key presses will be counted as valid
#' responses (e.g., when a trial runs for a fixed duration but no response is
#' expected). In those cases, specifying \code{choices = respond_no_key()} will
#' produce the desired behaviour.
#'
#' @seealso \code{\link{respond_any_key}}, \code{\link{trial_html_keyboard_response}},
#' \code{\link{trial_image_keyboard_response}}, \code{\link{trial_audio_keyboard_response}},
#' \code{\link{trial_video_keyboard_response}}
respond_no_key <- function() {
  js_code("jsPsych.NO_KEY")
}



drop_nulls <- function(x) {
  x[purrr::map_lgl(x, ~!is.null(.x))]
}

# returns a list of expressions
capture_dots <- function(...) {
  as.list(substitute(list(...)))[-1L]
}

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

#' @importFrom rlang %||%
NULL

get_timestamp <- function() {
  tsp <- as.character(Sys.time())
  tsp <- gsub("[ :]", "-", tsp)
  return(tsp)
}

get_alphanumeric <- function(n = 5) {
  x <- c("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r",
         "s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9")
  r <- sample(x, size = n, replace = TRUE)
  r <- paste(r, collapse = "")
  return(r)
}

#' Creates a temporary folder
#'
#' @return A string specifying the path to the folder
#' @details The \code{temporary_folder()} function is a convenience function
#' used to create a new temporary folder inside the temporary directory
#' (see \code{tempdir}) for the current R session. The name of the subfolder
#' is always "jaysire_" followed by a 5-character alphanumeric string.
#'
#' The purpose of this function is mostly expository: it makes it a little
#' easier to create easy-to-follow tutorials on the package website. It is
#' not expected that users of the jaysire package would have much need for this
#' function
#'
#' @export
temporary_folder <- function() {
  idstr <- paste0("jaysire_", get_alphanumeric(n = 5))
  resource <- file.path(tempdir(), idstr)
  if(!dir.exists(resource)) {
    dir.create(resource)
  }
  return(resource)
}
