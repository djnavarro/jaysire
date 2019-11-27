#' Specify a categorization trial with an animated stimulus
#'
#' @description The \code{trial_categorize_animation} function is used to display
#' a sequence of images at a fixed rate, collect a categorization response with the
#' keyboard, and provide feedback.
#'
#' @param stimuli Character vector of paths to image files
#' @param key_answer The numeric key code indicating the correct response
#' @param choices A character vector of keycodes (either numeric values or the characters themselves). Alternatively, respond_any_key() and respond_no_key() can be used
#' @param text_answer A label associated with the correct answer
#' @param correct_text Text to display when correct answer given ('\%ANS\%' substitutes text_answer)
#' @param incorrect_text Text to display when wrong answer given ('\%ANS\%' substitutes text_answer)
#'
#' @param frame_time How long to display each image, in milliseconds
#' @param sequence_reps How many times to show the entire sequence
#' @param allow_response_before_complete If TRUE the user can respond before the animation sequence finishes
#' @param prompt A string (may contain HTML) that will be displayed below the stimulus, intended as a reminder about the actions to take (e.g., which key to press).
#' @param feedback_duration How long to show the feedback, in milliseconds
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
#' @details The \code{trial_categorize_animation} function is used to show a sequence of images at a
#' specified frame rate. The subject responds by pressing a key. Feedback
#' indicating the correctness of the response is given.
#'
#' The data recorded by this trial is as follows:
#'
#' \itemize{
#' \item The \code{stimulus} value is a JSON encoded representation of the array of
#' stimuli displayed in the trial.
#' \item The \code{key_press} value indicates which key the subject pressed. The
#' value is the numeric key code corresponding to the subject's response.
#' \item The \code{rt} value is the response time in milliseconds for the subject
#' to make a response. The time is measured from when the stimulus first appears
#' on the screen until the subject's response.
#' \item The \code{correct} value is true if the subject got the correct answer,
#' false otherwise.
#' }
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
#' @seealso There are three types of categorization trial, corresponding to the
#' \code{\link{trial_categorize_animation}},
#' \code{\link{trial_categorize_html}} and
#' \code{\link{trial_categorize_image}} functions.
#'
#' @export
trial_categorize_animation <- function(
  stimuli,
  key_answer,
  choices = respond_any_key(),
  text_answer = "",
  correct_text = "Correct",
  incorrect_text = "Wrong",
  frame_time = 500,
  sequence_reps = 1,
  allow_response_before_complete = FALSE,
  prompt = NULL,
  feedback_duration = 2000,

  post_trial_gap = 0,  # start universals
  on_finish = NULL,
  on_load = NULL,
  data = NULL
) {
  drop_nulls(
    trial(
      type = "categorize-animation",
      stimuli = stimuli,
      key_answer = key_answer,
      choices = choices,
      text_answer = text_answer,
      correct_text = correct_text,
      incorrect_text = incorrect_text,
      frame_time = frame_time,
      sequence_reps = sequence_reps,
      allow_response_before_complete = js_logical(allow_response_before_complete),
      prompt = prompt,
      feedback_duration = feedback_duration,
      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}
