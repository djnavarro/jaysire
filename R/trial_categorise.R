
#' Create a categorization trial
#'
#' @param cue the cue type for the trial
#' @param response the response type for the question
#' @param prompt prompt to be displayed with the stimulus (can include HTML markup)
#' @param stimulus_duration how long to display stimulus in milliseconds? (default is to remain until response)
#' @param trial_duration how long to wait for response in milliseconds? (default is to wait indefinitely)
#' @param response_ends_trial does the trial end with response (default = TRUE) or continue until trial duration reached?
#' @param ... arguments to be passed to trial()
#'
#' @return A trial object
#' @export
trial_categorize <- function(
  cue,           # cue_image(), cue_html(), cue_animation(),
  response,      # response_key()
  prompt = NULL, # not intended to be part of the "stimulus"
  stimulus_duration = NULL,
  trial_duration = NULL,
  response_ends_trial = TRUE,
  ...
) {


  # feedback defined by
  key_answer # anim + html + image
  text_answer
  correct_text
  incorrect_text
  feedback_duration

  force_correct_button_press # html + image
  show_stim_with_feedback # html
  show_feedback_on_timeout


  # animation cue parameters
  frame_time
  sequence_reps
  allow_responses_before_complete



  # validate the cue and response classes
  require_cue(cue, c("image", "html", "animation"))
  require_response(response, c("key"))

  # read off the types
  cue_type <- cue$cue_type
  response_type <- response$response_type
  if(response_type == "key") response_type <- "keyboard"

  # construct the plugin type
  plugin_type <- paste("categorize", cue_type, sep = "-")

  # strip the unnecessary fields
  cue$cue_type <- NULL
  response$response_type <- NULL

  # trial level parameters
  trial_parameters <- list(
    type = plugin_type,
    prompt = prompt,
    stimulus_duration = stimulus_duration,
    trial_duration = trial_duration,
    response_ends_trial = response_ends_trial,
    ...
  )

  # return the trial object
  trial_data <- c(cue, response, trial_parameters)
  return(drop_nulls(trial_l(trial_data)))

}
