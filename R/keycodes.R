



#' Javascript key codes
#'
#' @param key character vector specifying keynames (default = NULL)
#' @param code numeric vector specfiying keycodes (default = NULL)
#'
#' @return A numeric or character vector
#'
#' @details  This function provides a mapping between the human-readable
#' javascript \code{key} names and their corresponding numeric \code{code}
#' values. If both input arguments are \code{NULL}, it returns a named
#' numeric vector whose values correspond to the key codes and whose names
#' correspond to the key names. If \code{key} is specified the return value
#' is a vector with the corresponding numeric codes; whereas if \code{code}
#' is specified the output is a character vector containing the corresponding
#' key names. If neither argument is \code{NULL} the function throws an error.
#' @export
keycode <- function(key = NULL, code = NULL) {

  dictionary <- c(
    "backspace" = 8,
    "tab" = 9,
    "enter" = 13,
    "shift" = 16,
    "ctrl" = 17,
    "alt" = 18,
    "pause/break" = 19,
    "caps lock" = 20,
    "escape" = 27,
    "page up" = 33,
    "page down" = 34,
    "end" = 35,
    "home" = 36,
    "left arrow" = 37,
    "up arrow" = 38,
    "right arrow" = 39,
    "down arrow" = 40,
    "insert" = 45,
    "delete" = 46,
    "0" = 48,
    "1" = 49,
    "2" = 50,
    "3" = 51,
    "4" = 52,
    "5" = 53,
    "6" = 54,
    "7" = 55,
    "8" = 56,
    "9" = 57,
    "a" = 65,
    "b" = 66,
    "c" = 67,
    "d" = 68,
    "e" = 69,
    "f" = 70,
    "g" = 71,
    "h" = 72,
    "i" = 73,
    "j" = 74,
    "k" = 75,
    "l" = 76,
    "m" = 77,
    "n" = 78,
    "o" = 79,
    "p" = 80,
    "q" = 81,
    "r" = 82,
    "s" = 83,
    "t" = 84,
    "u" = 85,
    "v" = 86,
    "w" = 87,
    "x" = 88,
    "y" = 89,
    "z" = 90,
    "left window key" = 91,
    "right window key" =92,
    "select key" = 93,
    "numpad 0" =	96,
    "numpad 1" =	97,
    "numpad 2" =	98,
    "numpad 3" =	99,
    "numpad 4" = 100,
    "numpad 5" = 101,
    "numpad 6" = 102,
    "numpad 9" = 105,
    "numpad 7" = 103,
    "numpad 8" = 104,
    "multiply" = 106,
    "add" = 107,
    "subtract" = 109,
    "decimal point" = 110,
    "divide" = 111,
    "f1" = 112,
    "f2" = 113,
    "f3" = 114,
    "f4" = 115,
    "f5" = 116,
    "f6" = 117,
    "f7" = 118,
    "f8" = 119,
    "f9" = 120,
    "f10" = 121,
    "f11" = 122,
    "f12" = 123,
    "num lock" = 144,
    "scroll lock" = 145,
    "semi-colon" = 186,
    "equal sign" = 187,
    "comma" = 188,
    "dash" = 189,
    "period" = 190,
    "forward slash" = 191,
    "grave accent" = 192,
    "open bracket" = 219,
    "back slash" = 220,
    "close braket" = 221,
    "single quote" = 222
  )

  # if no input return all codes
  if(is.null(key) & is.null(code)) {
    return(dictionary)
  }

  # if key is specified return the codes
  if(!is.null(key) & is.null(code)) {
    if(!is.character(key)) {
      stop("`key` must be a character vector", call. = FALSE)
    }
    return(unname(dictionary[key]))
  }

  # if code is specified return the keys
  if(is.null(key) & !is.null(code)) {
    if(!is.numeric(code)) {
      stop("`code` must be a numeric vector", call. = FALSE)
    }
    return(names(dictionary[match(code, dictionary)]))
  }

  # if both are specified return error
  stop("Input should use `key` or `code` arguments, not both", call. = FALSE)

}

