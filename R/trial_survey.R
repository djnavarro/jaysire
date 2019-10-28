

# define the trial_survey function ----------------------------------------


#' Create a survey trial
#'
#' @param questions A question or list of questions
#' @param preamble Text to appear above the questions
#' @param randomize_question_order Should order be randomised?
#' @param button_label Text for the continue button
#'
#' @return A trial object
#' @export
trial_survey <- function(
  questions, # either a single "question" or a list thereof
  preamble = "",
  randomize_question_order = FALSE,
  button_label = "Continue"
) {

  # if the user has passed a single question, wrap it in a list
  if(class(questions) == "xpt_question") {
    questions <- list(questions)
  }

  # check that every element in questions is an xpt_question
  question_classes <- purrr::map_chr(questions, ~ class(.x)[1])
  if(!all(question_classes == "xpt_question")) {
    stop("surveys must specify a single question() or a list of questions", call. = FALSE)
  }

  # check that every question is of the same question type, to satisfy the
  # constraints of jsPsych
  survey_type <- purrr::map_chr(questions, ~ .x$question_type)
  survey_type <- unique(survey_type)
  if(length(survey_type) != 1) {
    stop("surveys cannot include questions of different types", call. = FALSE)
  }

  # most survey types do not have a scale_width parameter, but it is
  # an optional parameter for Likert items; set it to NULL by default
  scale_width <- NULL

  # if the user has specified a Likert survey, check for a scale_width
  if(survey_type == "likert") {
    scale_width <- purrr::map_dbl(questions, ~ .x$scale_width %||% NA_real_)
    if(any(!is.na(scale_width))) {
      scale_width <- scale_width[!is.na(scale_width)]
      scale_width <- unique(scale_width)
      if(length(scale_width != 1)) {
        warning("Likert scales must have the same scale_width: using first value", call. = FALSE)
        scale_width <- scale_width[1]
      }
    }
  }

  # survey_type in xprmntr needs to be mapped to the corresponding
  # jsPsych plugin name; only difference is the separator char
  if(survey_type == "likert") plugin_type <- "survey-likert"
  if(survey_type == "pick_one") plugin_type <- "survey-multi-choice"
  if(survey_type == "pick_some") plugin_type <- "survey-multi-select"
  if(survey_type == "free_text") plugin_type <- "survey-text"

  # questions need to be tidied before passing to jsPsych
  questions <- purrr::map(questions, function(q) {
    q$question_type <- NULL
    drop_nulls(q)
  })

  # drop nulls to apply the jsPsych defaults and pass to trial()
  drop_nulls(
    trial(
      type = plugin_type,
      questions = list_to_jsarray(questions),
      randomize_question_order = as.logical(randomize_question_order),
      preamble = as.character(preamble),
      scale_width = scale_width, # always null (& dropped) if not Likert
      button_label = as.character(button_label)
    )
  )
}



# surveys have a special question() function ------------------------------


# display maps to "prompt" and must be an object of type display_text
# response must be "response_likert", "response_checkbox", "response_radio"
# or "response_text": question type defines the survey type!


#' Create a survey question
#'
#' @param cue the prompt for the question
#' @param response the response type for the question
#' @param required is a response to the question required?
#' @param name a convenient label for the question
#'
#' @return An object of class xpt_question
#' @export
question <- function(
  cue, # cue_text
  response, # response_likert, response_pickone, response_picksome, response_freetext
  required = FALSE,
  name = NULL
) {

  # validate the cue and response classes
  require_cue(cue, c("text"))
  require_response(response, c("likert", "pick_one", "pick_some", "free_text"))

  # use the response object to define the type of survey
  response_type <- response$response_type

  # likert questions
  if(response_type == "likert") {
    return(
      structure(
        list(
          question_type = "likert",
          prompt = cue$stimulus,
          labels = response$labels,
          required = required,
          name = name
        ),
        class = "xpt_question"
      )
    )
  }

  # choose_some questions will be displayed with check boxes
  # and map to the "multi_select" survey type
  if(response_type == "pick_some") {
    return(
      structure(
        list(
          question_type = "pick_some",
          prompt = cue$stimulus,
          options = response$options,
          required = required,
          horizontal = response$horizontal,
          name = name
        ),
        class = "xpt_question"
      )
    )
  }

  # choose_one questions will be displayed with radio buttons
  # and map to the "multi_choose" survey type
  if(response_type == "pick_one") {
    return(
      structure(
        list(
          question_type = "pick_one",
          prompt = cue$stimulus,
          options = response$options,
          required = required,
          horizontal = response$horizontal,
          name = name
        ),
        class = "xpt_question"
      )
    )
  }


  # textbox question
  if(response_type == "free_text") {
    return(
      structure(
        list(
          question_type = "free_text",
          prompt = cue$stimulus,
          placeholder = response$placeholder,
          required = required,
          rows = response$rows,
          columns = response$columns,
          name = name
        ),
        class = "xpt_question"
      )
    )
  }

  # if it's not these, throw an error
  stop(
    "'", response_type, "' is not a valid response type for survey questions.",
    call. = FALSE
  )

}



# questions have four response_ functions ---------------------------------

# a Likert scale is defined by an ordered set of labels
# and a scale_width parameter (in pixels)

#' Specify a Likert response
#'
#' @param labels character vector of response labels
#' @param scale_width width of the "slider" in pixels
#'
#' @return An object of class xpt_response
#' @export
response_likert <- function(labels, scale_width = NULL) {
  structure(
    list(
      response_type = "likert",
      labels = labels,
      scale_width = scale_width
    ),
    class = "xpt_response"
  )
}

# a "choose_some" response is a "choose as many as you like" trial
# and is defined by a (not meaningfully ordered) set of "options",
# and can be laid out horizontally or vertically

#' Specify a 'pick some' response
#'
#' @param options character vector of options
#' @param horizontal should check boxes be laid out horizontally?
#'
#' @return An object of class xpt_response
#' @export
response_picksome <- function(options, horizontal = FALSE) {
  structure(
    list(
      response_type = "pick_some",
      options = options,
      horizontal = horizontal
    ),
    class = "xpt_response"
  )
}

# "choose_one" is structurally the same as "choose_some" but is
# tagged as a different type to ensure the survey requires the user
# to select only one response

#' Specify a 'pick one' response
#'
#' @param options character vector of options
#' @param horizontal should radio buttons be laid out horizontally?
#'
#' @return An object of class xpt_response
#' @export
response_pickone <- function(options, horizontal = FALSE) {
  structure(
    list(
      response_type = "pick_one",
      options = options,
      horizontal = horizontal
    ),
    class = "xpt_response"
  )
}

# "text_free" allows the user to type text freely into a text box

#' Specify a free text response
#'
#' @param placeholder String specifying the placeholder text
#' @param rows Number of rows spanned by the text box
#' @param columns Number of columns spanned by the text box
#'
#' @return An object of class xpt_response
#' @export
response_freetext <- function(placeholder = "", rows = 1, columns = 40) {
  structure(
    list(
      response_type = "free_text",
      placeholder = placeholder,
      rows = rows,
      columns = columns
    ),
    class = "xpt_response"
  )
}
