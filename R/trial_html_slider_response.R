
#' Specify an HTML trial with slider bar response
#'
#' @description The \code{trial_html_slider_response} function is used to display
#' an HTML stimulus and collect a response using a slider bar.
#'
#' @param stimulus The HTML content to be displayed.
#'
#' @param labels Labels displayed at equidistant locations on the slider.
#' @param button_label Label placed on the "continue" button
#' @param min Minimum value of the slider
#' @param max Maximum value of the slider
#' @param start Initial value of the slider
#' @param step Step size of the slider
#' @param slider_width Horizontal width of the slider (defaults to display width)
#' @param require_movement Does the user need to move the slider before clicking the continue button?
#'
#' @param prompt A string (may contain HTML) that will be displayed below the stimulus, intended as a reminder about the actions to take (e.g., which key to press).
#' @param stimulus_duration How long to show the stimulus, in milliseconds. If NULL, then the stimulus will be shown until the subject makes a response
#' @param trial_duration How long to wait for a response before ending trial in milliseconds. If NULL, the trial will wait indefinitely. If no response is made before the deadline is reached, the response will be recorded as NULL.
#' @param response_ends_trial If TRUE, then the trial will end when a response is made (or the trial_duration expires). If FALSE, the trial continues until the deadline expires.
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
#' @details The \code{trial_html_slider_response} function belongs to the "stimulus-response"
#' family of trials, all of which display a stimulus of a particular type (image,
#' audio, video or HTML) and collect responses using a particular mechanism
#' (button, keyboard or slider).
#' This one displays HTML and records responses generated with a slider.
#'
#' \subsection{Stimulus display}{
#' The \code{stimulus} argument is a string specifying the text to be displayed
#' as the stimulus. It can include HTML markup, meaning that it can be used to
#' any stimulus that can be specified using HTML. It remains on screen for a
#' length of time corresponding to the \code{stimulus_duration} parameter in
#' milliseconds (or indefinitely if the parameter is \code{NULL}).
#' }
#'
#' \subsection{Response mechanism}{
#' Participant responses for this trial type are collected using a slider bar
#' that the participant can move using the mouse. Once the participant is happy
#' with this positioning they can click a button at the bottom of the page to
#' move on to the next trial. This response method can be customised in several
#' ways depending on the following arguments:
#'
#' \itemize{
#' \item The \code{min} and \code{max} arguments are numeric values that specify the
#' minimum value (leftmost point on the slider) and the maximum value (rightmost point
#' on the slider) that a participant can respond with.
#'
#' \item The \code{start} parameter is a numeric value that indicates where the value
#' of the the slider is initially position. By default this is set to the middle of
#' the scale, but there are many cases where it may be sensible to have the slider
#' bar start at one end of the scale.
#'
#' \item The movement of the slider is discretised, and the granularity of this
#' movement can be customised using the \code{step} parameter. This should be a
#' numeric value that specifies the smallest possible increment that the participant
#' can move the slider in either direction.
#'
#' \item The text labels displayed below the slider bar can also be customised by
#' specifying the \code{labels} parameter. This argument should be a character vector
#' that contains the labels to be displaed. Labels will be displayed at equally spaced
#' intervals along the slider, though it is possible to include blank labels to create
#' the impression of unequal spacing if that is required.
#'
#' \item The \code{slider_width} controls the horizontal width of the slider bar:
#' the default value of \code{NULL} creates a slider that occupies 100\% of the width of
#' the jsPsych display. Note that this may not be 100\% of the screen width.
#'
#'\item To ensure that participants do engage with the slider, it is possible to set
#' \code{require_movement = TRUE} which forces the participant to move the slider
#' at least once in order to be permitted to move onto the next trial.
#'
#' \item The \code{button_label} argument specifies the text displayed on the button that
#' participants click to move to the next trial.
#' }
#' }
#'
#' \subsection{Other behaviour}{
#' As is the case for most \code{trial_} functions there is a \code{prompt} argument,
#' a string that specifies additional text that is displayed on screen during the
#' trial. The value of \code{prompt} can contain HTML markup, allowing it to be
#' used quite flexibly if needed.
#'
#' Depending on parameter settings, the trial can end when the subject responds
#' (\code{response_ends_trial = TRUE}), or after a fixed amount of time
#' (specified using the \code{trial_duration} argument) has elapsed. The length
#' of time that the stimulus remains visible can also be customized using the
#' (\code{stimulus_duration}) argument.
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
#' \item The \code{rt} value is the response time in milliseconds taken for the
#' user to make a response. The time is measured from when the stimulus first
#' appears on the screen until the response.
#' \item The \code{response} is the numeric value of the slider bar.
#' \item The \code{stimulus} variable records the HTML content that was
#' displayed on this trial.
#'}
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
#' @seealso Within the "stimulus-response" family of trials, there are four types of
#' stimuli (image, audio, video and HTML) and three types of response options
#' (button, keyboard, slider). The corresponding functions are
#' \code{\link{trial_image_button_response}},
#' \code{\link{trial_image_keyboard_response}},
#' \code{\link{trial_image_slider_response}},
#' \code{\link{trial_audio_button_response}},
#' \code{\link{trial_audio_keyboard_response}},
#' \code{\link{trial_audio_slider_response}},
#' \code{\link{trial_video_button_response}},
#' \code{\link{trial_video_keyboard_response}},
#' \code{\link{trial_video_slider_response}},
#' \code{\link{trial_html_button_response}},
#' \code{\link{trial_html_keyboard_response}} and
#' \code{\link{trial_html_slider_response}}.
#'
#' @export
trial_html_slider_response <- function(
  stimulus,

  labels = c("0%", "25%", "50%", "75%", "100%"),
  button_label = "Continue",
  min = 0,
  max = 100,
  start = 50,
  step = 1,
  slider_width = NULL,
  require_movement = FALSE,

  prompt = NULL,
  stimulus_duration = NULL,
  trial_duration = NULL,
  response_ends_trial = TRUE,

  post_trial_gap = 0,  # start universals
  on_finish = NULL,
  on_load = NULL,
  data = NULL
) {
  drop_nulls(
    trial(
      type = "html-slider-response",
      stimulus = stimulus,

      labels = labels,
      button_label = button_label,
      min = min,
      max = max,
      start = start,
      step = step,
      slider_width = slider_width,
      require_movement = js_logical(require_movement),

      prompt = prompt,
      stimulus_duration = stimulus_duration,
      trial_duration = trial_duration,
      response_ends_trial = js_logical(response_ends_trial),

      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}
