var timeline = {
  "timeline": [
    {
      "type": ["html-button-response"],
      "stimulus": ["Do you identify as LGBTIQ+?"],
      "choices": ["Yes", "No", "Prefer not to say"],
      "margin_vertical": ["0px"],
      "margin_horizontal": ["8px"],
      "response_ends_trial": [true],
      "post_trial_gap": [0]
    },
    {
      "timeline": [
        {
          "type": ["survey-multi-select"],
          "questions": [
            {
              "prompt": ["Select all that apply"],
              "options": ["Lesbian", "Gay", "Bisexual/Pansexual", "Transgender", "Nonbinary", "Genderqueer", "Intersex", "Asexual", "Other"],
              "horizontal": [false],
              "required": [false]
            }
          ],
          "randomize_question_order": [false],
          "preamble": [""],
          "button_label": ["Continue"],
          "required_message": ["You must choose at least one response for this question"],
          "post_trial_gap": [0]
        }
      ],
      "conditional_function": function(){
      var data = jsPsych.data.get().last(1).values()[0];
      if(data.button_pressed == "0"){
        return true;
      } else {
        return false;
      }
    }
    },
    {
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
          "prompt": ["You will not be allowed to continue unless you select 'Pleasant'"],
          "response_ends_trial": [true],
          "post_trial_gap": [0]
        }
      ],
      "loop_function": function(){
      var data = jsPsych.data.get().last(1).values()[0];
      if(data.button_pressed != "2"){
        return true;
      } else {
        return false;
      }
    }
    },
    {
      "type": ["html-keyboard-response"],
      "stimulus": ["All done! Click <a href='../../../articles/jaysire07.html'>here<\/a> to return to the vignette."],
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
