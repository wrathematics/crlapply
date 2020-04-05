#' crlapply
#' 
#' An \code{lapply()}-like interface with automatic checkpoint/restart
#' functionality. Checkpoint/restart is a useful strategy for running expensive
#' functions in constrained environments (non-reliable hardware, restricted time
#' limits, etc).
#' 
#' See the package README for a substantive example and explanation.
#' 
#' @details
#' The checkpoint file is removed on successful completion.
#' 
#' @param X,FUN,...
#' Same as in \code{lapply()}.
#' @param checkpoint_file
#' The checkpoint file.
#' @param checkpoint_freq
#' The checkpoint frequency, i.e. how often the function will save checkpoints.
#' A frequency of 1 means that saves occur after every evaluation, 2 after
#' every other, 3 every third, and so on. Should a positive integer.
#' 
#' @return
#' A list.
#' 
#' @seealso \code{\link{crsapply}}
#' @export
crlapply = function(X, FUN, ..., checkpoint_file, checkpoint_freq=1)
{
  if (missing(X))
    stop("argument 'X' is missing, with no default")
  if (missing(FUN))
    stop("argument 'FUN' is missing, with no default")
  if (missing(checkpoint_file))
    stop("argument 'checkpoint_file' is missing, with no default")
  
  checkpoint_freq = as.integer(checkpoint_freq)
  if (is.na(checkpoint_freq) || length(checkpoint_freq) != 1L || checkpoint_freq < 1L)
    stop("argument 'checkpoint_freq' must be a positive integer")
  
  n = length(X)
  
  if (file.exists(checkpoint_file))
    load(file=checkpoint_file)
  else
  {
    start = 1L
    ret = vector(length=n, mode="list")
  }
  
  for (i in start:n)
  {
    ret[[i]] = FUN(X[i], ...)
    
    if (n %% checkpoint_freq == 0)
    {
      start = i+1L
      save(start, ret, file=checkpoint_file)
    }
  }
  
  
  file.remove(checkpoint_file)
  ret
}
