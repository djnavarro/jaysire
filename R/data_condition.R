
#' Return a javascript function that checks a data value
#'
#' @param expr An expression to be evaluated within the jsPsych data store
#' @param trials_back The number of trials before the present one for which to query the data
#' @export
#' @return A javascript function
#' @details The \code{fn_data_condition()} function creates a javascript function that
#' can query the jsPsych data store and evaluate the expression \code{expr} within the
#' data store. It is (at present) very limited, and can only query the data store for
#' a single trial (i.e., a single row in the data set). By default it queries the
#' most recent trial (\code{trials_back = 1}) but this behaviour can be modified.
#'
#' The intention behind this function is that it be used in conjunction with functions
#' such as \code{\link{display_if}()} and \code{\link{display_while}()} that
#' require a javascript function that will evaluate to true or false, in order to
#' determine whether to continue the while loop or whether the if condition holds.
#'
#' As an example, one might set \code{fn_data_condition(button_pressed == "0")}
#' when calling \code{\link{display_if}()}. If the participant had pressed
#' button "0" on the previous trial, then the timeline in question will be
#' executed. Otherwise it is not.
#'
#' Note that this function is a work in progress and will likely change in
#' future versions in order to allow more flexibility.
#'
fn_data_condition <- function(expr, trials_back = 1) {

  expr <- deparse(rlang::enexpr(expr))
  condition <- paste0("data.", expr)

  js_fun <- js_code(paste0(
    "function(){
      var data = jsPsych.data.get().last(", trials_back, ").values()[0];
      if(", condition, "){
        return true;
      } else {
        return false;
      }
    }"
  ))
  return(js_fun)
}
