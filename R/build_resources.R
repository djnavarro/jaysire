
# TODO this needs to allow manual overrides and handle clashes etc...

#' Build the resource file specification from a directory path
#'
#' @param from The paths to files/directories
#' @param audio File extensions assumed to be audio
#' @param video File extensions assumed to be video
#' @param image File extensions assumed to be images
#' @param script File extensions assumed to be scripts
#' @param style File extensions assumed to be stylesheets
#'
#' @return The \code{build_resources()} function returns a tibble with four columns,
#' called "name", "type", "from", and "to". The "name" column lists the name of
#' every resource file discovered in the \code{from} folder and the "type" column lists
#' the kind of resource file (image, audio, video, script, style or other file). Finally,
#' the "from" colums specifies the \emph{full} path to the existing location of the
#' resource file, while the "to" column specifies the \emph{relative} path to which a
#' copy of the resource file should be copied (relative to the "index.html" file for
#' the experiment)
#'
#' @details TBA
#'
#' @export
build_resources <- function(
  from,
  audio  = c(".mp3", ".wav", ".aif", ".mid"),
  video  = c(".mp4", ".mpg", ".mov", ".wmv", ".webm", ".ogg"),
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
