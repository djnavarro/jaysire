# file: api_build.R
# author: Danielle Navarro

#' Deploy a jspsych experiment locally
#'
#' @param path the experiment folder
#' @param port port to use
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
