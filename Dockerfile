FROM ubuntu:18.04

RUN apt update && \
    DEBIAN_FRONTEND=noninteractive apt install -y --no-install-recommends \
        wget gcc make gfortran pgplot5 libncurses5-dev libx11-dev git expect \
        && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN wget ftp://ftp.astro.caltech.edu/pub/difmap/difmap2.5e.tar.gz && \
    tar xvzf difmap2.5e.tar.gz && \
    cd uvf_difmap && \
    ./configure linux-i486-gcc && \
    ./makeall && \
    cp difmap /usr/local/bin && \
    cd .. && rm -Rf uvf_difmap

RUN apt update && \
    apt install -y --no-install-recommends ca-certificates python

RUN git clone https://github.com/eventhorizontelescope/2019-D01-02.git
#RUN git clone https://github.com/dstndstn/2019-D01-02.git && echo 2

COPY EHTC_FirstM87Results_Apr2019_uvfits.tgz /2019-D01-02

RUN apt install -y --no-install-recommends python-pip python-setuptools python-wheel python-dev
RUN git clone https://github.com/achael/eht-imaging.git
RUN pip install astropy
RUN pip install scipy
RUN pip install networkx
RUN pip install ephem
RUN cd eht-imaging && pip install .

RUN apt install -y --no-install-recommends python-tk python-pynfft
#libnfft3-dev
RUN pip install ipython pandas

RUN apt install -y --no-install-recommends libopenblas-dev libfftw3-dev

RUN git clone https://github.com/flatironinstitute/finufft
COPY finufft-make.inc /finufft/make.inc

RUN apt install -y --no-install-recommends g++
RUN cd /finufft && make lib
COPY finufft-pc /finufft/finufft.pc
ENV PKG_CONFIG_PATH=/finufft

RUN apt install -y --no-install-recommends pkg-config libxt-dev file saods9
RUN pip install tqdm theano pyds9
RUN git clone https://github.com/astrosmili/smili
RUN cd /smili && git checkout v0.0.0
# xarray 0.14.0 does not seem to work
# ahh it's a py2/3 issue.  0.11.3 is the last py2 release
RUN pip install xarray==0.11.3
RUN cd /smili && ./configure && make install

COPY run.sh /2019-D01-02/runx.sh

WORKDIR 2019-D01-02
CMD ./runx.sh

