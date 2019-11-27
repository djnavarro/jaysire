#' Specify a trial using any plugin
#'
#' @description The \code{trial_generic} function is used to create a trial with
#' an arbitrary jsPsych plugin.
#'
#' @param type the type of trial
#' @param ... arguments passed to the trial plugin
#'
#' @return Functions with a \code{trial_} prefix always return a "trial" object.
#' A trial object is simply a list containing the input arguments, with
#' \code{NULL} elements removed. Logical values in the input (\code{TRUE} and
#' \code{FALSE}) are transformed to character vectors \code{"true"} and \code{"false"}
#' and are specified to be objects of class "json", ensuring that they will be
#' written to file as the javascript logicals, \code{true} and \code{false}.
#'
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

