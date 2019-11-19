var timeline = {
  "timeline": [
    {
      "timeline": [
        {
          "type": ["image-keyboard-response"],
          "stimulus": ["resource/image/heart.png"],
          "stimulus_height": [400],
          "stimulus_width": [400],
          "maintain_aspect_ratio": true,
          "choices": jsPsych.ANY_KEY,
          "prompt": ["<br>You will be asked judge the pleasantness of this image. Press any key to continue"],
          "response_ends_trial": true,
          "post_trial_gap": [0]
        },
        {
          "timeline": [
            {
              "type": ["image-button-response"],
              "stimulus": ["resource/image/heart.png"],
              "stimulus_height": [400],
              "stimulus_width": [400],
              "maintain_aspect_ratio": true,
              "choices": ["Unpleasant", "Neutral", "Pleasant"],
              "margin_vertical": ["0px"],
              "margin_horizontal": ["8px"],
              "response_ends_trial": true,
              "post_trial_gap": [0]
            },
            {
              "type": ["image-slider-response"],
              "stimulus": ["resource/image/heart.png"],
              "stimulus_height": [400],
              "stimulus_width": [400],
              "maintain_aspect_ratio": true,
              "labels": ["Most unpleasant", "Neutral", "Most Pleasant"],
              "button_label": ["Continue"],
              "min": [0],
              "max": [100],
              "start": [50],
              "step": [1],
              "require_movement": false,
              "response_ends_trial": true,
              "post_trial_gap": [0]
            }
          ],
          "randomize_order": [true]
        }
      ]
    },
    {
      "type": ["html-keyboard-response"],
      "stimulus": ["All done! Click <a href='../../../articles/jaysire05.html'>here<\/a> to return to the vignette."],
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
