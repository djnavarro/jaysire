

#' Specify a survey page with multiple selection items
#'
#' @description The \code{trial_survey_multi_select} function is used to display a
#' survey page with one or more multiple selection questions
#'
#' @param questions A question or list of questions
#' @param preamble Text to appear above the questions
#' @param randomize_question_order Should order be randomised?
#' @param button_label Text for the continue button
#' @param required_message Message to display if required response is not given.
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
#' @details In addition to the default data collected by all plugins, this plugin
#' collects the following data for each trial. The \code{responses} value is a
#' an array containing all selected choices in JSON format for each question. The
#' encoded object will have a separate variable for the response to each question,
#' with the first question in the trial being recorded in Q0, the second in Q1, and
#' so on. The responses are recorded as the name of the option label. If the
#' \code{name} parameter is defined for the question, then the response will use
#' the value of \code{name} as the key for the response in the responses object.
#'
#' The \code{rt} value is the response time in milliseconds for the subject to make
#' a response. The time is measured from when the questions first appear on the
#' screen until the subject's response.
#'
#' The \code{question_order} value is a string in JSON format containing an array
#' with the order of questions. For example [2,0,1] would indicate that the first
#' question was trial.questions[2] (the third item in the questions parameter), the
#' second question was trial.questions[0], and the final question was trial.questions[1].
#'
#' @export
trial_survey_multi_select <- function(
  questions,
  preamble = "",
  randomize_question_order = FALSE,
  button_label = "Continue",
  required_message = 'You must choose at least one response for this question',

  post_trial_gap = 0,  # start universals
  on_finish = NULL,
  on_load = NULL,
  data = NULL
) {

  # if the user has passed a single question, wrap it in a list
  if(class(questions) == "jspr_multi") {
    questions <- list(questions)
  }

  # [add check to ensure questions are the correct type]

  # questions need to be tidied before passing to jsPsych
  questions <- purrr::map(questions, function(q) {
    unclass(drop_nulls(q))
  })

  # return object
  drop_nulls(
    trial(
      type = "survey-multi-select",
      questions = list_to_jsarray(questions),
      randomize_question_order = js_logical(randomize_question_order),
      preamble = as.character(preamble),
      button_label = as.character(button_label),
      required_message = required_message,

      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}

