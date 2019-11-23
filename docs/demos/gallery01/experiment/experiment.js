var timeline = {
  "timeline": [
    {
      "type": ["html-keyboard-response"],
      "stimulus": ["Welcome to the experiment! Press any key to begin"],
      "choices": jsPsych.ANY_KEY,
      "response_ends_trial": true,
      "post_trial_gap": [0]
    },
    {
      "type": ["instructions"],
      "pages": ["In this experiment, a circle will appear in the centre of the screen. If the circle is <b>blue<\/b>, press the letter F on the keyboard as fast as you can. If the circle is <b>orange<\/b>, press the letter J as fast asyou can. Click 'Next' to see examples.<br>", "If you see this blue circle, press F. <br><img src = 'resource/image/blue.png' width = 300px>", "If you see this orange circle, press J. <br><img src = 'resource/image/orange.png' width = 300px>", "Click the 'Next' button when you are ready to begin."],
      "key_forward": ["rightarrow"],
      "key_backward": ["leftarrow"],
      "allow_backward": true,
      "allow_keys": true,
      "show_clickable_nav": true,
      "button_label_previous": ["Previous"],
      "button_label_next": ["Next"],
      "post_trial_gap": [2000]
    },
    {
      "timeline": [
        {
          "type": ["html-keyboard-response"],
          "stimulus": ["<div style=\"font-size:60px;\">+<\/div>"],
          "choices": jsPsych.NO_KEY,
          "trial_duration": function() {  return jsPsych.randomization.sampleWithoutReplacement([250, 500, 750, 1000, 1250, 1500, 1750, 2000], 1);},
          "response_ends_trial": true,
          "post_trial_gap": [0]
        },
        {
          "type": ["image-keyboard-response"],
          "stimulus": jsPsych.timelineVariable('circle'),
          "stimulus_height": [300],
          "stimulus_width": [300],
          "maintain_aspect_ratio": true,
          "choices": ["f", "j"],
          "response_ends_trial": true,
          "post_trial_gap": [0]
        }
      ],
      "timeline_variables": [
        {
          "circle": ["resource/image/orange.png"]
        },
        {
          "circle": ["resource/image/blue.png"]
        }
      ],
      "repetitions": [5],
      "randomize_order": [true]
    },
    {
      "type": ["html-keyboard-response"],
      "stimulus": ["All done! Click <a href='../../../articles/experiment01.html'>here<\/a> to return to the vignette."],
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
