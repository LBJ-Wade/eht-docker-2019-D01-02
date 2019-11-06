# eht-docker-2019-D01-02
A Docker container that includes all three imaging methods in the Event Horizon Telescope's 2019-D01-02 data product

(https://github.com/dstndstn/eht-docker-2019-D01-02/raw/master/smili-SR1_M87_2017_095_lo_hops_netcal_StokesI.png)

## How to use this

If you want to run the codes for yourself, install *Docker Desktop*
and run:
```
mkdir -p /tmp/out
docker run -it --volume /tmp/out:/tmp/out dstndstn/eht-demo
# Look in /tmp/out for results, specifically /tmp/out/*/*.png
```

This will run for several minutes (on my 'puter: 4 minutes for *difmap*,
2.5 minutes for *eht-imaging*, and 1 minute for *smili*).

Note that one of the methods (*difmap*) does not handle quitting with
control-C, so if you want to stop it, you may have to hold down
ctrl-C, or kill the process.

Once it finishes running, it just exits back to the command line.  So
how do you get the results?  The outputs are copied to /tmp/out, so
have a look there!  You should see a directory for each of the three
methods (*difmap*, *eht-imaging*, and *smili*), each with a log file
and a bunch of FITS image files.

Alternatively, you can run the docker container interactively, eg,
```
docker run -it dstndstn/eht-demo bash
```
and you'll find the code in */src*; the command to run all the methods
is */src/2019-D01-02/runx.sh*

If you ran it non-interactively, as above, then after it finishes you can
get back into the container by doing:
```
# Get the container ID of the most recently run container:
CON=$(docker ps -alq)
# Commit that to a new image
OUT=$(docker commit $CON eht-out)
# Run the new image
docker run -it $OUT bash
```

