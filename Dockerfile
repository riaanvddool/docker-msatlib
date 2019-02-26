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

RUN ./config/autogen.sh
RUN ./configure

RUN make
RUN make install

RUN echo 'GDAL_DRIVER_PATH=/usr/local/lib/gdalplugins/2.3' >> /etc/environment
RUN export GDAL_DRIVER_PATH=/usr/local/lib/gdalplugins/2.3

RUN ldconfig

CMD msat
