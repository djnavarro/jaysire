
#' Displays a sequence of images at a fixed rate
#'
#' @param stimuli A vector of paths to the image files
#' @param frame_time How long to display each image, in milliseconds
#' @param frame_isi How long is the gap between images, in milliseconds
#' @param sequence_reps How many times to repeat the sequence
#' @param choices A character vector of keycodes (either numeric values or the characters themselves). Alternatively, any_key() and no_key() can be used
#' @param prompt A string (may contain HTML) that will be displayed below the stimulus, intended as a reminder about the actions to take (e.g., which key to press).
#'
#' @param post_trial_gap  The gap in milliseconds between the current trial and the next trial. If NULL, there will be no gap.
#' @param on_finish A javascript callback function to execute when the trial finishes
#' @param on_load A javascript callback function to execute when the trial begins, before any loading has occurred
#' @param data An object containing additional data to store for the trial
#'
#' @details In addition to the default data collected by all plugins, this plugin
#' collects the following data for each trial.
#'
#' The \code{animation_sequence} value is an array encoded in JSON format. Each
#' element of the array is an object that represents a stimulus in the animation
#' sequence. Each object has a stimulus property, which is the image that was
#' displayed, and a time property, which is the time in ms, measured from when
#' the sequence began, that the stimulus was displayed.
#'
#' The \code{responses} value is an array encoded in JSON format. Each element
#' of the array is an object representing a response given by the subject. Each
#' object has a stimulus property, indicating which image was displayed when the
#' key was pressed, an rt property, indicating the time of the key press relative
#' to the start of the animation, and a key_press property, indicating which key
#' was pressed.
#'
#' @export
trial_animation <- function(
  stimuli,
  frame_time = 250,
  frame_isi = 0,
  sequence_reps = 1,
  choices = any_key(),

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

      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}


