# file: timeline_build.R
# author: Danielle Navarro

#' Initialise a timeline
#'
#' @param ... trial objects to add to this timeline
#' @export
timeline <- function(...){
  tl <- list(timeline = list(...))
  class(tl) <- c("timeline", "list")
  tl
}

#' Adds an arbitrary trial to the timeline
#'
#' @param type the type of trial
#' @param ... arguments passed to the trial plugin
#' @export
trial <- function(type, ...) {
  return(list(type = type, ...))
}

# lifted version
trial_l <- purrr::lift_dl(trial)

#' Use a timeline variable
#'
#' @param name name of the variable to insert
#'
#' @export
#'
variable <- function(name) {
  str <- paste0("jsPsych.timelineVariable('",name, "')")
  return(js_code(str))
}

#' Attach a timeline variable to timeline object
#'
#' @param timeline the timeline object
#' @param ... name value pairs
#'
#' @export
with_variables <- function(timeline, ...) {
  vars <- list(...)
  vars <- purrr::transpose(vars)
  timeline[["timeline_variables"]] <- vars
  return(timeline)
}

#' Attach a timeline variable to timeline object
#'
#' @param timeline the timeline object
#' @param ... name value pairs
#'
#' @export
with_parameters <- function(timeline, ...) {
  timeline <- c(timeline, ...)
  return(timeline)
}

#' Loop this timeline
#'
#' @param timeline the timeline object
#' @param loop_function javascript function that returns true if loop repeats, false if terminates
#'
#' @export
with_loop <- function(timeline, loop_function) {
  timeline[["loop_function"]] <- loop_function
  return(timeline)
}

#' Conditionally execute this timeline
#'
#' @param timeline the timeline object
#' @param conditional_function javascript function that reutrns true to execute timeline, false to skip
#'
#' @export
with_condition <- function(timeline, conditional_function) {
  timeline[["conditional_function"]] <- conditional_function
  return(timeline)
}





