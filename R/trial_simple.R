

#' Create a simple trial
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
trial_simple <- function(
  cue,           # cue_image(), cue_html(), cue_audio(), cue_video()
  response,      # response_slider(), response_button(), response_key()
  prompt = NULL, # not intended to be part of the "stimulus"
  stimulus_duration = NULL,
  trial_duration = NULL,
  response_ends_trial = TRUE,
  ...
) {

  # validate the cue and response classes
  require_cue(cue, c("image", "html", "audio", "video"))
  require_response(response, c("slider", "button", "key"))

  # read off the types
  cue_type <- cue$cue_type
  response_type <- response$response_type
  if(response_type == "key") response_type <- "keyboard"

  # construct the plugin type
  plugin_type <- paste(cue_type, response_type, "response", sep = "-")

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



# simple cue types --------------------------------------------------------


# So far:
#   - cue_image
#   - cue_html
#   - cue_text

# Need to add:
#   - cue_audio
#   - cue_video
#   - cue_animation

#' Define an image cue
#'
#' @param stimulus Image file, specified using the resource() function
#' @param stimulus_height Image height in pixels (defaults to natural height)
#' @param stimulus_width Image width in pixels (defaults to natural width)
#' @param maintain_aspect_ratio Maintain aspect ratio (default = TRUE)
#'
#' @return An object of class xpt_cue
#' @export
cue_image <- function(
  stimulus,
  stimulus_height = NULL,
  stimulus_width = NULL,
  maintain_aspect_ratio = TRUE
){
  structure(
    list(
      cue_type = "image",
      stimulus = stimulus,
      stimulus_height = stimulus_height,
      stimulus_width = stimulus_width,
      maintain_aspect_ratio = maintain_aspect_ratio
    ),
    class = "xpt_cue"
  )
}

#' Define an HTML cue
#'
#' @param stimulus HTML
#'
#' @return An object of class xpt_cue
#' @export
cue_html <- function(stimulus){
  structure(
    list(
      cue_type = "html",
      stimulus = stimulus
    ),
    class = "xpt_cue"
  )
}

#' Define a text cue
#'
#' @param stimulus text
#'
#' @return An object of class xpt_cue
#' @export
cue_text <- function(stimulus){
  structure(
    list(
      cue_type = "text",
      stimulus = stimulus
    ),
    class = "xpt_cue"
  )
}



# simple response types ---------------------------------------------------


#  - response_slider
#  - response_button
#  - response_key

#' Specify a slider response
#'
#' @param labels Character vector of labels, to be spaced equally along slider
#' @param button_label Text displayed on button at the end (default = "Continue")
#' @param min Minimum value of the slider (default = 0)
#' @param max Maximum value of the slider (default = 100)
#' @param start Starting value of the slider (default = 50)
#' @param step Smallest increment of slider movement (default = 1)
#' @param slider_width Horizontal width of slider (defaults to max width)
#' @param require_movement Does user need to move the slider to continue? (default = FALSE)
#'
#' @return An object of class xpt_response
#' @export
response_slider <- function(
  labels = NULL,
  button_label = "Continue",
  min = 0,
  max = 100,
  start = 50,
  step = 1,
  slider_width = NULL,
  require_movement = FALSE
) {
  structure(
    list(
      response_type = "slider",
      labels = labels,
      button_label = button_label,
      min = min,
      max = max,
      start = start,
      step = step,
      slider_width = slider_width,
      require_movement = require_movement
    ),
    class = "xpt_response"
  )
}

#' Specify a button response
#'
#' @param choices Character vector with labels for the buttons
#' @param button_html HTML templay specifying the buttons (defaults to jsPsych default)
#' @param margin_vertical Vertical margin of the buttons (default "0px")
#' @param margin_horizontal Horizontal margin of the buttons (default "8px")
#'
#' @return An object of class xpt_response
#' @export
response_button <- function(
  choices,
  button_html = NULL,
  margin_vertical = "0px",
  margin_horizontal = "8px"
) {
  structure(
    list(
      response_type = "button",
      choices = choices,
      button_html = button_html,
      margin_vertical = margin_vertical,
      margin_horizontal = margin_horizontal
    ),
    class = "xpt_response"
  )
}


#' Specify a keyboard response
#'
#' @param ... Either single string "any" (default), "none", or characters specifying keys
#'
#' @return An object of class xpt_response
#' @export
response_key <- function(...) {

  # convenient constructor function
  make_keys <- function(choices) {
    structure(
      list(
        response_type = "key",
        choices = choices
      ),
      class = "xpt_response"
    )
  }

  # capture the input, and initialise choices as missing
  dots <- list(...)

  # if the user specifies nothing, any key is allowed
  if(length(dots)==0) {
    return(make_keys(any_key()))
  }

  # if the user specifies "any", any key is allowed
  if(length(dots)==1 & dots[[1]] == "any") {
    return(make_keys(any_key()))
  }

  # if the user specifies "none", no key is allowed
  if(length(dots)==1 & dots[[1]] == "none") {
    return(make_keys(no_key()))
  }

  # otherwise...
  choices <- unlist(dots) # TODO: validate input!

  # return
  return(make_keys(choices))
}




