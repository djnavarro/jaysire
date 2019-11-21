# file: experiment_write.R
# author: Danielle Navarro


#' Wrapper to jsPsych.data.addProperty
#'
#' @param ... Name/value pairs
#' @export
add_properties <- function(...) {
  list(...)
}

# TODO this needs to allow manual overrides and handle clashes etc...
#' Construct a resource specification from paths
#'
#' @param from The paths to files/directories
#' @param audio File extensions assumed to be audio
#' @param video File extensions assumed to be video
#' @param image File extensions assumed to be images
#' @param script File extensions assumed to be scripts
#' @param style File extensions assumed to be stylesheets
#'
#' @export
add_resources <- function(
  from,
  audio  = c(".mp3", ".wav", ".aif", ".mid"),
  video  = c(".mp4", ".mpg", ".mov", ".wmv"),
  image  = c(".jpg", ".png", ".bmp", ".svg", ".tiff"),
  script = c(".js"),
  style  = c(".css")
) {

  # always normalise the path(s) first
  from <- normalizePath(from, mustWork = FALSE)

  # check if the paths exist and remove any nonexistent ones
  # throwing a warning if necessary
  is_file <- file.exists(from)
  if(sum(!is_file)>0) {
    warning(
      "There are nonexistent files specified:\n",
      paste(from[!is_file], collapse = "\n"),
      call. = FALSE
    )
    from <- from[is_file]
  }

  # expand directories
  filepath <- unlist(purrr::map(from, function(x){
    if(!dir.exists(x)) {
      return(x)
    }
    return(list.files(
      path = x,
      all.files = TRUE,
      full.names = TRUE,
      recursive = TRUE
    ))
  }))

  # assign types based on file extensions
  fileext <- tolower(gsub("^.*(\\.[^\\.]*)$", "\\1", filepath))
  type <- rep("other", length(fileext))
  type[fileext %in% audio] <- "audio"
  type[fileext %in% video] <- "video"
  type[fileext %in% image] <- "image"
  type[fileext %in% script] <- "script"
  type[fileext %in% style] <- "style"

  # construct filename
  filename <- basename(filepath)
  newpath <- file.path("resource", type, filename)

  collisions <- unique(filename[duplicated(filename)])
  if(length(collisions) > 0) {
    warning("There are duplicated filenames:\n",
            paste(collisions, collapse = "\n"), call. = FALSE)
  }

  # now create
  return(tibble::tibble(
    name = filename,
    type = type,
    from = filepath,
    to = newpath
  ))

}

#' Make the experiment
#'
#' @param timeline tl
#' @param path  p
#' @param columns columns
#' @param resources r
#' @param ... pass to init
#'
#' @export
experiment <- function(timeline, path, resources = NULL, columns = NULL, ...) {

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


  # copy jaysire files
  file.copy(
    from = system.file("extdata", "xprmntr.js", package = "jaysire"),
    to = file.path(path, "experiment", "resource", "script")
  )

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
