
# Functions that insert their input into a timeline with a specific structure

#' Insert input as raw javascript
#'
#' @param string a string to be interpreted as javascript code
#'
#' @export
insert_javascript <- function(string) {
  js_code(string)
}

#' Insert input as path to a resource file
#'
#' @param file path
#' @export
insert_resource <- function(file) {

  # THIS IS A HACK -- FIX THIS
  audio  <- c(".mp3", ".wav", ".aif", ".mid")
  video  <- c(".mp4", ".mpg", ".mov", ".wmv", ".webm", ".ogg")
  image  <- c(".jpg", ".png", ".bmp", ".svg", ".tiff")
  script <- c(".js")
  style  <- c(".css")

  # assign types based on file extensions
  fileext <- tolower(gsub("^.*(\\.[^\\.]*)$", "\\1", file))
  type <- rep("other", length(fileext))
  type[fileext %in% audio] <- "audio"
  type[fileext %in% video] <- "video"
  type[fileext %in% image] <- "image"
  type[fileext %in% script] <- "script"
  type[fileext %in% style] <- "style"

  file.path("resource", type, file)
}


#' Insert a timeline variable
#'
#' @param name name of the variable to insert
#'
#' @export
#'
insert_variable <- function(name) {
  str <- paste0("jsPsych.timelineVariable('",name, "')")
  return(js_code(str))
}


# Wrapper to jsPsych.data.addProperty

#' Insert a property to the jsPsych data store
#'
#' @param ... Name/value pairs
#' @export
insert_property <- function(...) {
  list(...)
}



