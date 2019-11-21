# file: timeline_build.R
# author: Danielle Navarro

#' Build a timeline from trials
#'
#' @param ... trial objects to add to this timeline
#' @export
build_timeline <- function(...){
  tl <- list(timeline = list(...))
  class(tl) <- c("timeline", "list")
  tl
}

#' Adds an arbitrary trial to the timeline
#'
#' @param type the type of trial
#' @param ... arguments passed to the trial plugin
#' @export
trial_generic <- function(type, ...) {
  trial(type, ...)
}


# internal version of trial_generic() using dots
trial <- function(type, ...) {
  return(list(type = type, ...))
}

# internal version of trial_generic() that lifts domain to list input
trial_l <- purrr::lift_dl(trial)



