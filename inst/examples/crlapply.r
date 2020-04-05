suppressMessages(library(crlapply))

costly = function(x, waittime)
{
  Sys.sleep(waittime)
  print(paste("iteration:", x))
  
  sqrt(x)
}

ret = crlapply(1:10, costly, checkpoint_file="/tmp/cr.rdata", waittime=0.5)
cat("\n")
print(unlist(ret))
