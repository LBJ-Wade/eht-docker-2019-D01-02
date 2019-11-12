FROM ubuntu:18.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        wget gcc make gfortran pgplot5 libncurses5-dev libx11-dev git expect \
        ca-certificates python python-pip python-setuptools python-wheel \
        python-tk python-pynfft python-dev \
        libopenblas-dev libfftw3-dev g++ pkg-config libxt-dev file saods9 \
        && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# xarray 0.14.0 does not seem to work
# ahh it's a py2/3 issue.  0.11.3 is the last py2 release

RUN pip install --no-cache-dir ipython pandas tqdm theano pyds9 xarray==0.11.3

# Build difmap
RUN mkdir -p /src/difmap
WORKDIR /src/difmap
RUN wget -nv ftp://ftp.astro.caltech.edu/pub/difmap/difmap2.5e.tar.gz && \
    tar xvzf difmap2.5e.tar.gz && \
    cd uvf_difmap && \
    ./configure linux-i486-gcc && \
    ./makeall && \
    cp difmap /usr/local/bin && \
    ./clean && \
    rm ../difmap2.5e.tar.gz

# Build eht-imaging
WORKDIR /src
RUN git clone https://github.com/achael/eht-imaging.git
RUN cd eht-imaging && pip install --no-cache-dir .

# Build finufft, required by smili
RUN git clone https://github.com/flatironinstitute/finufft
COPY finufft-make.inc /src/finufft/make.inc
COPY finufft-pc /src/finufft/finufft.pc
RUN cd finufft && make lib
ENV PKG_CONFIG_PATH=/src/finufft

# Build smili
RUN git clone https://github.com/astrosmili/smili
RUN cd smili && git checkout v0.0.0 \
    && ./configure && make install

# Grab driver scripts
RUN git clone https://github.com/eventhorizontelescope/2019-D01-02.git

# Include the data file, and a modified driver script (that doesn't try to
# download the data file)
WORKDIR /src/2019-D01-02
COPY EHTC_FirstM87Results_Apr2019_uvfits.tgz runx.sh /src/2019-D01-02/

# Pre-cache astropy time data file -- not sure this works / is required?
#RUN python -c "from astropy.time import Time; Time('2016:001').ut1"

CMD ./runx.sh
