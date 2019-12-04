

#jsPsych.randomization.sampleWithReplacement(array, sampleSize, weights)
#jsPsych.randomization.sampleWithoutReplacement(array, sampleSize)


#' Return a javascript function that samples from an array
#'
#' @param x A vector specifying the possible values
#' @param size The number of values to sample
#' @param replace Sample with replacement? (default = FALSE)
#' @param weights Probability of sampling each item (ignored if replace = FALSE)
#'
#' @return Returns a javascript function that samples from an array of values
#' @details The \code{fn_sample()} is used to return a function that, when called
#' from within a jsPsych experiment, will mirror the behaviour of the \code{sample()}
#' function from the base package using th jsPsych randomisation functions to
#' at runtime. The input argument \code{x} specifies the set of values from which
#' samples should be drawn, and the \code{size} argument specifies the number of
#' samples to be drawn. When \code{replace = TRUE} items are sampled with
#' replacement, and when \code{replace = FALSE} items are sampled without
#' replacement. When sampling with replacement, the \code{weights} argument can
#' be used to specify unequal sampling probabilities.
#'
#' The current implementation is limited. It does not work when \code{x} is a
#' character vector, for example. Note also that the value returned within
#' the jsPsych experiment is always an array (not a scalar), even when
#' \code{size = 1}.
#'
#' @export
fn_sample <- function(x, size, replace = FALSE, weights = NULL) {

  x <- paste(x, collapse = ", ")
  x <- paste0("[", x, "]")

  # sample with replacement
  if(replace == TRUE) {

    # arguments
    if(is.null(weights)) {
      args <- paste(x, size, sep = ", ")
    } else {
      args <- paste(x, size, weights, sep = ", ")
    }

    # the jsPsych function
    fn <- js_code(paste0(
      "function() {",
      "  return jsPsych.randomization.sampleWithReplacement(", args, ");",
      "}"
    ))

  # sample without replacement
  } else {

    args <- paste(x, size, sep = ", ")
    fn <- js_code(paste0(
      "function() {",
      "  return jsPsych.randomization.sampleWithoutReplacement(", args, ");",
      "}"
    ))

  }

  return(fn)
}

