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



