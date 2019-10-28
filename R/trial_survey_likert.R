
#' A survey page with Likert scale items
#'
#' @param questions A question or list of questions
#' @param preamble Text to appear above the questions
#' @param scale_width Width of the scale in pixels (NULL is the display width)
#' @param randomize_question_order Should order be randomised?
#' @param button_label Text for the continue button
#'
#' @param post_trial_gap  The gap in milliseconds between the current trial and the next trial. If NULL, there will be no gap.
#' @param on_finish A javascript callback function to execute when the trial finishes
#' @param on_load A javascript callback function to execute when the trial begins, before any loading has occurred
#' @param data An object containing additional data to store for the trial
#'
#' @export
trial_survey_likert <- function(
  questions,
  preamble = "",
  scale_width = NULL,
  randomize_question_order = FALSE,
  button_label = "Continue",

  post_trial_gap = 0,  # start universals
  on_finish = NULL,
  on_load = NULL,
  data = NULL
) {

  # if the user has passed a single question, wrap it in a list
  if(class(questions) == "likert") {
    questions <- list(questions)
  }

  # [add check to ensure questions are the correct type]

  # return object
  drop_nulls(
    trial(
      type = "survey-likert",
      questions = list_to_jsarray(questions),
      randomize_question_order = as.logical(randomize_question_order),
      preamble = as.character(preamble),
      scale_width = scale_width,
      button_label = as.character(button_label),

      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}


#' Create a Likert question
#'
#' @param prompt the prompt for the question
#' @param labels the labels on the Likert scale
#' @param required is a response to the question required?
#' @param name a convenient label for the question
#'
#' @export
question_likert <- function(
  prompt,
  labels,
  required = FALSE,
  name = NULL
) {
  q <- drop_nulls(
    list(
      prompt = prompt,
      labels = labels,
      required = required,
      name = name
    )
  )
  return(structure(q, class = "likert"))
}
