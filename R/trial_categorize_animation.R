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
#' \subsection{Stimulus display}{
#'
#' The \code{stimulus} argument should be a vector of
#' paths to the image files, one per frame. The file paths should refer to
#' the locations of the image files at the time the experiment is *deployed*,
#' so it is often convenient to use the \code{\link{insert_resource}}
#' function to construct these file paths automatically. The images will be
#' displayed in the order that they appear in the \code{stimulus} vector.
#'
#' The behaviour of an animation trial can be customised in various ways. The
#' \code{frame_time} parameter specifies the length of time (in milliseconds) that
#' each image stays on screen. The \code{sequence_reps} argument specifies the
#' number of times the sequence repeats.
#' }
#'
#' \subsection{Response mechanism}{
#' For this kind of trial, participants can make a response by pressing a key,
#' and the \code{choices} argument is used to control which keys will register
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
#'
#' If \code{allow_response_before_correct = TRUE} the participant is permitted
#' to make a response before the stimulus display completes.
#' }
#'
#' \subsection{Feedback}{
#'
#' In a categorisation trial, there is always presumed to be a "correct" response
#' for any given stimulus, and the participant is presented with feedback after
#' the response is given. This feedback can be customised in several ways:
#'
#' \itemize{
#' \item The \code{key_answer} argument specifies the numeric \code{\link{keycode}}
#' that corresponds to the correct response for the current trial.
#' \item The \code{correct_text} and \code{incorrect_text} arguments are used to
#' customise the feedback text that is presented to the participant after a
#' response is given. In both cases, there is a special value \code{"\%ANS\%"} that
#' can be used, and will be substituted with the value of \code{text_answer}.
#' For example if we set \code{text_answer = "WUG"}, we could then set
#' \code{correct_text = "Correct! This is a \%ANS\%"} and
#' \code{incorrect_text = "Wrong. This is a \%ANS\%"}. This functionality can be
#' particularly useful if the values of \code{text_answer} and \code{stimulus}
#' are specified using timeline variables (see \code{\link{insert_variable}()} and
#' \code{\link{add_variables}()}).
#' \item The \code{feedback_duration} argument specifies the length of time the
#' feedback is displayed, in milliseconds.
#' }
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
