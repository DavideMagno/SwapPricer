% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Data_formatting.R
\name{ApplyStandardConventions}
\alias{ApplyStandardConventions}
\title{Helper function to format standard swaps}
\usage{
ApplyStandardConventions(swap.tabular, test)
}
\arguments{
\item{swap.tabular}{a list which includes the user defined characteristics
of a swap contract}

\item{test}{a character (`r` or `p`) representing if the swap if receiver or
payer}
}
\value{
a formatted version of the contract that is readable by the functions
in the toolbox
}
\description{
This function calls other helper functions to format a swap list from the
tabular version to the target one
}
