
require_cue <- function(cue, type = NULL) {
  if(class(cue)[1] != "xpt_cue") {
    stop("object of type 'xpt_cue' is required", call. = FALSE)
  }
  if(!is.null(type)) {
    if(!(cue$cue_type %in% type)) {
      stop("invalid cue for this trial type", call. = FALSE)
    }
  }
}

require_response <- function(response, type = NULL) {
  if(class(response)[1] != "xpt_response") {
    stop("object of type 'xpt_response' is required", call. = FALSE)
  }
  if(!is.null(type)) {
    if(!(response$response_type %in% type)) {
      stop("invalid response for this trial type", call. = FALSE)
    }
  }
}
