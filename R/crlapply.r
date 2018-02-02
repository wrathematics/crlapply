#' crlapply
#' 
#' An \code{lapply()}-like interface with automatic checkpoint/restart
#' functionality.
#' 
#' @details
#' The checkpoint file is cleaned up on successful completion of
#' \code{crlapply()}
#' 
#' @param X,FUN,...
#' Same as in \code{lapply()}.
#' @param FILE
#' The checkpoint file.
#' @param FREQ
#' The checkpoint frequency; a positive integer.
#' 
#' @return
#' A list.
#' 
#' @export
crlapply = function(X, FUN, FILE, FREQ=1, ...)
{
  if (missing(X))
    stop("argument 'X' is missing, with no default")
  if (missing(FUN))
    stop("argument 'FUN' is missing, with no default")
  if (missing(FILE))
    stop("argument 'FILE' is missing, with no default")
  
  FREQ = as.integer(FREQ)
  if (is.na(FREQ) || length(FREQ) != 1L || FREQ < 1L)
    stop("argument 'FREQ' must be a positive integer")
  
  n = length(X)
  
  if (file.exists(FILE))
    load(file=FILE)
  else
  {
    start = 1L
    ret = vector(length=n, mode="list")
  }
  
  for (i in start:n)
  {
    ret[[i]] = FUN(i, ...)
    
    if (n %% FREQ == 0)
    {
      start = i+1L
      save(start, ret, file=FILE)
    }
  }
  
  
  file.remove(FILE)
  
  ret
}
