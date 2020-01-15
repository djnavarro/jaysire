
<!-- README.md is generated from README.Rmd. Please edit that file -->

# Behavioural experiments with jaysire

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/djnavarro/jaysire.svg?branch=master)](https://travis-ci.org/djnavarro/jaysire)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
[![Codecov test
coverage](https://codecov.io/gh/djnavarro/jaysire/branch/master/graph/badge.svg)](https://codecov.io/gh/djnavarro/jaysire?branch=master)
[![CRAN
status](https://www.r-pkg.org/badges/version/jaysire)](https://cran.r-project.org/package=jaysire)
<!-- badges: end -->

The goal of jaysire is to provide a method for writing behavioural
experiments in R that can be deployed through a web browser. The package
relies on the [jsPsych](https://www.jspsych.org) library by Josh de
Leeuw ([GitHub page](https://github.com/jspsych/jsPsych/)) to create the
experiments, and is structured so that functions in jaysire use the same
argument names as the corresponding jsPsych functions. For the most
part, function names in jaysire are organised around families that share
a common prefix. For example, the `trial_` family is used to define
individual trials within an experiment, `build_` functions construct
more complex entities, and so on. See the [reference
page](https://djnavarro.github.io/jaysire/reference/) for the complete
list of all
functions.

<!-- - The `trial_` functions are used to define individual trials in the experiment -->

<!-- - The `build_` functions are used to construct more complex entities: there are build functions for timelines, experiments and resource file lists. -->

<!-- - The `insert_` functions are used to tell jsPsych to "insert" the input into the experiment as a particular kind of entity: a reference to a resource file, a reference to a timeline variable, a data property or as raw javascript. -->

<!-- - The `tl_` functions are used to modify how a timeline executes: by defining a timeline variable, adding parameters, executing in a loop, or executing if a condition holds -->

<!-- - The `question_` family is used when constructing surveys -->

<!-- - The `respond_` family is used when a key press response is needed -->

<!-- - The `fn_` family is used to specify javascript functions used in the experiment -->

## Installation

The jaysire package has not been released on CRAN, but you can install
it directly from GitHub using the following commands:

``` r
#install.packages("remotes")
remotes::install_github("djnavarro/jaysire")
```

## Getting started

There are a series of tutorial articles:

1.  [Getting
    started](https://djnavarro.github.io/jaysire/articles/jaysire01.html)
2.  [Randomisation, repetition and
    variables](https://djnavarro.github.io/jaysire/articles/jaysire02.html)
3.  [Using resource
    files](https://djnavarro.github.io/jaysire/articles/jaysire03.html)
4.  [Image, video and audio
    files](https://djnavarro.github.io/jaysire/articles/jaysire04.html)
5.  [Buttons, key presses and
    sliders](https://djnavarro.github.io/jaysire/articles/jaysire05.html)
6.  [Survey
    pages](https://djnavarro.github.io/jaysire/articles/jaysire06.html)
7.  [Loops and
    branches](https://djnavarro.github.io/jaysire/articles/jaysire07.html)
8.  [A choice reaction time
    task](https://djnavarro.github.io/jaysire/articles/jaysire08.html)

## Related packages

  - The [jsPsychR](https://github.com/CrumpLab/jspsychr) package by Matt
    Crump
  - The [formr](https://github.com/rubenarslan/formr) package by Ruben
    Arslan
  - The [psychTestR](https://pmcharrison.github.io/psychTestR/) package
    by Peter Harrison
  - My [xprmtnr](https://github.com/djnavarro/xprmntr) package (in
    development)

## Name

The name “jaysire” is a phonetic transcription of “j-psy-R”, reflecting
the fact that it adheres closely to the design principles used in the
jsPsych javascript library.
