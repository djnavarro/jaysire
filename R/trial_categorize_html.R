#' Displays HTML, records responses with the keyboard and gives feedback
#'
#' @param stimulus The HTML to be displayed.
#' @param key_answer The numeric key code indicating the correct response
#' @param choices A character vector of keycodes (either numeric values or the characters themselves). Alternatively, respond_any_key() and respond_no_key() can be used
#' @param text_answer A label associated with the correct answer
#' @param correct_text Text to display when correct answer given ('\%ANS\%' substitutes text_answer)
#' @param incorrect_text Text to display when wrong answer given ('\%ANS\%' substitutes text_answer)
#'
#' @param prompt A string (may contain HTML) that will be displayed below the stimulus, intended as a reminder about the actions to take (e.g., which key to press).
#'
#' @param force_correct_button_press If TRUE the correct button must be pressed after feedback in order to advance
#' @param show_stim_with_feedback If TRUE the stimulus image will be displayed as part of the feedback. Otherwise only text is shown
#' @param show_feedback_on_timeout If TRUE the "wrong answer" feedback will be presented on timeout. If FALSE, a timeout message is shown
#' @param timeout_message The message to show on a timeout non-response
#' @param stimulus_duration How long to show the stimulus, in milliseconds. If NULL, then the stimulus will be shown until the subject makes a response
#' @param feedback_duration How long to show the feedback, in milliseconds
#' @param trial_duration How long to wait for a response before ending trial in milliseconds. If NULL, the trial will wait indefinitely. If no response is made before the deadline is reached, the response will be recorded as NULL.
#'
#' @param post_trial_gap  The gap in milliseconds between the current trial and the next trial. If NULL, there will be no gap.
#' @param on_finish A javascript callback function to execute when the trial finishes
#' @param on_load A javascript callback function to execute when the trial begins, before any loading has occurred
#' @param data An object containing additional data to store for the trial
#'
#'
#' @return Functions with a \code{trial_} prefix always return a "trial" object.
#' A trial object is simply a list containing the input arguments, with
#' \code{NULL} elements removed. Logical values in the input (\code{TRUE} and
#' \code{FALSE}) are transformed to character vectors \code{"true"} and \code{"false"}
#' and are specified to be objects of class "json", ensuring that they will be
#' written to file as the javascript logicals, \code{true} and \code{false}.
#'
#' @details In addition to the default data collected by all plugins, this
#' plugin collects the following data for each trial:
#'
#' The \code{stimulus} value is the HTML displayed on the trial. The \code{key_press}
#' value indicates which key the subject pressed. The value is the numeric key
#' code corresponding to the subject's response. The \code{rt} value is the
#' response time in milliseconds for the subject to make a response. The time is
#' measured from when the stimulus first appears on the screen until the subject's
#' response. The \code{correct} value is true if the subject got the correct answer,
#' false otherwise.
#'
#' @export
trial_categorize_html <- function(
  stimulus,
  key_answer,
  choices = respond_any_key(),
  text_answer = "",
  correct_text = "Correct",
  incorrect_text = "Wrong",
  prompt = NULL,
  force_correct_button_press = FALSE,
  show_stim_with_feedback = TRUE,
  show_feedback_on_timeout = FALSE,
  timeout_message = "Please respond faster",
  stimulus_duration = NULL,
  feedback_duration = 2000,
  trial_duration = NULL,

  post_trial_gap = 0,  # start universals
  on_finish = NULL,
  on_load = NULL,
  data = NULL
) {
  drop_nulls(
    trial(
      type = "categorize-html",
      stimulus = stimulus,
      key_answer = key_answer,
      choices = choices,
      text_answer = text_answer,
      correct_text = correct_text,
      incorrect_text = incorrect_text,
      prompt = prompt,
      force_correct_button_press = js_logical(force_correct_button_press),
      show_stim_with_feedback = js_logical(show_stim_with_feedback),
      show_feedback_on_timeout = js_logical(show_feedback_on_timeout),
      timeout_message = timeout_message,
      stimulus_duration = stimulus_duration,
      feedback_duration = feedback_duration,
      trial_duration = trial_duration,
      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}
