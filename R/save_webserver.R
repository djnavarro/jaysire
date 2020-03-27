#' Return a javascript function to save data via a script on the webserver
#'
#' @export
#' @return Return a javascript function to save data via a script on the webserver
#'
#' @details The purpose of the \code{fn_save_webserver()} is to return a
#' javascript function that, when called from within the jsPsych experiment,
#' will write the data to the server. This assumes that the experiment will
#' be run on a (php)script-enabled webserver. This way, you know the data will
#' never touch any other computer than the server you've presumably secured
#' and have data processing agreements in place for.
#'
#' @seealso \code{\link{run_webserver}}, \code{\link{download_data_webserver}}
fn_save_webserver <- function() {
  js_code(paste0(
    "function() {
    var url = 'resource/script/record_result.php';
    var data = {filedata: jsPsych.data.get().csv()};
    fetch(url, {
      method: 'POST',
      body: JSON.stringify(data),
      headers: new Headers({
            'Content-Type': 'application/json'})});}"))
}
