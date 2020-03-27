
# Functions that insert their input into a timeline with a specific structure

#' Insert input as raw javascript
#'
#' @param string a string to be interpreted as javascript code
#'
#' @return An object of class "json"
#'
#' @details As much as possible, the jaysire package has been designed to
#' allow the user to write a behavioural experiment from R that runs through
#' the browser using the jsPsych javascript library, with no need to write
#' any javascript code. However, in some cases this will not be possible and
#' the user may need to pass raw javascript code to the experiment (e.g., when
#' specifying an "on_finish" callback function). To do so, the javascript should
#' be specified as a \code{string} that is passed to \code{insert_javascript()}.
#' What this does is assign the string to the S3 class "json", which in turn
#' means that it will be written to the "experiment.js" file as is.
#'
#' @export
insert_javascript <- function(string) {
  js_code(string)
}

#' Insert input as path to a resource file
#'
#' @param file A character vector of file names
#' @param type A character vector of file types (if \code{NULL}, type is guessed from file extension)
#' @export
#'
#' @return A character vector of file paths specified relative to the
#' location of the main "index.html" file for the experiment.
#'
#' @details The \code{insert_resource()} function is designed to take a vector
#' of filenames as input (the \code{file} argument), categorise files depending
#' on their \code{type} ("audio", "video", "image", "script", "style" or "other")
#' and construct the path to where those files will end up in the final experiment.
#'
#' The logic for including this functionality is as follow.
#' Because jsPsych experiments are designed to run through the browser
#' rather than within R, the jaysire package incorporates "resource files" in a
#' slightly complicated way. Resource files here are divided into several
#' categories because the experiment has to incorporate them in different ways:
#' the code for handling images is different to the code for handling audio files
#' or video files, and both are different to how scripts and style files are loaded.
#' As a consequence, the \code{\link{build_experiment}()} function needs to know
#' what kind of file each resource corresponds to in order to construct the
#' experiment properly.
#'
#' When using jaysire, the \code{insert_resource()} function is generally used
#' when building trials, and serves as a kind of "promissory note" to specify
#' where the relevant files \emph{will be} when the experiment is constructed
#' using \code{\link{build_experiment}()}. In contrast \code{\link{build_resources}()}
#' is generally used when calling \code{\link{build_experiment}()}, and is in
#' essence a set of "instructions" that \code{\link{build_experiment}()} can use
#' to ensure that this promise is kept.
#'
#' @seealso \code{\link{build_resources}}, \code{\link{build_experiment}}
insert_resource <- function(file, type = NULL) {

  if(is.null(type)) {
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
  }

  file.path("resource", type, file)
}


#' Insert reference to a timeline variable
#'
#' @param name String specifying name of the variable to insert
#' @return Javascript code that calls the jsPsych.timelineVariable() function
#'
#' @details When creating an experiment, a common pattern is to create a
#' series of trials that are identical in every respect except for one thing
#' that varies across the trial (e.g., a collection of
#' \code{\link{trial_html_button_response}()} trials that are the same except
#' for the text that is displayed). A natural way to handle this in the
#' jsPsych framework is to create the trial in the usual fashion, except that
#' instead of specifying the \emph{value} that needs to be included in the
#' trial (e.g., the text itself) the code includes a reference to a
#' \emph{timeline variable}. This is the job of the \code{insert_resource()}
#' function. As an example, instead of creating a trial in which
#' \code{stimulus = "cat"} and another one that is identical except that
#' \code{stimulus = "dog"}, you could create a "template" for both trials by
#' setting \code{stimulus = insert_variable("animal")}. This acts as a kind
#' promise that is filled (at runtime) by looking for an "animal" variable
#' attached to the timeline. See the examples section for an illustration of
#' how these functions are intended to work together.
#'
#' @examples
#' # create a template from which a series of trials can be built
#' template <- trial_html_button_response(stimulus = insert_variable("animal"))
#'
#' # create a timeline with three trials, all using the same template
#' # but with a different value for the "animal" variable
#' timeline <- build_timeline(template) %>%
#'   set_variables(animal = c("cat", "dog", "pig"))
#'
#'
#'
#'
#' @seealso \code{\link{set_variables}()}, \code{\link{build_timeline}()}
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
#' @return A list of data values to add to the data store
#' @export
#'
#' @details The intention behind \code{insert_property()} is that it
#' be used when adding new columns to the jsPsych data store. This can
#' be done in two ways. First, it can occur as part of the call to
#' \code{\link{build_experiment}()}. Including an argument of the form
#' \code{column = insert_property(column_name = "constant value")}
#' will insert a new column to the jsPsych data store whose value is
#' "constant value" in every row.
#'
#' The second possible way to use it is during a call to a \code{trial_}
#' function. Including an argument of the form
#' \code{data = insert_property(column_name = "this value")}
#' will insert "this value" as the value for the current row only.
#'
#' Note that, at present \code{insert_property()} simply returns a
#' named list of its inputs. In future versions of jaysire it may have
#' more functionality, but at the moment it is simply a call to \code{list()}
insert_property <- function(...) {
  list(...)
}



