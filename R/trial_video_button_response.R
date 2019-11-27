
#' Specify a video trial with button response
#'
#' @description The \code{trial_video_button_response} function is used to play
#' a video stimulus and collect a response using on screen buttons.
#'
#' @param sources Path(s) to the video file. Videos may be specified in multiple formats (e.g., .mp4, .ogg, .webm)
#' @param trial_ends_after_video If TRUE the trial will end as soon as the video finishes playing.
#' @param width The width of the video display in pixels (if NULL, natural width is used)
#' @param height The height of the video display in pixels (if NULL, natural height is used)
#' @param autoplay Does the video play automatically?
#' @param controls Should the video controls be shown?
#' @param start Time point in seconds to start video (NULL starts at the beginning)
#' @param stop Time point in seconds to stop video (NULL stops at the end)
#' @param rate What rate to play the video (1 = normal, <1 slower, >1 faster)
#'
#' @param choices Labels for the buttons. Each element of the character vector will generate a different button.
#' @param button_html A template of HTML for generating the button elements (see details)
#' @param margin_vertical Vertical margin of the buttons
#' @param margin_horizontal Horizontal margin of the buttons
#'
#' @param prompt A string (may contain HTML) that will be displayed below the stimulus, intended as a reminder about the actions to take (e.g., which key to press).
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
#' @details The \code{trial_video_button_response} function belongs to the "stimulus-response"
#' family of trials, all of which display a stimulus of a particular type (image,
#' audio, video or HTML) and collect responses using a particular mechanism
#' (button, keyboard or slider).
#' This one plays a video and records responses generated with a button click.
#'
#' Depending on parameter settings, the trial can end when the subject responds
#' (\code{response_ends_trial = TRUE}), or after a fixed amount of time
#' (specified using the \code{trial_duration} argument) has elapsed. The trial can
#' also be made to end automatically at the end of the video using the
#' \code{trial_ends_after_video} argument.
#'
#' The response buttons can be customized using HTML formatting, via the \code{button_html} argument.
#' This argument allows the user to specify an HTML used to generating the button elements. If this
#' argument is a vector of the same length as \code{choices} then the i-th element of \code{button_html}
#' will be used to define the i-th response button. If \code{button_html} is a single string then the
#' same template will be applied to every button. The templating is defined using a special string
#' "\%choice\%" that will be replaced by the corresponding element of the \code{choices} vector. By default
#' the jsPsych library creates an HTML button of class "jspsych-btn" and the styling is governed by the
#' corresponding CSS.
#'
#' The data recorded by this trial is as follows:
#'
#' \itemize{
#' \item The \code{rt} value is the response time in milliseconds taken for the
#' user to make a response. The time is measured from when the stimulus first
#' appears on the screen until the response.
#' \item The \code{button_pressed} variable is a numeric value indicating which
#' button was pressed. The first button in the choices array is recorded as
#' value 0, the second is value 1, and so on.
#' \item The \code{stimulus} variable records a JSON encoding of the sources array.
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
trial_video_button_response <- function(
  sources,
  trial_ends_after_video = FALSE, # If TRUE the trial will end as soon as the video finishes playing.
  width = NULL, # The width of the video display in pixels (if NULL, natural width is used)
  height = NULL, # The height of the video display in pixels (if NULL, natural height is used)
  autoplay = TRUE, #Does the video play automatically?
  controls = FALSE,
  start = NULL,
  stop = NULL,
  rate = 1,

  choices = c("button 0", "button 1", "button 2"),
  button_html = NULL,
  margin_vertical = "0px",
  margin_horizontal = "8px",

  prompt = NULL,
  trial_duration = NULL,
  response_ends_trial = TRUE,

  post_trial_gap = 0,  # start universals
  on_finish = NULL,
  on_load = NULL,
  data = NULL
) {
  drop_nulls(
    trial(
      type = "video-button-response",
      sources = sources,
      trial_ends_after_video = js_logical(trial_ends_after_video), # If TRUE the trial will end as soon as the video finishes playing.
      width = width, # The width of the video display in pixels (if NULL, natural width is used)
      height = height, # The height of the video display in pixels (if NULL, natural height is used)
      autoplay = js_logical(autoplay), #Does the video play automatically?
      controls = js_logical(controls),
      start = start,
      stop = stop,
      rate = rate,

      choices = choices,
      button_html = button_html,
      margin_vertical = margin_vertical,
      margin_horizontal = margin_horizontal,

      prompt = prompt,
      trial_duration = trial_duration,
      response_ends_trial = js_logical(response_ends_trial),

      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}
