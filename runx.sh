#!/usr/bin/env bash
#
# Copyright (C) 2019 The Event Horizon Telescope Collaboration
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

REPO=https://github.com/eventhorizontelescope/2019-D01-01/raw/master
FILE=EHTC_FirstM87Results_Apr2019_uvfits.tgz
DATADIR=EHTC_FirstM87Results_Apr2019

if [ -d $DATADIR ]; then
    echo "Data directory $DATADIR exists -- not downloading/extracting"
else
    if [ -f $FILE ]; then
        echo "File $FILE already exists -- not re-downloading"
    else
        echo "Download uvfits files for the EHT first M87 results"
        wget $REPO/$FILE
    fi
    echo "Extract uvfits files to disk"
    mkdir -p data
    tar -vzxf $FILE -C data --strip-components=1
fi

echo "Run imaging pipelines"
for d in smili/ eht-imaging/ difmap/; do
    echo "Running $d"
    pushd $d
    time (./run.sh > log 2>&1)
    popd > /dev/null

    if [ -d /tmp/out ]; then
        echo "Copy outputs"
        mkdir -p /tmp/out/$d
        if [ -d $d/smili_reconstructions ]; then
            cp $d/smili_reconstructions/SR1* /tmp/out/$d;
        else
            cp $d/{log,SR1*} /tmp/out/$d
        fi
        # This complains about non-existing files in a way that looks like an error
        #cp $d/{,smili_reconstructions}/{log,SR1*} /tmp/out/$d
        for x in /tmp/out/$d/*.fits; do
            python -c "import matplotlib.pylab as plt; import astropy.io.fits as f; I=f.open('$x')[0].data; I=I[0,0,:,:] if len(I.shape)==4 else I; plt.imsave('$x'.replace('.fits','.png'), I, cmap='hot', origin='lower')"
        done
    fi
done

echo "Finished running in container $(hostname)"
