/**
 * xprmntr.js
 * Danielle Navarro
 *
 **/

// bundle everything into the xprmntr object
var xprmntr = {};

// for use in the jsPsych.init() call
xprmntr.save_locally = function() {
  var data = jsPsych.data.get().csv();
  var file = "xprmntr_local_name";
  var xhr = new XMLHttpRequest();
  xhr.open('POST', 'submit');
  xhr.setRequestHeader('Content-Type', 'application/json');
  xhr.send(JSON.stringify({filename: file, filedata: data}));
};

