
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

#' Modify a timeline to execute within a loop
#'
#' @param timeline the timeline object
#' @param loop_function javascript function that returns true if loop repeats, false if terminates
#'
#' @return The modified timeline object
#'
#' @details The \code{tl_display_while()} function is used to modify an existing
#' \code{timeline} object, and provides the ability to include while loops
#' within an experiment. To use it, the user must supply the
#' \code{loop_function}, a javascript function that executes at
#' runtime and should evaluate to true or false. If the
#' loop function returns true, then the timeline object
#' will execute for another iteration; this condinues until the
#' loop function returns false.
#'
#' At present jaysire provides only limited tools for writing the
#' loop function. The \code{\link{fn_data_condition}()} function allows
#' a simple approach that allows the loop function to query the
#' jsPsych data store, but only in a limited way. Future versions will
#' (hopefully) provide a richer tool set for this. However, for
#' users who are comfortable with writing javascript functions directly
#' the \code{\link{insert_javascript}()} function may be useful.
#'
#' @seealso \code{\link{tl_display_if}}, \code{\link{build_timeline}},
#' \code{\link{fn_data_condition}}, \code{\link{insert_javascript}}
#'
#' @export
tl_display_while <- function(timeline, loop_function) {
  timeline[["loop_function"]] <- loop_function
  return(timeline)
}

#' Modify a timeline to execute if a condition is met
#'
#' @param timeline A timeline object
#' @param conditional_function A javascript function that returns true if the timeline should execute and false otherwise
#' @return The modified timeline object
#'
#' @details The \code{tl_display_if()} function is used to modify an existing
#' \code{timeline} object, and provides the ability for conditional branching
#' within an experiment. To use it, the user must supply the
#' \code{conditional_function}, a javascript function that executes at
#' runtime and should evaluate to true or false. If the
#' conditional function returns true, then the timeline object
#' will execute; if the conditional function returns false then jsPsych
#' will not run this timeline.
#'
#' At present jaysire provides only limited tools for writing the
#' conditional function. The \code{\link{fn_data_condition}()} function allows
#' a simple approach that allows the conditional function to query the
#' jsPsych data store, but only in a limited way. Future versions will
#' (hopefully) provide a richer tool set for this. However, for
#' users who are comfortable with writing javascript functions directly
#' the \code{\link{insert_javascript}()} function may be useful.
#'
#' @seealso \code{\link{tl_display_while}}, \code{\link{build_timeline}},
#' \code{\link{fn_data_condition}}, \code{\link{insert_javascript}}
#'
#' @export
tl_display_if <- function(timeline, conditional_function) {
  timeline[["conditional_function"]] <- conditional_function
  return(timeline)
}
