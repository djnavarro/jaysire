
#' Return a javascript function to save data locally
#'
#' @export
fn_save_locally <- function() {
  js_code(
  "function() {
    var data = jsPsych.data.get().csv();
    var file = 'xprmntr_local_name';
    var xhr = new XMLHttpRequest();
    xhr.open('POST', 'submit');
    xhr.setRequestHeader('Content-Type', 'application/json');
    xhr.send(JSON.stringify({filename: file, filedata: data}));
  }")
}


#' Return a javascript function to save data to Google datastore
#'
#' @export
fn_save_datastore <- function() {
  js_code(
    "function() {
      $.post('submit',{\"content\": jsPsych.data.get().csv()})
    }"
  )
}
