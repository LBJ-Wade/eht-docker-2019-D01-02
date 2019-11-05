# Compilers
CXX=g++
CC=gcc
FC=gfortran

# (compile flags for use with GCC are as in linux makefile)
CFLAGS +=

# Your FFTW3's installation PREFIX
#CFLAGS += -I$HOME/local/include
#LIBS += -L$HOME/local/lib

# You can keep them
FFLAGS   = $(CFLAGS)
CXXFLAGS = $(CFLAGS) -DNEED_EXTERN_C

# OpenMP with GCC on OSX needs following...
#OMPFLAGS = -fopenmp
#OMPLIBS = -lgomp