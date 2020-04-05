# crlapply

* **Version:** 0.2-0
* **Status:** [![Build Status](https://travis-ci.org/wrathematics/crlapply.png)](https://travis-ci.org/wrathematics/crlapply)
* **License:** [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause)
* **Author:** Drew Schmidt


Checkpoint/restart is a useful strategy for running expensive functions in constrained environments (non-reliable hardware, restricted time limits, etc). This package adds an `lapply()`-like function that automatically handles checkpointing.



## Installation

You can install the stable version from [the HPCRAN](https://hpcran.org) using the usual `install.packages()`:

```r
install.packages("crlapply", repos="https://hpcran.org")
```

The development version is maintained on GitHub:

```r
remotes::install_github("wrathematics/crlapply")
```



## Package Use

We'll take a very simple example with a fake "expensive" function:

```r
costly = function(x, waittime)
{
  Sys.sleep(waittime)
  print(paste("iteration:", x))
  
  sqrt(x)
}

ret = crlapply::crlapply(1:10, costly, checkpoint_file="/tmp/cr.rdata", waittime=0.5)

unlist(ret)
```

We can save this to the file `example.r`. We'll run it and kill it a few times:

```bash
$ Rscript example.r
[1] "iteration: 1"
[1] "iteration: 2"
[1] "iteration: 3"
[1] "iteration: 4"
^C
$ Rscript example.r
[1] "iteration: 5"
[1] "iteration: 6"
[1] "iteration: 7"
^C
$ Rscript example.r
[1] "iteration: 8"
[1] "iteration: 9"
[1] "iteration: 10"
```

The final line of the script, when executed, will produce the following:

```r
unlist(ret)
##  [1] 1.000000 1.414214 1.732051 2.000000 2.236068 2.449490 2.645751 2.828427
##  [9] 3.000000 3.162278
```

We could have run this in an interactive R session instead of with in batch with `Rscript`. However, this should make it more obvious what is going on. Each time, we not only halt function execution, but *destroy the entire running R environment*. In the end, we are still able to read the entire set of results. This is because the intermediary results are stored in the checkpoint (that's the whole point). And the results can be any native R object.

So, if your results are very large (say the returns of big, expensive modeling functions) then those large objects will have to be saved/loaded each time there is a save or a reload. Set the `checkpoint_freq` argument appropriately.

One final note, is that the checkpoint/restart won't work for R objects that don't serialize. Anything that is secretly an [external pointer](https://cran.r-project.org/doc/manuals/R-exts.html#External-pointers-and-weak-references) will not be able to properly save/reload, and it may not be obvious at runtime that this is so. The save/reload may "work" in that they execute, but the data will be worthless and could cause the R session to crash when trying to operate on those objects. A few examples of packages whose objects are external pointers are [ngram](https://cran.r-project.org/web/packages/ngram/index.html) and [fmlr](https://hpcran.org/packages/fmlr/index.html).
