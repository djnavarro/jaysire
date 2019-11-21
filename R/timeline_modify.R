
#' Modify timeline to attach variables
#'
#' @param timeline the timeline object
#' @param ... name value pairs
#'
#' @export
tl_add_variables <- function(timeline, ...) {
  vars <- list(...)
  vars <- purrr::transpose(vars)
  timeline[["timeline_variables"]] <- vars
  return(timeline)
}

#' Modify timeline to add parameters
#'
#' @param timeline the timeline object
#' @param ... name value pairs
#'
#' @export
tl_add_parameters <- function(timeline, ...) {
  timeline <- c(timeline, ...)
  return(timeline)
}

#' Modify timeline to execute within a loop
#'
#' @param timeline the timeline object
#' @param loop_function javascript function that returns true if loop repeats, false if terminates
#'
#' @export
tl_display_while <- function(timeline, loop_function) {
  timeline[["loop_function"]] <- loop_function
  return(timeline)
}

#' Modify timeline to execute if a condition is met
#'
#' @param timeline the timeline object
#' @param conditional_function javascript function that reutrns true to execute timeline, false to skip
#'
#' @export
tl_display_if <- function(timeline, conditional_function) {
  timeline[["conditional_function"]] <- conditional_function
  return(timeline)
}
