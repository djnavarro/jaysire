# file: api_build.R
# author: Danielle Navarro

#' Deploy a jspsych experiment locally
#'
#' @param path Path to the experiment folder
#' @param port The port to use
#'
#' @details The purpose of the \code{run_locally()} function is to start an
#' R server running (using the plumber package) that will
#' serve the experiment from the local machine. The \code{path} argument
#' specifies the location of the experiment to be run, and should be the same
#' as the value of \code{path} that was used when calling
#' \code{\link{build_experiment}()}) to build the experiment originally. The
#' \code{port} is the numeric value of the port on which the experiment is served.
#' Once \code{run_locally()} has been called, a browser window should open
#' showing the relevant page.
#'
#' There are two reasons to deploy a local experiment using \code{run_locally()}
#' rather than simply opening the relevant "index.html" file in the browser. The
#' first is for the purpose of saving data. For security reasons, browsers do not
#' generally permit client-side javascript (e.g., the code that runs the jsPsych
#' experiment) to save files to arbitrary locations. For this reason writing the
#' data to file is the job of the R server, not the javascript code that
#' is running through the browser. In other words, if the experiment is deployed
#' locally using the \code{run_locally()} function, then the \code{\link{fn_save_locally}()}
#' function that used to record data locally will work properly. If, however, the
#' "index.html" file is opened without starting the R server, data will not be
#' saved to file.
#'
#' The second reason for using \code{run_locally()} is that it opens up the possibility
#' that an experiment could use server-side R code at runtime. At the moment jaysire
#' does not have any functionality to do so, but in principle there is nothing
#' preventing the R server from playing a more active role when the experiment is
#' running, and future versions of the package may develope this functionality
#' further.
#'
#' @seealso \code{\link{fn_save_locally}}, \code{\link{build_experiment}}
#'
#' @export
run_locally <- function(path, port = 8000) {

  pr <- plumber::plumber$new()

  static_site <- file.path(path, "experiment")
  data_folder <- file.path(path, "data")
  static_router <- plumber::PlumberStatic$new(static_site)

  pr$mount("/", static_router)
  pr$handle("POST", "/submit", function(req, res){

    dat <- jsonlite::fromJSON(req$postBody)
    dat <- readr::read_csv(dat$filedata)

    tsp <- get_timestamp()
    file_id <- paste(
      "data", get_timestamp(), get_alphanumeric(10), sep = "_"
    )
    dat$file_id <- file_id
    dat <- dat[, c(ncol(dat), 1:ncol(dat)-1), drop = FALSE]
    readr::write_csv(dat, file.path(data_folder, paste0(file_id, ".csv")))
  })

  pr$registerHook("exit", function(){
    print("Done!")
  })

  url <- paste0("http://localhost:", port)
  utils::browseURL(url)
  pr$run(swagger = FALSE, port = port)

}

#' Deploy a jspsych experiment on google app engie
#'
#' @param path path to the experiment folder
#' @param project_id the google app engine project id
#'
#' @export
run_appengine <- function(path, project_id) {
  app <- file.path(path, "experiment", "app.yaml")
  cmd <- paste0("gcloud app deploy ", app, " --project=", project_id)
  cat("To deploy, enter the following command at the console:\n")
  cat(cmd, "\n")
  return(invisible(cmd))
}
