var timeline = {
  "timeline": [
    {
      "type": ["survey-multi-choice"],
      "questions": [
        {
          "prompt": ["Please select the option that best matches your gender"],
          "options": ["Male", "Female", "Nonbinary", "Other", "Prefer not to say"],
          "horizontal": false,
          "required": false,
          "name": ["gender"]
        },
        {
          "prompt": ["Do you consider yourself to be LGBTIQ+?"],
          "options": ["Yes", "No", "Unsure", "Prefer not to say"],
          "horizontal": false,
          "required": false
        }
      ],
      "randomize_question_order": false,
      "preamble": ["Welcome! We'd like to ask some demographic questions"],
      "button_label": ["Continue"],
      "required_message": ["You must choose at least one response for this question"],
      "post_trial_gap": [0]
    },
    {
      "type": ["survey-multi-select"],
      "questions": [
        {
          "prompt": ["Which of the following R packages to you use?"],
          "options": ["ggplot2", "dplyr", "purrr", "janitor", "data.table", "testthat", "usethis", "tibble", "magrittr", "rlang", "babynames", "janeaustenr"],
          "horizontal": false,
          "required": false
        }
      ],
      "randomize_question_order": false,
      "preamble": [""],
      "button_label": ["Continue"],
      "required_message": ["You must choose at least one response for this question"],
      "post_trial_gap": [0]
    },
    {
      "type": ["survey-likert"],
      "questions": [
        {
          "prompt": ["Data wrangling?"],
          "labels": ["Very unconfident", "Somewhat unconfident", "Somewhat confident", "Very confident"],
          "required": [false]
        },
        {
          "prompt": ["Data visualisation?"],
          "labels": ["Very unconfident", "Somewhat unconfident", "Somewhat confident", "Very confident"],
          "required": [false]
        },
        {
          "prompt": ["Statistical modelling?"],
          "labels": ["Very unconfident", "Somewhat unconfident", "Somewhat confident", "Very confident"],
          "required": [false]
        },
        {
          "prompt": ["Designing experiments?"],
          "labels": ["Very unconfident", "Somewhat unconfident", "Somewhat confident", "Very confident"],
          "required": [false]
        },
        {
          "prompt": ["R markdown documents?"],
          "labels": ["Very unconfident", "Somewhat unconfident", "Somewhat confident", "Very confident"],
          "required": [false]
        }
      ],
      "randomize_question_order": false,
      "preamble": ["How confident in you R skills?"],
      "button_label": ["Continue"],
      "post_trial_gap": [0]
    },
    {
      "type": ["survey-text"],
      "questions": [
        {
          "prompt": ["Anything else you would like to mention?"],
          "placeholder": ["Type your answer here"],
          "rows": [8],
          "columns": [60]
        }
      ],
      "randomize_question_order": false,
      "preamble": [""],
      "button_label": ["Continue"],
      "post_trial_gap": [0]
    },
    {
      "type": ["html-keyboard-response"],
      "stimulus": ["All done! Click <a href='../../../articles/jaysire06.html'>here<\/a> to return to the vignette."],
      "choices": jsPsych.NO_KEY,
      "response_ends_trial": true,
      "post_trial_gap": [0]
    }
  ]
};

jsPsych.init(
{
  "timeline": [timeline]
}
);
