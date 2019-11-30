
#' Specify an image trial with slider bar response
#'
#' @description The \code{trial_image_slider_response} function is used to display
#' an image stimulus and collect a response using a slider bar.
#'
#' @param stimulus The path of the image file to be displayed.
#' @param stimulus_height Set the height of the image in pixels. If NULL, then the image will display at its natural height.
#' @param stimulus_width Set the width of the image in pixels. If NULL, then the image will display at its natural width.
#' @param maintain_aspect_ratio If setting only the width or only the height and this parameter is TRUE, then the other dimension will be scaled to maintain the image's aspect ratio.
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
#'@return Functions with a \code{trial_} prefix always return a "trial" object.
#' A trial object is simply a list containing the input arguments, with
#' \code{NULL} elements removed. Logical values in the input (\code{TRUE} and
#' \code{FALSE}) are transformed to character vectors \code{"true"} and \code{"false"}
#' and are specified to be objects of class "json", ensuring that they will be
#' written to file as the javascript logicals, \code{true} and \code{false}.
#'
#'
#' @details The \code{trial_image_slider_response} function belongs to the "stimulus-response"
#' family of trials, all of which display a stimulus of a particular type (image,
#' audio, video or HTML) and collect responses using a particular mechanism
#' (button, keyboard or slider).
#' This one displays an image and records responses generated with a slider.
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
#'
#' The data recorded by this trial is as follows:
#'
#' \itemize{
#' \item The \code{rt} value is the response time in milliseconds taken for the
#' user to make a response. The time is measured from when the stimulus first
#' appears on the screen until the response.
#' \item The \code{response} is the numeric value of the slider bar.
#' \item The \code{stimulus} variable records the path to the image that was
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
trial_image_slider_response <- function(
  stimulus,
  stimulus_height = NULL,
  stimulus_width = NULL,
  maintain_aspect_ratio = TRUE,

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
      type = "image-slider-response",
      stimulus = stimulus,
      stimulus_height = stimulus_height,
      stimulus_width = stimulus_width,
      maintain_aspect_ratio = js_logical(maintain_aspect_ratio),

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
