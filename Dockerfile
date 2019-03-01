# tested with ubuntu:18.04 
FROM ubuntu  
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
    unzip \
    tar \
    pkg-config \
    libnetcdf-dev \
  && rm -rf /var/lib/apt/lists/*

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

WORKDIR /opt/meteosatlib-1.8-1

COPY PublicDecompWT.zip ./decompress/

RUN apt-get update && apt-get install -y \
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
  && rm -rf /var/lib/apt/lists/*

RUN apt-get remove -y libgrib-api-dev

WORKDIR /opt

RUN wget https://confluence.ecmwf.int/download/attachments/3473437/grib_api-1.28.0-Source.tar.gz?api=v2 \
  && tar xfz grib_api-1.28.0-Source.tar.gz\?api=v2 \
  && rm grib_api-1.28.0-Source.tar.gz\?api=v2

RUN mkdir build-gribapi

WORKDIR /opt/build-gribapi


RUN apt-get update && apt-get install -y \
    cmake \
  && rm -rf /var/lib/apt/lists/*

RUN cmake ../grib_api-1.28.0-Source -DCMAKE_INSTALL_PREFIX=/usr/local -DENABLE_JPG=off -DENABLE_FORTRAN=off -DENABLE_EXAMPLES=off
RUN make
RUN make install

WORKDIR /opt

RUN wget http://www.ece.uvic.ca/~frodo/jasper/software/jasper-2.0.14.tar.gz \
  && tar xfz jasper-2.0.14.tar.gz \
  && rm jasper-2.0.14.tar.gz

RUN mkdir build-jasper
WORKDIR /opt/build-jasper

RUN cmake ../jasper-2.0.14
RUN make
RUN make install

WORKDIR /opt/meteosatlib-1.8-1
RUN ./config/autogen.sh
RUN ./configure
RUN make
RUN make install
RUN ldconfig

ENV GDAL_DRIVER_PATH=/usr/local/lib/gdalplugins/2.3

WORKDIR /output

CMD msat

RUN apt-get update && apt-get install -y \
  python-scipy \
  python-pillow

