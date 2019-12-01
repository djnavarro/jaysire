
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
#' the "from" column specifies the \emph{full} path to the existing location of the
#' resource file, while the "to" column specifies the \emph{relative} path to which a
#' copy of the resource file should be copied (relative to the "index.html" file for
#' the experiment)
#'
#' @details Because jsPsych experiments are designed to run through the browser
#' rather than within R, the jaysire package incorporates "resource files" in a
#' slightly complicated way. Resource files here are divided into several
#' categories because the experiment has to incorporate them in different ways:
#' the code for handling images is different to the code for handling audio files
#' or video files, and both are different to how scripts and style files are loaded.
#' As a consequence, the \code{\link{build_experiment}()} function needs to know
#' what kind of file each resource corresponds to in order to construct the
#' experiment properly. One part of what the \code{build_resources()} function
#' does is make this a little easier for the user, by scanning all files that
#' belong to a "resource folder" (located at the path specified by the \code{from}
#' argument) and using the file extension to guess the type of each resource file.
#'
#' The second peculiarity is that the \code{\link{build_experiment}()} function
#' will make copies of all resource files. Regardless of where the original
#' files are taken \code{from}, a separate copy will be placed in an appropriate
#' subfolder within the experiment. For example, if the primary experiment file
#' is saved to "experiment/index.html" and it requires an image file called
#' "picture.png", it will be copied to "experiment/resource/image/picture.png".
#' The reason for this is to ensure that the "experiment" folder is entirely
#' self contained, and includes \emph{all} source files necessary to run the
#' experiment. This is important if the experiment is designed to be
#' deployed to a remote server (e.g., using Google App Engine), as is very
#' often the case if one wishes to run an online experiment.
#'
#' It is for this reason that the \code{\link{build_experiment}()} function
#' creates copies of resource files: jaysire is designed on the presumption that
#' the user may wish to keep the "original" versions of resource files somewhere
#' else, and makes copies of them that can be deployed in the experiment.
#' Viewed from this perspective, the \code{build_resources()} function is
#' a helper function: as long as all the resource files your experiment requires
#' are (at least temporarily) stored in the \code{from} folder, it will construct
#' a tibble that contains all the information that \code{\link{build_experiment}()}
#' needs to organise the experimental files appropriately.
#'
#' There are two important details to note. First, the \code{from} folder should
#' be flat: it should not contain subfolders. Second, there are various arguments
#' (e.g., \code{audio}, \code{video}, \code{script} etc) that specify the file
#' extensions that are associated with each resource type. The default values are
#' likely to change in future as the current lists are quite restrictive.
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
