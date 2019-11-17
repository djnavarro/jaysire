var timeline = {
  "timeline": [
    {
      "type": ["image-button-response"],
      "stimulus": ["resource/image/heart.png"],
      "stimulus_height": [400],
      "stimulus_width": [400],
      "maintain_aspect_ratio": [true],
      "choices": ["Unpleasant", "Neutral", "Pleasant"],
      "margin_vertical": ["0px"],
      "margin_horizontal": ["8px"],
      "response_ends_trial": [true],
      "post_trial_gap": [0]
    },
    {
      "type": ["video-button-response"],
      "sources": ["resource/video/heart.mpg", "resource/other/heart.webm"],
      "trial_ends_after_video": [false],
      "autoplay": [true],
      "controls": [false],
      "rate": [1],
      "choices": ["Unpleasant", "Neutral", "Pleasant"],
      "margin_vertical": ["0px"],
      "margin_horizontal": ["8px"],
      "response_ends_trial": [true],
      "post_trial_gap": [0]
    },
    {
      "type": ["audio-button-response"],
      "stimulus": ["resource/video/wood.mp4"],
      "choices": ["Unpleasant", "Neutral", "Pleasant"],
      "margin_vertical": ["0px"],
      "margin_horizontal": ["8px"],
      "trial_ends_after_audio": [false],
      "response_ends_trial": [true],
      "post_trial_gap": [0]
    },
    {
      "type": ["html-keyboard-response"],
      "stimulus": ["All done! Click <a href='../../../articles/jaysire04.html'>here<\/a> to return to the vignette."],
      "choices": jsPsych.NO_KEY,
      "response_ends_trial": [true],
      "post_trial_gap": [0]
    }
  ]
};

jsPsych.init(
{
  "timeline": [timeline],
  "use_webaudio": [false]
}
);
