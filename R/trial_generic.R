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
#' @details The \code{trial_generic()} function is the most flexible of
#' all the functions within the \code{trial_} family, and can be use to
#' insert a trial of any \code{type}. For example, by setting
#' \code{type = "image-keyboard-response"}, it will create an image trial
#' using a keyboard response, precisely analogous to trials created using
#' the \code{\link{trial_image_keyboard_response}()} function. More generally
#' the \code{type} value should be a string that specifies the name of the
#' corresponding jsPsych plugin file: in this case, the file name for the
#' plugin "jspsych-image-keyboard-response.js" so the corresponding \code{type}
#' value is "image-keyboard-response".
#'
#' While the advantage to \code{trial_generic()} is flexibility, the disadvantage
#' is that all arguments to the plugin must be specified as named arguments passed
#' via \code{...}, and it can take some trial and error to get a novel plugin to
#' behave in the expected fashion. For example, if a particular argument to the
#' jsPsych plugin takes a logical value, it may not always be sufficient to
#' use logical values \code{TRUE} or \code{FALSE} when the trial is constructed
#' from within R. The reason for this is that when the R code is converted to
#' javascript (using the jsonlite package), it \emph{does} correctly convert
#' the R logicals \code{TRUE} and \code{FALSE} to the corresponding javascript
#' logical values \code{true} and \code{false}, but by default this value is
#' written to a javascript array of length one rather than recorded as a scalar
#' value (i.e., the javascript code becomes \code{[true]} rather than \code{true}).
#' When this occurs, jsPsych often does not produce the desired behaviour as
#' these two entities are not considered equivalent in javascript.
#'
#' In future versions of jaysire there may be better support for arbitary
#' plugins, but for the moment users should be aware that \code{trial_generic()}
#' can be somewhat finicky to work with.
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

