library(jaysire)

instructions <- trial_instructions(
  pages = c(
    "Welcome! Use the arrow buttons to browse these instructions",
    "Your task is to decide if an equation like '2 + 2 = 4' is true or false",
    "You will respond by clicking a button",
    "Press the 'Next' button to begin!"
  ),
  show_clickable_nav = TRUE,
  post_trial_gap = 2000
)

trial1 <- trial_html_button_response(
  stimulus = "13 * 3 = 39",
  choices = c("true", "false"),
  post_trial_gap = 2000
)

trial2 <- trial_html_button_response(
  stimulus = "17 - 9 = 6",
  choices = c("true", "false")
)

all_trials <- timeline(instructions, trial1, trial2)

experiment(
  timeline = all_trials,
  path = "~/Desktop/mathstudy",
  on_finish = save_locally()
)

run_locally("~/Desktop/mathstudy")
