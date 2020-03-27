library(jaysire)



# welcome trial -----------------------------------------------------------

welcome_trial <- trial_instructions(
  pages = c(
    "Welcome to the experiment! Click on the buttons to navigate",
    "This experiment comes in two stages: the first shows images and the second is surveys",
    "If you are ready, click 'Next' to begin the experiment"
  ),
  show_clickable_nav = TRUE,
  post_trial_gap = 1000
)

# choice trials -----------------------------------------------------------

# define a fixation trial
fixation <- trial_html_keyboard_response(
  stimulus = '<div style="font-size:60px;">+</div>',
  choices = respond_no_key(),
  trial_duration = 500
)

# define a test trial
query <- trial_image_keyboard_response(
  stimulus = variable("stimulus"),
  choices = c("y", "n"),
  prompt = variable("prompt")
)

# define stimuli
flag_names <- c("bisexual", "transgender", "LGBT")
flag_files <- c("bisexual.svg", "transgender.svg", "rainbow.svg")

# testing procedure is a timeline of fixate/query events
choice_trials <- timeline(fixation, query) %>%
  add_variables(
    prompt = paste("is this the", flag_names, "flag? (y/n)"),
    stimulus = insert_resource(flag_files)) %>%
  add_parameters(randomize_order = TRUE, repetitions = 2)



# likert survey -----------------------------------------------------------

# define some response scale
confidence <- c("very unsure", "somewhat unsure", "somewhat sure", "very sure")
boredom <- c("not at all bored", "somewhat bored", "very bored")

# define a survey question
likert_confidence <- question_likert(
  prompt = "How confident were you in your answers?",
  labels = confidence,
  required = TRUE
)

# define a survey question
likert_bored <- question_likert(
  prompt = "How bored were you in your answers?",
  labels = boredom,
  required = FALSE
)

# compose a likert survey
survey_likert <- trial_survey_likert(
  questions = list(likert_confidence, likert_bored),
  preamble = "We have some questions"
)



# pick one survey ---------------------------------------------------------

# define a survey question
pickone_gender <- question_multi(
  prompt = "What gender are you?",
  options = c("male", "female", "non-binary", "other"),
  required = FALSE
)

# define a survey question
pickone_identity <- question_multi(
  prompt = "Do you identify as LGBTIQ?",
  options = c("yes", "no", "maybe"),
  required = FALSE
)

# define a multiple choice survey page
survey_pickone <- trial_survey_multi_choice(
  questions = list(pickone_gender, pickone_identity),
  preamble = "We have some more questions"
)



# pick some survey -----------------`---------------------------------------


# define a survey question
picksome_identities <- question_multi(
  prompt = "Select all that apply",
  options = c("lesbian", "gay", "bisexual", "transgender",
              "intersex", "queer", "other"),
  required = FALSE
)

# define a multi select page
survey_picksome <- trial_survey_multi_select(picksome_identities)



# free text survey --------------------------------------------------------

# define a free text page
survey_freetext <- question_text(prompt = "Anything to add?", rows = 2) %>%
  trial_survey_text()



# finish trial ------------------------------------------------------------


finish_trial <- trial_html_keyboard_response(
  stimulus = "All done! Press any key to finish",
  choices = any_key()
)




# organise into a structure -----------------------------------------------

all_events <- timeline(
  welcome_trial,
  choice_trials,
  survey_likert,
  survey_pickone,
  survey_picksome,
  survey_freetext,
  finish_trial
)




# write the experiment files ----------------------------------------------

resources <- build_resources(
  system.file("extdata", "img", package = "jaysire")
)

experiment(
  timeline = all_events,
  path = "~/Desktop/demo1",
  resources = resources,
  default_iti = 250,
  on_finish = save_locally(),
  preload_images = insert_resource(flag_files)
)


# run the experiment ------------------------------------------------------

if(FALSE) {
  run_locally(
    path = "~/Desktop/demo1",
    port = 8000
  )
}
