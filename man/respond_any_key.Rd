% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/helpers_misc.R
\name{respond_any_key}
\alias{respond_any_key}
\title{Response is accepted with any key press}
\usage{
respond_any_key()
}
\description{
Response is accepted with any key press
}
\details{
Many of the functions within the \code{trial_} family are designed
to allow participants to respond using a key press, generally by specifying a
a \code{choices} argument that indicates which keys will be accepted as valid
responses (e.g., \code{choices = c("f","j")}). There are also cases where
you may wish to allow every key to be a valid response (e.g., in situations
where "Press any key to continue" is a sensible prompt).
In those cases, specifying \code{choices = respond_any_key()} will
produce the desired behaviour.
}
\seealso{
\code{\link{respond_no_key}}, \code{\link{trial_html_keyboard_response}},
\code{\link{trial_image_keyboard_response}}, \code{\link{trial_audio_keyboard_response}},
\code{\link{trial_video_keyboard_response}}
}
