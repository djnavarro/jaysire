% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/trial_survey_likert.R
\name{question_likert}
\alias{question_likert}
\title{Create a Likert question}
\usage{
question_likert(prompt, labels, required = FALSE, name = NULL)
}
\arguments{
\item{prompt}{the prompt for the question}

\item{labels}{the labels on the Likert scale}

\item{required}{is a response to the question required?}

\item{name}{a convenient label for the question}
}
\value{
A question object to be passed to \code{\link{trial_survey_likert}()}.
}
\description{
Create a Likert question
}
\details{
The \code{question_likert()} function is designed to be called when
using \code{\link{trial_survey_likert}()} to construct a survey page that contains
Likert scale response items. When rendered as part of the study, the text specified
by the \code{prompt} argument is shown to the participant, with a set of ordered
categories displayed along a horizontal line. The \code{labels} for these categories
are shown beneath the line, and the participant responds by selecting a radio button
that is placed along the line. If \code{required = TRUE} the participant will not
be allowed to continue to the next trial unless an answer is provided.

The \code{name} argument should be a string that provides a convenient
label for the question. If left unspecified, jsPsych defaults to labelling
the questions within a survey page as "Q0", "Q1", "Q2", etc.
}
\seealso{
Survey page trials are constructed using the \code{\link{trial_survey_text}},
\code{\link{trial_survey_likert}}, \code{\link{trial_survey_multi_choice}} and
\code{\link{trial_survey_multi_select}} functions. Individual questions for survey
trials can be specified using \code{\link{question_text}},
\code{\link{question_likert}} and \code{\link{question_multi}}.
}
