library(jaysire)



# welcome trial -----------------------------------------------------------

welcome_trial <- trial_instructions(
  pages = c(
    "Welcome to the experiment! Click on the buttons to navigate",
    "This experiment is intended to illustrate loops and conditions"
  ),
  show_clickable_nav = TRUE
)


# javascript is_wrong -----------------------------------------------------

criterion <- function(variable, operator, value, nback = 1) {
  code(paste0("function(){
      var data = jsPsych.data.get().last(", nback, ").values()[0];
      if(data.", variable, " ", operator, " ", value, "){
        return true;
      } else {
        return false;
      }
    }")
  )
}


# instruction check -------------------------------------------------------

check_trial <- trial_survey_multi_choice(
  preamble = "Choose the correct response to continue",
  questions = list(
    question_multi("Instruction check question 1", c("correct", "wrong")),
    question_multi("Instruction check question 2", c("correct", "wrong"))
  ),
  randomize_question_order = FALSE
)

required_answer <- '\'{"Q0":"correct","Q1":"correct"}\''

# show "failure screen" if incorrect --------------------------------------

check_fail <- trial_html_button_response(
  stimulus = "Sorry, at least one of your answers was incorrect",
  choices = "Return to instructions"
) %>%
  timeline() %>%
  with_condition(criterion("responses", "!=", required_answer))



# continue looping until criterion met ------------------------------------

looped_start <- timeline(welcome_trial, check_trial, check_fail) %>%
  with_loop(criterion("responses", "!=", required_answer)) # while loop

check_pass <- trial_html_button_response(
  stimulus = "Well done!",
  choices = "Begin experiment"
)



# global experiment structure ---------------------------------------------

all_events <- timeline(
  looped_start,
  check_pass
)

experiment(
  timeline = all_events,
  path = "~/Desktop/demo2",
  default_iti = 250,
  on_finish = code("xprmntr.save_locally")
)


# run the experiment ------------------------------------------------------

if(FALSE) {
  run_locally(
    path = "~/Desktop/demo2",
    port = 8000
  )
}

