library(jaysire)



# welcome trial -----------------------------------------------------------

welcome_trial <- trial_instructions(
  pages = c(
    "Welcome to the experiment! Click on the buttons to navigate",
    "This experiment is intended to illustrate loops and conditions"
  ),
  show_clickable_nav = TRUE
)


# instruction check -------------------------------------------------------

check_trial <- trial_survey_multi_choice(
  preamble = "Choose the correct response to continue",
  questions = list(
    question_multi("Instruction check question 1", c("correct", "wrong")),
    question_multi("Instruction check question 2", c("correct", "wrong"))
  ),
  randomize_question_order = FALSE
)

check_pass <- trial_html_button_response(
  stimulus = "Well done!",
  choices = "Begin experiment"
)

check_fail <- trial_html_button_response(
  stimulus = "Sorry, at least one of your answers was incorrect",
  choices = "Return to instructions"
)


# flow control -----------------------------------------------------------

required_answer <- '{"Q0":"correct","Q1":"correct"}'

check_fail <- check_fail %>%
  timeline() %>%
  display_if(data_condition(responses != !!required_answer))

looped_start <- timeline(welcome_trial, check_trial, check_fail) %>%
  display_while(data_condition(responses != !!required_answer))



# global experiment structure ---------------------------------------------

experiment(
  timeline = timeline(looped_start, check_pass),
  path = "~/Desktop/demo2",
  default_iti = 250,
  on_finish = save_locally()
)


# run the experiment ------------------------------------------------------

if(FALSE) {
  run_locally(
    path = "~/Desktop/demo2",
    port = 8000
  )
}

