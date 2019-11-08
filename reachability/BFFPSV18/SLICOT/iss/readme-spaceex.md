## setup 

we recall how to run spaceex (compiled from sources version) in a MacOS.

to export the required libraries:

```bash
$ export DYLD_LIBRARY_PATH=/Users/forets/Tools/spaceex_src/sspaceex_local/lib
```

to run spaceex (which one?)

```bash
$ which sspaceex 
/Users/forets/Tools/spaceex_src/sspaceex/Release/sspaceex
```

if everything is ready, then we should get this message:

```bash
$ sspaceex
Missing arguments.
Try `--help' for more information.
```

let's check our version:

```bash
$ sspaceex --version
SpaceEx State Space Explorer, v0.9.8e	, compiled Feb 23 2017, 17:42:33, 54-bit float, 65-bit precise float
```

to get the list of available options:

```bash
$ sspaceex --help
```

## running a model 

to run a model with its config file, do:

```bash
$ sspaceex -m iss-arch.xml -g iss-arch.cfg --verbosity D4
```

this will generate a file as specified in the config: `x182-plot.txt`. we can plot this in an external tool. (in my case i use our matlab scripts `plot_flowpipe`).

