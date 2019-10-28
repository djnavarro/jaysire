


#' Pass text as raw javascript
#'
#' @param string
#'
#' @export
code <- function(string) {
  class(x) <- "json"
  x
}

js_code <- function(x) {
  class(x) <- "json"
  x
}


js_logical <- function(x) {
  as.logical(x)
}

js_numeric <- function(x) {
  as.numeric(x)
}

# the ... here are individual strings
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
js_struct <- function(...) {
  list(...)
}

# the ... here are list of name/value pairs
js_array <- function(...) {
  classes <- purrr::map_chr(list(...), ~ class(.x)[1])
  if(any(classes == "list")) {
    return(list(...))
  }
  return(c(...))
}

list_to_jsarray <- purrr::lift_dl(js_array)


