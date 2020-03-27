# file: experiment_write.R
# author: Danielle Navarro


#' Build the experiment files
#'
#' @param timeline A timeline object
#' @param path A string specifying a folder in which to build the experiment
#' @param resources A tibble specifying how to construct resource files, or NULL
#' @param columns Additional data values (constants) to store
#' @param ... Arguments to pass to jsPsych.init()
#'
#' @return Invisibly returns \code{NULL}
#'
#' @details The \code{build_experiment()} function is used to build the actual jsPsych
#' experiment from the abstract description contained in the \code{timeline} argument.
#' The input for the \code{timeline} argument should be a timeline constructed using
#' \code{\link{build_timeline}()} and the \code{path} argument should specify the
#' path to the folder in which the experiment files should be created. If the
#' experiment needs to rely on resource files (e.g., images, audio files etc) then
#' the \code{resources} argument should be a tibble containing the information needed
#' to copy those files to the appropriate location. The easiest way to do so is by
#' using the \code{\link{build_resources}()} function: see the documentation for that
#' function for a more detailed description of what this tibble should contain.
#'
#' When called, the \code{build_experiment()} function writes all the experiment files,
#' compiled to javascript and HTML. The file structure it creates is as follows. Within
#' the \code{path} folder are two subfolders, named "data" and "experiment". The "data"
#' folder is empty, but intended to serve as a location to which data files can be
#' written. The "experiment" folder contains the "index.html" file, which is the primary
#' source file for the experiment page, and an "experiment.js" file that specifies the
#' jsPsych timeline and calls the jsPsych.init() javascript function that starts the
#' experiment running. It also contains a "resource" folder with other necessary files
#' (see \code{\link{build_resources}()} for detail).
#'
#' Because \code{build_experiment()} creates the call to jsPsych.init(), it can also
#' be used to specify any parameters that the user may wish to pass to that function
#' via the \code{...}. There are quite a number of parameters you can specify this way:
#'
#' \itemize{
#' \item \code{display_element} is a string specifying the ID of an HTML element
#' to display the experiment in. If left blank, jsPsych will use the <body> element
#' to display content. All keyboard event listeners are bound to this element. In
#' order for a keyboard event to be detected, this element must have focus (be the
#' last thing that the subject clicked on).
#'
#' \item \code{on_finish} is a javascript function that executes when the experiment
#' ends. It can be constructed manually using \code{\link{insert_javascript}()}, but
#' in many cases there is a jaysire function that will create the appropriate function
#' for you. For example, if you want the data to be saved locally at the end of the
#' experiment you can set \code{on_finish = \link{save_locally}()}, whereas if you
#' want the data to be saved to the Google Datastore you can set
#' \code{on_finish = \link{save_googlecloud}()}.
#'
#' \item \code{on_trial_start} is a javascript function that executes when a
#' trial begins.
#'
#' \item \code{on_trial_finish} is a javascript function that executes when a
#' trial ends.
#'
#' \item \code{on_data_update} is a javascript function that executes
#' every time data is stored within the jsPsych internal storage.
#'
#' \item \code{on_interaction_data_update} is a javascript function that executes
#' every time a new interaction event occurs. Interaction events include clicking
#' on a different window (blur), returning to the experiment window (focus),
#' entering full screen mode (fullscreenenter), and exiting full screen mode
#' (fullscreenexit).
#'
#' \item \code{on_close} is a javascript function that executes when the user
#' leaves the page. This can be used, for example, to ensure that data are saved
#' before the page is closed.
#'
#' \item \code{exclusions} is used to specify restrictions on the browser the
#' subject can use to complete the experiment. See list of options below.
#'
#' \item \code{show_progress_bar} is a javascript logical value. If true, then
#' a progress bar is shown at the top of the page.
#'
#' \item \code{message_progress_bar} is a string containing a message to display
#' next to the progress bar. The default is 'Completion Progress'.
#'
#' \item \code{auto_update_progress_bar} is a javascript logical value. If true,
#' then the progress bar at the top of the page will automatically update as
#' every top-level timeline or trial is completed.
#'
#' \item \code{show_preload_progress_bar} is a javascript logical value. If true,
#' then a progress bar is displayed while media files are automatically preloaded.
#'
#' \item \code{preload_audio} is a javascript array of audio files to preload before
#' starting the experiment.
#'
#' \item \code{preload_images} is a javascript array of image files to preload
#' before starting the experiment.
#'
#' \item \code{preload_video} is a javascript array of video files to preload
#' before starting the experiment.
#'
#' \item \code{max_load_time} is a numeric value specifying the maximum number
#' of milliseconds to wait for content to preload. If the wait time is exceeded
#' an error message is displayed and the experiment stops. The default value is
#' 60 seconds.
#'
#' \item \code{max_preload_attempts} is numeric value specifying the maximum
#' number of attempts to preload each file in case of an error. The default
#' value is 10. There is a small delay of 200ms between each attempt.
#'
#' \item \code{use_webaudio} is a javascript logical. If false, then jsPsych will
#' not attempt to use the WebAudio API for audio playback. Instead, HTML5 Audio
#' objects will be used. The WebAudio API offers more precise control over the
#' timing of audio events, and should be used when possible. The default value
#' is true.
#'
#' \item \code{default_iti} is a numeric value setting the default inter-trial
#' interval in milliseeconds. The default value if none is specified is 0.
#'
#' \item \code{experiment_width} is a numeric value setting the desired width
#' of the jsPsych container in pixels. If left undefined, the width will be
#' 100\% of the display element. Usually this is the <body> element, and the
#' width will be 100\% of the screen size.
#' }
#'
#' Note: as of the current writing not all of these have been tested (even informally)
#' through jaysire. Please report any unexpected behaviour by opening an issue on
#' the GitHub page.
#'
#' @export
build_experiment <- function(timeline, path, resources = NULL, columns = NULL, ...) {

  # set up
  init <- list(...)
  scripts <- "jspsych.js"
  stylesheets <- "jspsych.css"

  # use the timeline to discover plugins
  flattl <- unlist(timeline)
  plugins <- flattl[grep(pattern = "type$", x = names(flattl))]
  plugins <- unique(unname(plugins))
  plugins <- paste0("jspsych-", plugins, ".js")
  scripts <- c(scripts, plugins)

  # create tree
  dir.create(path)
  dir.create(file.path(path, "experiment"))
  dir.create(file.path(path, "experiment", "resource"))
  dir.create(file.path(path, "experiment", "resource", "script"))
  dir.create(file.path(path, "experiment", "resource", "style"))
  dir.create(file.path(path, "experiment", "resource", "audio"))
  dir.create(file.path(path, "experiment", "resource", "video"))
  dir.create(file.path(path, "experiment", "resource", "image"))
  dir.create(file.path(path, "experiment", "resource", "other"))
  dir.create(file.path(path, "data"))

  # copy resource files
  if(!is.null(resources)) {
    file.copy(
      from = resources$from,
      to = file.path(path, "experiment", resources$to)
    )
  }

  # copy jspsych scripts
  file.copy(
    from = system.file(
      "extdata", "jsPsych-6.1.0", stylesheets,
      package = "jaysire"
    ),
    to = file.path(path, "experiment", "resource", "style")
  )

  # copy jspsych scripts
  file.copy(
    from = system.file(
      "extdata", "jsPsych-6.1.0", scripts,
      package = "jaysire"
    ),
    to = file.path(path, "experiment", "resource", "script")
  )

  # copy jaysire files [<-- pretty sure this is now unnecessary]
  file.copy(
    from = system.file("extdata", "xprmntr.js", package = "jaysire"),
    to = file.path(path, "experiment", "resource", "script")
  )

  # copy GAE files if necessary
  if(identical(init$on_finish, save_googlecloud())){
    file.copy(
      from = system.file("extdata", "app.yaml", package = "jaysire"),
      to = file.path(path, "experiment")
    )
    file.copy(
      from = system.file("extdata", "backend.py", package = "jaysire"),
      to = file.path(path, "experiment")
    )
    file.copy(
      from = system.file("extdata", "jquery.min.js", package = "jaysire"),
      to = file.path(path, "experiment", "resource", "script")
    )

    scripts <- c(scripts, "jquery.min.js")
  }

  # copy webserver-saving files if necessary
  if(identical(init$on_finish, save_webserver())){
    file.copy(
      from = system.file("extdata", "record_result.php", package = "jaysire"),
      to = file.path(path, "experiment", "resource", "script")
    )
  }


  # variables to add to the data storage
  if(is.null(columns)) {
    add_properties <- character(0)
  } else {
    prop_str <- jsonlite::toJSON(columns, pretty = TRUE, json_verbatim = TRUE)
    add_properties <- paste0("jsPsych.data.addProperties(", prop_str, ");\n")
  }

  # write the timeline to a js string
  timeline_json <- paste(
    "var timeline = ",
    jsonlite::toJSON(timeline, pretty = TRUE, json_verbatim = TRUE),
    ";\n", sep = ""
  )

  # write the initialisation to a js string
  task <- c(list(timeline = js_code("[timeline]")), init)
  init_json <- paste(
    "jsPsych.init(",
    jsonlite::toJSON(task, pretty = TRUE, json_verbatim = TRUE),
    ");", sep = "\n"
  )

  # write both to file
  writeLines(
    text = c(add_properties, timeline_json, init_json),
    con = file.path(path, "experiment", "experiment.js")
  )

  # header info for html file
  html <- c(
    '<!DOCTYPE html>',
    '  <html lang="en-us">',
    '  <head>',
    paste0('    <script src = "resource/script/', scripts, '"></script>'),
    paste0('    <script src = "resource/script/xprmntr.js"></script>'),
    paste0('    <script src = "', resources$to[resources$type == "script"], '"></script>'),
    paste0('    <script src = "experiment.js"></script>'),
    paste0('    <link rel="stylesheet" href="resource/style/', stylesheets, '">'),
    '  </head>',
    '  <body>',
    '  </body>',
    '</html>'
  )

  # write the file
  writeLines(html, file.path(path, "experiment", "index.html"))

  return(invisible(NULL))

}
