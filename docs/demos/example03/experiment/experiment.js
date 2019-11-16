var timeline = {
  "timeline": [
    {
      "timeline": [
        {
          "type": ["image-button-response"],
          "stimulus": jsPsych.timelineVariable('stimulus'),
          "stimulus_height": [400],
          "stimulus_width": [400],
          "maintain_aspect_ratio": [true],
          "choices": ["there are more red dots", "there are more blue dots"],
          "margin_vertical": ["0px"],
          "margin_horizontal": ["8px"],
          "response_ends_trial": [true],
          "post_trial_gap": [1000]
        }
      ],
      "timeline_variables": [
        {
          "stimulus": ["resource/image/stimulus1.png"]
        },
        {
          "stimulus": ["resource/image/stimulus2.png"]
        },
        {
          "stimulus": ["resource/image/stimulus3.png"]
        },
        {
          "stimulus": ["resource/image/stimulus4.png"]
        },
        {
          "stimulus": ["resource/image/stimulus5.png"]
        },
        {
          "stimulus": ["resource/image/stimulus6.png"]
        },
        {
          "stimulus": ["resource/image/stimulus7.png"]
        },
        {
          "stimulus": ["resource/image/stimulus8.png"]
        }
      ],
      "randomize_order": [true]
    },
    {
      "type": ["html-keyboard-response"],
      "stimulus": ["All done! Click <a href='../../../articles/jaysire03.html'>here<\/a> to return to the vignette."],
      "choices": jsPsych.NO_KEY,
      "response_ends_trial": [true],
      "post_trial_gap": [0]
    }
  ]
};

jsPsych.init(
{
  "timeline": [timeline]
}
);
