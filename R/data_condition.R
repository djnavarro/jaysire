
#' Return a javascript function that checks a data value
#'
#' @param expr expression to be evaluated within the jsPsych data store
#' @param trials_back how many trials back?
#'
#' @export
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
