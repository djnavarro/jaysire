

#jsPsych.randomization.sampleWithReplacement(array, sampleSize, weights)
#jsPsych.randomization.sampleWithoutReplacement(array, sampleSize)


#' Return a javascript function that samples from an array
#'
#' @param x A vector specifying the possible values
#' @param size The number of values to sample
#' @param replace Sample with replacement? (default = FALSE)
#' @param weights Probability of sampling each item (ignored if replace = FALSE)
#'
#' @return Javascript function
#' @details Loosely mirrors the sample function in base, but uses the jsPsych
#' randomisation functions to execute client side at runtime. At the moment it
#' does not work when x is a character vector, and always returns an array even
#' if the output is of length 1
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

