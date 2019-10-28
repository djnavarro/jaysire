
#' A survey page with free text items
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
#' @details In addition to the default data collected by all plugins, this plugin
#' collects the following data for each trial. The \code{responses} value is a
#' string in JSON format containing the response for each question. The encoded
#' object will have a separate variable for the response to each question, with
#' the first question in the trial being recorded in Q0, the second in Q1, and
#' so on. Each response is a string containing whatever the subject typed into
#' the associated text box. If the name parameter is defined for the question,
#' then the response will use the value of name as the key for the response in
#' the responses object.
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
trial_survey_text <- function(
  questions,
  preamble = "",
  randomize_question_order = FALSE,
  button_label = "Continue",

  post_trial_gap = 0,  # start universals
  on_finish = NULL,
  on_load = NULL,
  data = NULL
) {

  # if the user has passed a single question, wrap it in a list
  if(class(questions) == "jspr_freetext") {
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
      type = "survey-text",
      questions = list_to_jsarray(questions),
      randomize_question_order = as.logical(randomize_question_order),
      preamble = as.character(preamble),
      button_label = as.character(button_label),

      post_trial_gap = post_trial_gap,
      on_finish = on_finish,
      on_load = on_load,
      data = data
    )
  )
}


#' Create a free text response question
#'
#' @param prompt The prompt for the question
#' @param placeholder A string specifying the placeholder text
#' @param rows Number of rows spanned by the text box
#' @param columns Number of columns spanned by the text box
#' @param name A convenient label for the question
#'
#' @export
question_text <- function(
  prompt,
  placeholder = "",
  rows = 1,
  columns = 40,
  name = NULL
) {
  q <- drop_nulls(
    list(
      prompt = prompt,
      placeholder = placeholder,
      rows = rows,
      columns = columns,
      name = name
    )
  )
  return(structure(q, class = "jspr_freetext"))
}



