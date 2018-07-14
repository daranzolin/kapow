#' KAPOW your objects into an environment of your choice. Each named element of the object becomes
#' a variable.
#'
#' @param x A data frame, list or atomic vector.
#' @param ... If x is a data frame, the columns you wish to select.
#' @param list_vars If x is a list or vector, a character vector of names you wish to select.
#' @param obj_prefix_name If TRUE, kapow will prefix the variables with the object name (where possible).
#' @param envir The environment the new variables will inhabit.
#' @param stop_on_overwrite If TRUE, kapow will prevent you from overwriting current variables in the environment.
#' @param theatrics If TRUE, kapow will sound an explosion
#' @param messaging If TRUE, kapow will send a message to the console
#'
#' @return the same object, invisible.
#' @export
#'
#' @examples
#' kapow(iris)
#' kapow(mtcars, mpg, cyl, disp)
#' aq_list <- as.list(airquality)
#' kapow(aq_list, list_vars = c("Ozone", "Day", "Month"), obj_prefix_name = FALSE)
kapow <- function(x,
                  ...,
                  list_vars = NULL,
                  obj_prefix_name = FALSE,
                  envir = .GlobalEnv,
                  stop_on_overwrite = TRUE,
                  theatrics = FALSE,
                  messaging = TRUE) {
  if (is.null(names(x))) stop("x must be a named data frame, vector, or list.", call. = FALSE)
  if (inherits(x, "data.frame")) {
    vars <- rlang::ensyms(...)
    if (length(vars) > 0) {
      k <- dplyr::select(x, !!!vars)
      k <- lapply(k, unlist)
    } else {
      k <- lapply(x, unlist)
    }
  } else if (is.list(x) || is.vector(x)) {
    if (!is.null(list_vars)) {
      k <- x[list_vars]
    } else {
      k <- x
    }
  } else  {
    stop("x must be a data frame, vector, or list.")
  }
  base_nam <- ""
  if (obj_prefix_name) {
    base_nam <- deparse(substitute(x))
    if (base_nam == ".") {
      base_nam <- ""
    }
  }
  for (i in seq_along(k)) {
    nam <- ifelse(base_nam == "",
                  names(k)[i],
                  paste(base_nam, "_", names(k)[i], sep = ""))
    if (stop_on_overwrite && nam %in% ls(envir)) {
      stop(sprintf("%s already exists in environment.", nam))
    }
    assign(nam, k[[i]], envir = envir)
    if (messaging) cat(nam, "assigned to environment.\n")
  }
  if (theatrics) beepr::beep("shotgun")
  invisible(x)
}
