#' crsapply
#' 
#' An \code{sapply()}-like interface with automatic checkpoint/restart
#' functionality. A simple wrapper around \code{crlapply()}.
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
#' @seealso \code{\link{crlapply}}
#' @export
crsapply = function(X, FUN, ..., checkpoint_file, checkpoint_freq=1)
{
  ret = crlapply(X=X, FUN=FUN, checkpoint_file=checkpoint_file, checkpoint_freq=checkpoint_freq, ...)
  if (length(ret) > 0) 
    simplify2array(ret, higher=FALSE)
  else
    ret
}
