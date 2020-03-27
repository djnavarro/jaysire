
#' Modify a timeline to set possible values for variables
#'
#' @param timeline The timeline object
#' @param ... A set of name/value pairs defining the timeline variables
#' @return The modified timeline object
#'
#' @details When creating an experiment, a common pattern is to create a
#' series of trials that are identical in every respect except for one thing
#' that varies across the trial (e.g., a collection of
#' \code{\link{trial_html_button_response}()} trials that are the same except
#' for the text that is displayed). A natural way to handle this in the
#' jsPsych framework is to create the trial in the usual fashion, except that
#' instead of specifying the \emph{value} that needs to be included in the
#' trial (e.g., the text itself) the code includes a reference to a
#' \emph{timeline variable}. Inserting the \emph{reference} to the variable
#' is the job of the \code{\link{insert_variable}()} function; \emph{attaching}
#' that variable to the timeline and specifying its possible values is the
#' job of \code{set_variables}. This is most easily explained by using
#' an example, as shown below.
#'
#' @examples
#' # create a template from which a series of trials can be built
#' template <- trial_html_button_response(stimulus = insert_variable("animal"))
#'
#' # create a timeline with three trials, all using the same template
#' # but with a different value for the "animal" variable
#' timeline <- build_timeline(template) %>%
#'   set_variables(animal = c("cat", "dog", "pig"))
#'
#' @seealso \code{\link{build_timeline}}, \code{\link{insert_variable}}
#'
#' @export
set_variables <- function(timeline, ...) {
  vars <- list(...)
  vars <- purrr::transpose(vars)
  timeline[["timeline_variables"]] <- vars
  return(timeline)
}

#' Modify a timeline to set parameter values
#'
#' @param timeline The timeline object
#' @param ... A set of name/value pairs defining the parameters
#' @return The modified timeline object
#'
#' @details The \code{set_parameters()} function provides a general
#' purpose method of adding arbitrary parameters to an existing
#' \code{timeline}. Anything that jsPsych recognises as a possible
#' timeline parameter can be inserted using this method. Some possibilities
#' are shown in the examples section.
#'
#' @seealso \code{\link{build_timeline}}, \code{\link{set_variables}}
#'
#' @examples
#' # typically we begin with a trial template:
#' trial_template <- trial_html_button_response(
#'      stimulus = insert_variable(name = "my_stimulus"),
#'      choices = c("true", "false")
#'  )
#'
#'  # then we fill it out so that there is now a "block" of trials:
#'  equations <- c("13 + 23 = 36",  "17 - 9 = 6", "125 / 5 = 25")
#'  trials <- build_timeline(trial_template) %>%
#'      set_variables(my_stimulus = equations)
#'
#'  # we can randomise presentation order and repeat the block:
#'  trials <- trials %>%
#'      set_parameters(randomize_order = TRUE, repetitions = 2)
#'
#' @export
set_parameters <- function(timeline, ...) {
  timeline <- c(timeline, ...)
  return(timeline)
}

#' Modify a timeline to execute within a loop
#'
#' @param timeline The timeline object
#' @param loop_function A javascript function that returns true if loop repeats, false if terminates
#'
#' @return The modified timeline object
#'
#' @details The \code{display_while()} function is used to modify an existing
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
#' @seealso \code{\link{display_if}}, \code{\link{build_timeline}},
#' \code{\link{fn_data_condition}}, \code{\link{insert_javascript}}
#'
#' @export
display_while <- function(timeline, loop_function) {
  timeline[["loop_function"]] <- loop_function
  return(timeline)
}

#' Modify a timeline to execute if a condition is met
#'
#' @param timeline A timeline object
#' @param conditional_function A javascript function that returns true if the timeline should execute and false otherwise
#' @return The modified timeline object
#'
#' @details The \code{display_if()} function is used to modify an existing
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
#' @seealso \code{\link{display_while}}, \code{\link{build_timeline}},
#' \code{\link{fn_data_condition}}, \code{\link{insert_javascript}}
#'
#' @export
display_if <- function(timeline, conditional_function) {
  timeline[["conditional_function"]] <- conditional_function
  return(timeline)
}
