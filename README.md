Hodgkin Huxley Model
===============

## Introduction



The Hodgkin–Huxley model, or conductance-based model, is a mathematical model that describes how action potentials in neurons are initiated and propagated. It is a set of nonlinear differential equations that approximates the electrical characteristics of excitable cells such as neurons and cardiac myocytes.




### To run the model on your own computer

If you want to run this on your own computer, make sure you have `shiny`, `quantmod`, and `deSolve` installed. Then run the following command: `shiny::runGitHub('HodgkinHuxleyModel', 'ineskris')`

Or copy and paste the following script.

```r
## Running shiny() on your own computer
## Install libraries -- shiny, quantmod, deSolve
if (!require(shiny)) {
    install.packages("shiny")
    library(shiny)
}
if (!require(quantmod)) {
    install.packages("quantmod")
    library(quantmod)
} 
if (!require(deSolve)) {
    install.packages("deSolve")
    library(deSolve)
} 

## Load libraries
require(deSolve)
require(quantmod)
require(shiny)

## Run shinyapp
shiny::runGitHub('HodgkinHuxleyModel', 'ineskris')
```
