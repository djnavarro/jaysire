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
#' locally using the \code{run_locally()} function, then the \code{\link{save_locally}()}
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
#' @seealso \code{\link{save_locally}}, \code{\link{build_experiment}}
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

#' Deploy a jspsych experiment on google cloud
#'
#' @param path path to the experiment folder
#' @param project_id the google app engine project id
#'
#' @details The purpose of the \code{run_googlecloud()} function is to make it
#' somewhat easier to deploy a jsPsych experiment to Google App Engine, so that
#' the experiment can run in the cloud rather than on the local machine.
#' The \code{path} argument
#' specifies the location of the experiment to be deployed, and should be the same
#' as the value of \code{path} that was used when calling
#' \code{\link{build_experiment}()}) to build the experiment originally. The
#' \code{project_id} is the name of the Google App Engine project that will host
#' the experiment.
#'
#' At present, the functionality of \code{run_googlecloud()} is quite limited. All
#' it does is construct the appropriate command that you will need to enter at
#' the terminal. It does not execute that command, nor does it assist you in
#' creating the Google App Engine project itself (it is assumed that the user
#' already has a Google Cloud account and is authorised to deploy to the project)
#'
#' @seealso \code{\link{save_googlecloud}}, \code{\link{build_experiment}}
#'
#' @export
run_googlecloud <- function(path, project_id) {
  app <- file.path(path, "experiment", "app.yaml")
  cmd <- paste0("gcloud app deploy ", app, " --project=", project_id)
  cat("To deploy, enter the following command at the terminal:\n")
  cat(cmd, "\n")
  return(invisible(cmd))
}



#' Download data from a jspsych experiment deployed on google cloud
#'
#' @details This function currently does nothing
#'
#' @seealso \code{\link{save_googlecloud}}, \code{\link{run_googlecloud}}
#'
#' @export
download_googlecloud <- function() {
}



#' Deploy a jspsych experiment to a webserver
#'
#' @param path path to the experiment folder
#' @param ssh ssh connection string to a webserver
#' @param keyfile (optional) path to a ssh private key to log in to your webserver
#' @param webserver_configured set this to true when you've configured your webserver
#'
#' @details The purpose of the \code{run_webserver()} function is to make it
#' somewhat easier to deploy a jsPsych experiment to a webserver that you control,
#' so that the experiment can run in the cloud rather than on the local machine.
#'
#' For this to work, you need to configure your webserver first. On a recent ubuntu image
#' (available from most cloud providers), you can install apache and php with
#' "\code{sudo apt install apache2 php}". You should probably also secure the connection
#' between the webserver and the participants with https. If you have configured a domain
#' name for your server, it is pretty simple to enable https via let's encrypt:
#' "\code{sudo add-apt-repository ppa:certbot/certbot}",
#' "\code{sudo apt install certbot python-certbot-apache}", and
#' "\code{sudo certbot --apache}"
#'
#' Used together with \code{\link{save_webserver}}, this will set up a folder on the server
#' that apache can write to, and a little php script to receive said data
#' (as recommended on \href{https://www.jspsych.org/overview/data/#storing-data-permanently-as-a-file}{the jspsych website}).
#'
#' @seealso \code{\link{save_webserver}}, \code{\link{build_experiment}}, \code{\link{download_webserver}}
#'
#' @examples
#' \dontrun{
#' build_experiment(..., on_finish = save_webserver())
#' run_webserver(ssh = "user@server.com", keyfile = "~/.ssh/id_rsa")
#' download_webserver(ssh = "user@server.com", keyfile = "~/.ssh/id_rsa")
#' }
#'
#' @export
run_webserver <- function(path, ssh, keyfile = NULL,
                          webserver_configured = FALSE) {
  if (!requireNamespace("ssh", quietly = TRUE)) {
    stop("In order to deploy to a webserver, please install ssh: install.packages('ssh')")
  }

  ## check if we'll be saving data to the webserver as well
  save_webserver = file.exists(file.path(path, "experiment", "script", "record_result.php"))

  # If we're saving to the webserver, create the data folder and fix permissions
  # note: needs to have passwordless sudo configured
  data_folder = "/var/www/server_data"
  html_folder = "/var/www/html"
  serverfolder_cmd <- paste0(c("sudo mkdir ",
                               "sudo chgrp www-data ",
                               "sudo chmod 775 "),
                             data_folder)

  if (!webserver_configured) {
    ## print a little setup help
    cat("To run the experiment, we need a webserver running. If you haven't yet, \n")
    cat("you can install apache with\n")
    cat(" sudo apt install apache2 php\n")
    cat("and preferably enable https with\n")
    cat(" sudo add-apt-repository ppa:certbot/certbot\n")
    cat(" sudo apt install certbot python-certbot-apache\n")
    cat(" sudo certbot --apache\n")
    cat("Disable this message with webserver_configured = TRUE\n\n")
  }

  cat("To deploy, we're going to copy the experiment/ folder to /var/www/html on the server\n")
  if (save_webserver) {
    cat("and run the following commands on your webserver:\n")
    cat(paste0(" ", serverfolder_cmd, "\n"), sep = "")
  }

  if (readline(prompt = "Ok? [Y/n] ") %in% c("y", "Y", "")) {
    ssh_session <- ssh::ssh_connect(ssh, keyfile)
    if (save_webserver) {
      ssh::ssh_exec_wait(ssh_session, serverfolder_cmd)
    }

    ssh::scp_upload(
      ssh_session,
      files = list.files(file.path(path, "experiment"), full.names = TRUE),
      to = html_folder)

    ssh::ssh_disconnect(ssh_session)
    cat("Deployment complete!")
  }
}


#' Download data from a jspsych experiment deployed on a webserver
#'
#' @param ssh ssh connection string to a webserver
#' @param keyfile (optional) path to a ssh private key to log in to your webserver
#' @param to local folder to download the data to
#'
#' @details This function assumes the default setup by run_webserver, so all it does
#' is download the folder /var/www/server_data
#'
#' @seealso \code{\link{save_webserver}}, \code{\link{run_webserver}}
#'
#' @export
download_webserver <- function(ssh, keyfile = NULL, to = ".") {
  ssh_session <- ssh::ssh_connect(ssh, keyfile)
  ssh::scp_download(ssh_session, "/var/www/server_data/", to = to)
  ssh::ssh_disconnect(ssh_session)
}
