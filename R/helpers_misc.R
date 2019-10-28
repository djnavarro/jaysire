# file: helpers.R
# author: Danielle Navarro

any_key <- function() {
  js_code("jsPsych.ANY_KEY")
}

no_key <- function() {
  js_code("jsPsych.NO_KEY")
}


#' Refers to a resource file
#'
#' @param file path
#' @export
resource <- function(file) {

  # THIS IS A HACK -- FIX THIS
  audio  <- c(".mp3", ".wav", ".aif", ".mid")
  video  <- c(".mp4", ".mpg", ".mov", ".wmv")
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

drop_nulls <- function(x) {
  x[purrr::map_lgl(x, ~!is.null(.x))]
}

# returns a list of expressions
capture_dots <- function(...) {
  as.list(substitute(list(...)))[-1L]
}

#' @importFrom magrittr %>%
#' @export
magrittr::`%>%`

#' @importFrom rlang %||%
NULL

get_timestamp <- function() {
  tsp <- as.character(Sys.time())
  tsp <- gsub("[ :]", "-", tsp)
  return(tsp)
}

get_alphanumeric <- function(n = 5) {
  x <- c("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r",
         "s","t","u","v","w","x","y","z","0","1","2","3","4","5","6","7","8","9")
  r <- sample(x, size = n, replace = TRUE)
  r <- paste(r, collapse = "")
  return(r)
}
