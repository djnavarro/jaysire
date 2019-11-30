
#' Specify pages of instructions to display
#'
#' @description The \code{trial_instructions} function is used to display
#' one or more pages of instructions that a participant can browse.
#'
#' @param pages Character vector. Each element should be an HTML-formatted string specifying a page
#' @param key_forward This is the key that the subject can press in order to advance to the next page, specified as their numeric key code or as characters
#' @param key_backward This is the key that the subject can press in order to return to the previous page.
#' @param allow_backward If TRUE, participants can navigate backwards
#' @param allow_keys If TRUE, participants can use keyboard keys to navigate
#' @param show_clickable_nav If TRUE, buttons will be shown to allow navigation
#' @param button_label_previous Text on the "previous" button
#' @param button_label_next Text on the "next" button
#'
#' @param post_trial_gap  The gap in milliseconds between the current trial and the next trial. If NULL, there will be no gap.
#' @param on_finish A javascript callback function to execute when the trial finishes
#' @param on_load A javascript callback function to execute when the trial begins, before any loading has occurred
#' @param data An object containing additional data to store for the trial
#'
#'@return Functions with a \code{trial_} prefix always return a "trial" object.
#' A trial object is simply a list containing the input arguments, with
#' \code{NULL} elements removed. Logical values in the input (\code{TRUE} and
#' \code{FALSE}) are transformed to character vectors \code{"true"} and \code{"false"}
#' and are specified to be objects of class "json", ensuring that they will be
#' written to file as the javascript logicals, \code{true} and \code{false}.
#'
#'
#'@return Functions with a \code{trial_} prefix always return a "trial" object.
#' A trial object is simply a list containing the input arguments, with
#' \code{NULL} elements removed. Logical values in the input (\code{TRUE} and
#' \code{FALSE}) are transformed to character vectors \code{"true"} and \code{"false"}
#' and are specified to be objects of class "json", ensuring that they will be
#' written to file as the javascript logicals, \code{true} and \code{false}.
#'
#' @details This plugin is for showing instructions to the subject. It allows
#' subjects to navigate through multiple pages of instructions at their own pace,
#' recording how long the subject spends on each page. Navigation can be done
#' using the mouse or keyboard. Subjects can be allowed to navigate forwards
#' and backwards through pages, if desired.
#'
#'
#' Like all functions in the \code{trial_} family it contains four additional
#' arguments:
#'
#' \itemize{
#' \item The \code{post_trial_gap} argument is a numeric value specifying the
#' length of the pause between the current trial ending and the next one
#' beginning. This parameter overrides any default values defined using the
#' \code{\link{build_experiment()}} function, and a blank screen is displayed
#' during this gap period.
#'
#' \item The \code{on_load} and \code{on_finish} arguments can be used to
#' specify javascript functions that will execute before the trial begins or
#' after it ends. The javascript code can be written manually and inserted *as*
#' javascript by using the \code{\link{insert_javascript()}} function. However,
#' the \code{fn_} family of functions supplies a variety of functions that may
#' be useful in many cases.
#'
#' \item The \code{data} argument can be used to insert custom data values into
#' the jsPsych data storage for this trial
#' }
#'
#' @section Data:
#'
#' When this function is called from R it returns the trial object that will
#' later be inserted into the experiment when \code{\link{build_experiment()}}
#' is called. However, when the trial runs as part of the experiment it returns
#' values that are recorded in the jsPsych data store and eventually form part
#' of the data set for the experiment.
#'
#' The data recorded by this trial is as follows:
#'
#' \itemize{
#' \item The \code{view_history} value is a JSON string containing the order of pages
#' the subject viewed (including when the subject returned to previous pages)
#' and the time spent viewing each page.
#' \item The \code{rt} value is the response time
#' in milliseconds for the subject to view all of the pages.
#' }
#'
#'
#' In addition, it records default variables that are recorded by all trials:
#'
#' \itemize{
#' \item \code{trial_type} is a string that records the name of the plugin used to run the trial.
#' \item \code{trial_index} is a number that records the index of the current trial across the whole experiment.
#' \item \code{time_elapsed} counts the number of milliseconds since the start of the experiment when the trial ended.
#' \item \code{internal_node_id} is a string identifier for the current "node" in the timeline.
#' }
#'
#' @export
trial_instructions <- function(
  pages,
  key_forward = "rightarrow",
  key_backward = "leftarrow",
  allow_backward = TRUE,
  allow_keys = TRUE,
  show_clickable_nav = FALSE,
  button_label_previous = "Previous",
  button_label_next = "Next",
  post_trial_gap = 0,  # start universals
  on_finish = NULL,
  on_load = NULL,
  data = NULL
) {
  drop_nulls(
    trial(
      type = "instructions",
      pages = pages,
      key_forward = key_forward,
      key_backward = key_backward,
      allow_backward = js_logical(allow_backward),
      allow_keys = js_logical(allow_keys),
      show_clickable_nav = js_logical(show_clickable_nav),
      button_label_previous = button_label_previous,
      button_label_next = button_label_next,
      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}
