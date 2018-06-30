kapow <- function(x, ..., list_vars = NULL, obj_prefix_name = FALSE, envir = .GlobalEnv, stop_on_overwrite = TRUE) {
  if (is.null(names(x))) stop("x must be a named data frame, vector, or list.", call. = FALSE)
  if (inherits(x, "data.frame")) {
    vars <- rlang::ensyms(...)
    if (!is.null(vars)) {
      k <- dplyr::select(x, !!!vars)
      k <- lapply(x, unlist)
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
    if (nam %in% ls(envir)) {
      stop(sprintf("%s already exists in environment.", nam))
    }
    assign(nam, k[[i]], envir = envir)
    cat(nam, "assigned to environment.\n")
  }
}
