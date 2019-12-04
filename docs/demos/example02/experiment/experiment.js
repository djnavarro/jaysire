var timeline = {
  "timeline": [
    {
      "type": ["instructions"],
      "pages": ["Welcome! Use the arrow buttons to browse these instructions", "Your task is to decide if an equation like '2 + 2 = 4' is true or false", "You will respond by clicking a button", "Press the 'Next' button to begin!"],
      "key_forward": [39],
      "key_backward": [37],
      "allow_backward": true,
      "allow_keys": true,
      "show_clickable_nav": true,
      "button_label_previous": ["Previous"],
      "button_label_next": ["Next"],
      "post_trial_gap": [1000]
    },
    {
      "timeline": [
        {
          "type": ["html-button-response"],
          "stimulus": jsPsych.timelineVariable('stimulus'),
          "choices": ["true", "false"],
          "margin_vertical": ["0px"],
          "margin_horizontal": ["8px"],
          "response_ends_trial": true,
          "post_trial_gap": [1000]
        }
      ],
      "timeline_variables": [
        {
          "stimulus": ["13 + 23 = 36"]
        },
        {
          "stimulus": ["17 - 9 = 6"]
        },
        {
          "stimulus": ["125 / 5 = 25"]
        },
        {
          "stimulus": ["2 - 4 = 6"]
        },
        {
          "stimulus": ["12 + 39 = 43"]
        },
        {
          "stimulus": ["4 * 23 = 92"]
        }
      ],
      "randomize_order": [true],
      "repetitions": [2]
    },
    {
      "type": ["html-keyboard-response"],
      "stimulus": ["All done! Click <a href='../../../articles/jaysire02.html'>here<\/a> to return to the vignette."],
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
