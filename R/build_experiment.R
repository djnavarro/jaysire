# file: experiment_write.R
# author: Danielle Navarro


#' Build the experiment files
#'
#' @param timeline tl
#' @param path  p
#' @param columns columns
#' @param resources r
#' @param ... pass to init
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
  if(identical(init$on_finish, fn_save_datastore())){
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
