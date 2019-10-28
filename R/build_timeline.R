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


