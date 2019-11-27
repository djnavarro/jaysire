
#' Specify an animation trial
#'
#' @description The \code{trial_animation} function is used to display a
#'sequence of images at a fixed rate.
#'
#' @param stimuli A vector of paths to the image files
#' @param frame_time How long to display each image, in milliseconds
#' @param frame_isi How long is the gap between images, in milliseconds
#' @param sequence_reps How many times to repeat the sequence
#' @param choices A character vector of keycodes (either numeric values or the characters themselves). Alternatively, respond_any_key() and respond_no_key() can be used
#' @param prompt A string (may contain HTML) that will be displayed below the stimulus, intended as a reminder about the actions to take (e.g., which key to press).
#'
#' @param post_trial_gap  The gap in milliseconds between the current trial and the next trial. If NULL, there will be no gap.
#' @param on_finish A javascript callback function to execute when the trial finishes
#' @param on_load A javascript callback function to execute when the trial begins, before any loading has occurred
#' @param data An object containing additional data to store for the trial
#'
#' @return Functions with a \code{trial_} prefix always return a "trial" object.
#' A trial object is simply a list containing the input arguments, with
#' \code{NULL} elements removed. Logical values in the input (\code{TRUE} and
#' \code{FALSE}) are transformed to character vectors \code{"true"} and \code{"false"}
#' and are specified to be objects of class "json", ensuring that they will be
#' written to file as the javascript logicals, \code{true} and \code{false}.
#'
#' @details This function is used to specify an "animation" trial in a jsPsych experiment.
#' An animation trial displays a sequence of images at a fixed frame rate, and the sequence
#' can be looped a specified number of times. The participant is free to respond at any
#' point during the animation, and the time of the response is recorded.
#'
#' The data recorded by an animation trial is as follows:
#'
#' \itemize{
#' \item The \code{animation_sequence} value is an array encoded in JSON format. Each
#' element of the array is an object that represents a stimulus in the animation
#' sequence. Each object has a stimulus property, which is the image that was
#' displayed, and a time property, which is the time in ms, measured from when
#' the sequence began, that the stimulus was displayed.
#' \item The \code{responses} value is an array encoded in JSON format. Each element
#' of the array is an object representing a response given by the subject. Each
#' object has a stimulus property, indicating which image was displayed when the
#' key was pressed, an rt property, indicating the time of the key press relative
#' to the start of the animation, and a key_press property, indicating which key
#' was pressed.
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
#' @export
trial_animation <- function(
  stimuli,
  frame_time = 250,
  frame_isi = 0,
  sequence_reps = 1,
  choices = respond_any_key(),
  prompt = NULL,
  post_trial_gap = 0,  # start universals
  on_finish = NULL,
  on_load = NULL,
  data = NULL
) {
  # return object
  drop_nulls(
    trial(
      type = "animation",
      stimuli = stimuli,
      frame_time = frame_time,
      frame_isi = frame_isi,
      sequence_reps = sequence_reps,
      choices = choices,
      prompt = prompt,

      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}


