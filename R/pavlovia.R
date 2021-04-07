
#' Communication with pavlovia.org
#'
#' @description The \code{pavlovia} plugin supports running experiments online
#' in Pavlovia.
#'
#' @param command The pavlovia command: "init" (default) or "finish".
#' @param participantId The participant Id: any string (NULL by default).
#' @param errorCallback The callback function called whenever an error occurs
#' (NULL by default).
#'
#' @export
pavlovia <- function(
  command = js_string("init"),
  participantId = NULL,
  errorCallback = NULL
) {
  drop_nulls(
    trial(
      type = "pavlovia",
      command = js_string(command),
      participantId = participantId,
      errorCallback = errorCallback
    )
  )
}
