
<!-- README.md is generated from README.Rmd. Please edit that file -->

# jaysire

<!-- badges: start -->

[![Travis build
status](https://travis-ci.org/djnavarro/jaysire.svg?branch=master)](https://travis-ci.org/djnavarro/jaysire)
[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://www.tidyverse.org/lifecycle/#experimental)
<!-- badges: end -->

The goal of jaysire is to provide a method for writing behavioural
experiments in R that can be deployed through a web browser. The package
relies on the [jsPsych](https://www.jspsych.org) library by Josh de
Leeuw ([GitHub page](https://github.com/jspsych/jsPsych/)) to create the
experiments, and is structured so that functions in jaysire use the same
argument names as the corresponding jsPsych functions.

## Installation

The jaysire package has not been released on CRAN, but you can install
it directly from GitHub using the following commands:

``` r
#install.packages("remotes")
remotes::install_github("djnavarro/jaysire")
```

## Related packages

  - The [jsPsychR](https://github.com/CrumpLab/jspsychr) package by Matt
    Crump
  - My [xprmtnr](https://github.com/djnavarro/xprmntr) package (in
    development)

## Name

The name “jaysire” is a phonetic transcription of “j-psy-R”, reflecting
the fact that it adheres closely to the design principles used in the
jsPsych javascript library.
