#' Data manipulation for data tables.
#'
#' @param .data a data table
#' @param ... variables interpreted in the context of \code{.data}
#' @param inplace if \code{FALSE} (the default) the data frame will be copied
#'   prior to modification to avoid changes propagating via reference.
#' @examples
#' if (require("data.table")) {
#' data("baseball", package = "plyr")
#'
#' # If you start with a data table, you end up with a data table
#' baseball <- as.data.table(baseball)
#' filter(baseball, year > 2005, g > 130)
#' head(select(baseball, id:team))
#' summarise(baseball, g = mean(g))
#' head(mutate(baseball, rbi = r / ab, rbi2 = rbi ^ 2))
#' head(arrange(baseball, id, desc(year)))
#'
#' # If you start with a tbl, you end up with a tbl
#' baseball_s <- as.tbl(baseball)
#' filter(baseball_s, year > 2005, g > 130)
#' select(baseball_s, id:team)
#' summarise(baseball_s, g = mean(g))
#' mutate(baseball_s, rbi = r / ab, rbi2 = rbi ^ 2)
#' arrange(baseball_s, id, desc(year))
#' }
#' @name manip_dt
NULL

and_expr <- function(exprs) {
  assert_that(is.list(exprs))
  if (length(exprs) == 0) return(TRUE)
  if (length(exprs) == 1) return(exprs[[1]])

  left <- exprs[[1]]
  for (i in 2:length(exprs)) {
    left <- substitute(left & right, list(left = left, right = exprs[[i]]))
  }
  left
}

#' @rdname manip_dt
#' @export
#' @method filter data.table
filter.data.table <- function(.data, ..., .env = parent.frame()) {
  expr <- and_expr(dots(...))
  call <- substitute(.data[expr, ])

  eval_env <- new.env(parent = .env)
  eval_env$.data <- .data

  eval(call, eval_env)
}

#' @S3method filter tbl_dt
filter.tbl_dt <- function(.data, ..., .env = parent.frame()) {
  tbl_dt(
    filter.data.table(.data, ..., .env = .env)
  )
}

#' @rdname manip_dt
#' @export
#' @method summarise data.table
summarise.data.table <- function(.data, ...) {
  cols <- named_dots(...)
  list_call <- as.call(c(quote(list), named_dots(...)))
  call <- substitute(.data[, list_call])

  eval(call, parent.frame())
}

#' @S3method summarise tbl_dt
summarise.tbl_dt <- function(.data, ...) {
  tbl_dt(
    summarise.data.table(.data, ...)
  )
}

#' @rdname manip_dt
#' @export
#' @method mutate data.table
mutate.data.table <- function(.data, ..., inplace = FALSE) {
  if (!inplace) .data <- copy(.data)

  env <- new.env(parent = parent.frame(), size = 1L)
  env$data <- .data

  cols <- named_dots(...)
  # For each new variable, generate a call of the form df[, new := expr]
  for(col in names(cols)) {
    call <- substitute(data[, lhs := rhs],
      list(lhs = as.name(col), rhs = cols[[col]]))
    eval(call, env)
  }

  .data
}

#' @S3method mutate tbl_dt
mutate.tbl_dt <- function(.data, ...) {
  tbl_dt(
    mutate.data.table(.data, ...)
  )
}

#' @rdname manip_dt
#' @export
#' @method arrange data.table
arrange.data.table <- function(.data, ...) {
  call <- substitute(data[order(...)])
  env <- new.env(parent = parent.frame(), size = 1L)
  env$data <- .data
  out <- eval(call, env)

  eval(call, env)
}

#' @S3method arrange tbl_dt
arrange.tbl_dt <- function(.data, ...) {
  tbl_dt(
    arrange.data.table(.data, ...)
  )
}

#' @rdname manip_dt
#' @export
#' @method select data.table
select.data.table <- function(.data, ...) {
  input <- var_eval(dots(...), .data, parent.frame())
  .data[, input, drop = FALSE, with = FALSE]
}

#' @S3method select tbl_dt
select.tbl_dt <- function(.data, ...) {
  tbl_dt(
    select.data.table(.data, ...)
  )
}

#' @S3method do data.table
do.data.table <- function(.data, .f, ...) {
  list(.f(as.data.frame(.data), ...))
}

#' @S3method do tbl_dt
do.tbl_dt <- function(.data, .f, ...) {
  list(.f(as.data.frame(.data), ...))
}
