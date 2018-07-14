#' Assign the object "as is" within a pipe sequence
#'
#' @param x the object
#' @param name variable name
#' @param envir the environment the new variable will inhabit
#'
#' @return the object, invisibly
#' @export
#'
#' @examples
#' \dontrun{
#' mtcars %>%
#'   filter(cyl == 4) %>%
#'   assign_as_is(name = "four_cyl") %>%
#'   group_by(am) %>%
#'   do(broom::tidy(lm(mpg ~ wt, data = .)))
#' }
assign_as_is <- function(x, name = NULL, envir = .GlobalEnv) {
  assign(name, x, envir = envir)
  invisible(x)
}

