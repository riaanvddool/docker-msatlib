FROM ubuntu:bionic
MAINTAINER rvddool

RUN apt-get update && apt-get install -y \
    software-properties-common \
  && rm -rf /var/lib/apt/lists/*

RUN add-apt-repository --no-update ppa:ubuntugis/ubuntugis-unstable

RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    wget \
    make \
    cmake \
    unzip \
    tar \
    pkg-config \
    libnetcdf-dev \
    autoconf \
    libtool \
    dos2unix \
    help2man \
    imagemagick \
    libmagick++-dev \
    gdal-bin \
    libgdal-dev \
    python-gdal \
    libgrib-api-dev \
    libnetcdf-dev \
    python-scipy \
    python-pillow \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /opt

RUN wget http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.14.tar.gz \
  && tar xfz jasper-2.0.14.tar.gz \
  && rm jasper-2.0.14.tar.gz

RUN mkdir build-jasper
WORKDIR /opt/build-jasper

RUN cmake ../jasper-2.0.14
RUN make
RUN make install

WORKDIR /opt
RUN wget ftp://ftp.unidata.ucar.edu/pub/netcdf/netcdf-cxx-4.2.tar.gz \
  && tar xfz netcdf-cxx-4.2.tar.gz \
  && rm netcdf-cxx-4.2.tar.gz
WORKDIR /opt/netcdf-cxx-4.2

RUN ./configure
RUN make
RUN make check
RUN make install

WORKDIR /opt

RUN wget https://github.com/ARPA-SIMC/meteosatlib/archive/v1.8-1.zip \
  && unzip v1.8-1.zip \
  && rm v1.8-1.zip

COPY PublicDecompWT.zip /opt/meteosatlib-1.8-1/decompress/

WORKDIR /opt/meteosatlib-1.8-1
RUN ./config/autogen.sh
RUN ./configure
RUN make
RUN make install
RUN ldconfig

ENV GDAL_DRIVER_PATH=/usr/local/lib/gdalplugins/2.3

WORKDIR /output

CMD msat


