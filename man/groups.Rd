% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/group-by.r
\name{groups}
\alias{groups}
\alias{ungroup}
\title{Get/set the grouping variables for tbl.}
\usage{
groups(x)

ungroup(x, ...)
}
\arguments{
\item{x}{data \code{\link{tbl}}}

\item{...}{Additional arguments that maybe used by methods.}
}
\description{
These functions do not perform non-standard evaluation, and so are useful
when programming against \code{tbl} objects. \code{ungroup} is a convenient
inline way of removing existing grouping.
}
\examples{
grouped <- group_by(mtcars, cyl)
groups(grouped)
groups(ungroup(grouped))
}
