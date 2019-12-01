
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
#' An animation trial displays a sequence of images at a fixed frame rate and the sequence
#' can be looped a specified number of times. The participant is free to respond at any
#' point during the animation, and the time of the response is recorded.
#'
#' \subsection{Stimulus display}{
#'
#' The only required argument is \code{stimulus}, which should be a vector of
#' paths to the image files, one per frame. The file paths should refer to
#' the locations of the image files at the time the experiment is *deployed*,
#' so it is often convenient to use the \code{\link{insert_resource}}
#' function to construct these file paths automatically. The images will be
#' displayed in the order that they appear in the \code{stimulus} vector.
#'
#' The behaviour of an animation trial can be customised in various ways. The
#' \code{frame_time} parameter specifies the length of time (in milliseconds) that
#' each image stays on screen, and the \code{frame_isi} parameter controls the
#' inter-stimulus interval (that is, the gap between successive images) during
#' which a blank screen is shown. The \code{sequence_reps} argument specifies the
#' number of times the sequence repeats.
#' }
#'
#'
#' \subsection{Response mechanism}{
#'
#' Because animation trials typically require precise timing, they are designed
#' to accept key press responses only, and \code{choices} argument is used to
#' control which keys will register
#' a valid response. The default value \code{choices = \link{respond_any_key}()}
#' is to allow the participant to press any key to register their response.
#' Alternatively it is possible to set \code{choices = \link{respond_no_key}()},
#' which prevents all keys from registering a response: this can be useful if
#' the trial is designed to run for a fixed duration, regardless of what the
#' participant presses.
#'
#' In many situations it is preferable to require the participant to respond
#' using specific keys (e.g., for a binary choice tasks, it may be desirable to
#' require participants to press F for one response or J for the other). This
#' can be achieved in two ways. One possibility is to use a character vector
#' as input (e.g., \code{choices = c("f","j")}). The other is to use the
#' numeric code that specifies the desired key in javascript, which in this
#' case would be \code{choices = c(70, 74)}. To make it a little easier to
#' work with numeric codes, the jaysire package includes the
#' \code{\link{keycode}()} function to make it easier to convert from one format
#' to the other.
#' }
#'
#' \subsection{Other behaviour}{
#'
#' The \code{prompt} argument is used to specify text that remains on screen while
#' the animation displays. The intended use is to remind participants of the
#' valid response keys, but it allows HTML markup to be included and so can be
#' used for more general purposes.
#'
#' Like all functions in the \code{trial_} family it contains four additional
#' arguments:
#'
#' \itemize{
#' \item The \code{post_trial_gap} argument is a numeric value specifying the
#' length of the pause between the current trial ending and the next one
#' beginning. This parameter overrides any default values defined using the
#' \code{\link{build_experiment}} function, and a blank screen is displayed
#' during this gap period.
#'
#' \item The \code{on_load} and \code{on_finish} arguments can be used to
#' specify javascript functions that will execute before the trial begins or
#' after it ends. The javascript code can be written manually and inserted *as*
#' javascript by using the \code{\link{insert_javascript}} function. However,
#' the \code{fn_} family of functions supplies a variety of functions that may
#' be useful in many cases.
#'
#' \item The \code{data} argument can be used to insert custom data values into
#' the jsPsych data storage for this trial
#' }
#' }
#'
#' \subsection{Data}{
#'
#' When this function is called from R it returns the trial object that will
#' later be inserted into the experiment when \code{\link{build_experiment}}
#' is called. However, when the trial runs as part of the experiment it returns
#' values that are recorded in the jsPsych data store and eventually form part
#' of the data set for the experiment.
#'
#' The data recorded by this trial is as follows:
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


