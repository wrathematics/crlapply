# crlapply

* **Version:** 0.2-0
* **Status:** [![Build Status](https://travis-ci.org/wrathematics/crlapply.png)](https://travis-ci.org/wrathematics/crlapply)
* **License:** [BSD 2-Clause](http://opensource.org/licenses/BSD-2-Clause)
* **Author:** Drew Schmidt


Checkpoint/restart is a useful strategy for running expensive functions in constrained environments (non-reliable hardware, restricted time limits, etc). This package adds an `lapply()`-like function that automatically handles checkpointing.

The package is functional but still young at this time. More features may make their way here eventually.


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

crlapply::crlapply(1:10, costly, FILE="/tmp/cr.rdata", waittime=0.5)
```

We can save this to the file `example.r`. We'll run it and kill it a few times:

```bash
$ r example.r
[1] "iteration: 1"
[1] "iteration: 2"
[1] "iteration: 3"
[1] "iteration: 4"
^C
$ r example.r
[1] "iteration: 5"
[1] "iteration: 6"
[1] "iteration: 7"
^C
$ r example.r
[1] "iteration: 8"
[1] "iteration: 9"
[1] "iteration: 10"
[[1]]
[1] 1

[[2]]
[1] 1.414214

[[3]]
[1] 1.732051

[[4]]
[1] 2

[[5]]
[1] 2.236068

[[6]]
[1] 2.44949

[[7]]
[1] 2.645751

[[8]]
[1] 2.828427

[[9]]
[1] 3

[[10]]
[1] 3.162278
```
