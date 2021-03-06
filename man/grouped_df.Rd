% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/dataframe.R, R/grouped-df.r
\name{grouped_df}
\alias{grouped_df}
\alias{as_data_frame.grouped_df}
\alias{grouped_df}
\alias{is.grouped_df}
\title{Convert to a data frame}
\usage{
\method{as_data_frame}{grouped_df}(x, ...)

grouped_df(data, vars, drop = TRUE)

is.grouped_df(x)
}
\arguments{
\item{x}{A list. Each element of the list must have the same length.}

\item{...}{Other arguments passed on to individual methods.}

\item{data}{a tbl or data frame.}

\item{vars}{a list of quoted variables.}

\item{drop}{if \code{TRUE} preserve all factor levels, even those without
data.}
}
\description{
Functions that convert the input to a \code{data_frame}.

The easiest way to create a grouped data frame is to call the \code{group_by}
method on a data frame or tbl: this will take care of capturing
the unevalated expressions for you.
}
\details{
For a grouped data frame, the \code{\link[tibble]{as_data_frame}}
S3 generic simply removes the grouping.
}
\seealso{
\code{\link[tibble]{as_data_frame}}
}
\keyword{internal}
