# file: timeline_build.R
# author: Danielle Navarro

#' Build a timeline from trials
#'
#' @param ... trial objects to add to this timeline
#'
#'
#' @export
build_timeline <- function(...){
  tl <- list(timeline = list(...))
  class(tl) <- c("timeline", "list")
  tl
}



