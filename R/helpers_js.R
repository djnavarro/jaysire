

#' Manually specify the JavaScript object type
#'
#' @param x an object to be coerced
#' @param ... objects to be concatenated and coerced
#' @name jshelpers
NULL

#' @export
#' @rdname jshelpers
js_code <- function(x) {
  class(x) <- "json"
  x
}

#' @export
#' @rdname jshelpers
js_logical <- function(x) {
  as.logical(x)
}

#' @export
#' @rdname jshelpers
js_numeric <- function(x) {
  as.numeric(x)
}


# the ... here are individual strings

#' @export
#' @rdname jshelpers
js_string <- function(...) {
  s <- list(...)
  string_quote <- function(c) {
    if(methods::is(c,"json")) { return(c) }
    return(paste0('"',c,'"'))
  }
  s <- paste(lapply(s, string_quote), collapse = " + ")
  js_code(s)
}

# the ... here are list of name/value pairs

#' @export
#' @rdname jshelpers
js_struct <- function(...) {
  list(...)
}


# the ... here are list of name/value pairs

#' @export
#' @rdname jshelpers
js_array <- function(...) {
  classes <- purrr::map_chr(list(...), ~ class(.x)[1])
  if(any(classes == "list")) {
    return(list(...))
  }
  return(c(...))
}

list_to_jsarray <- purrr::lift_dl(js_array)


