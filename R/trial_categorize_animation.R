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
#' @details In addition to the default data collected by all plugins, this
#' plugin collects the following data for each trial:
#'
#' The \code{stimulus} value is a JSON encoded representation of the array of
#' stimuli displayed in the trial. The \code{key_press}
#' value indicates which key the subject pressed. The value is the numeric key
#' code corresponding to the subject's response. The \code{rt} value is the
#' response time in milliseconds for the subject to make a response. The time is
#' measured from when the stimulus first appears on the screen until the subject's
#' response. The \code{correct} value is true if the subject got the correct answer,
#' false otherwise.
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
