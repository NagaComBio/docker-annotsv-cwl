FROM ubuntu:xenial
MAINTAINER Alexander Paul <alex.paul@wustl.edu>

LABEL \
  version="3.1.2" \
  description="Docker image to run AnnotSV"


#ANNOTSV: https://github.com/lgmgeo/AnnotSV
#ANNOTSV_DOCKER: https://hub.docker.com/r/mgibio/annotsv-cwl/dockerfile
#BCFTOOLS: https://github.com/genome/docker-bcftools/blob/master/Dockerfile

RUN apt-get update -y && apt-get install -y \
  curl \
  g++ \
  libbz2-dev \
  liblzma-dev \
  python \
  tar \
  tcl \
  tcllib \
  unzip \
  wget \
  zlib1g-dev \
  ca-certificates \
  perl \
  bzip2 \
  autoconf \
  automake \
  make \
  gcc \
  libcurl4-gnutls-dev \
  libssl-dev \
  libperl-dev \
  libgsl0-dev 


##BEDTOOLS
ENV BEDTOOLS_INSTALL_DIR=/opt/bedtools2
ENV BEDTOOLS_VERSION=2.28.0

WORKDIR /tmp
RUN wget https://github.com/arq5x/bedtools2/releases/download/v$BEDTOOLS_VERSION/bedtools-$BEDTOOLS_VERSION.tar.gz && \
  tar -zxf bedtools-$BEDTOOLS_VERSION.tar.gz && \
  rm -f bedtools-$BEDTOOLS_VERSION.tar.gz

WORKDIR /tmp/bedtools2
RUN make && \
  mkdir --parents $BEDTOOLS_INSTALL_DIR && \
  mv ./* $BEDTOOLS_INSTALL_DIR

WORKDIR /
RUN ln -s $BEDTOOLS_INSTALL_DIR/bin/* /usr/bin/ && \
  rm -rf /tmp/bedtools2

#ANNOTSV
#ENV ANNOTSV_VERSION=2.3
#ENV ANNOTSV_COMMIT=b5a65c1ddd71d24547f8eab521925f98ece10df4
#ENV ANNOTSV=/opt/AnnotSV_$ANNOTSV_VERSION

ENV ANNOTSV_VERSION=3.1.2
ENV ANNOTSV_COMMIT=48b8f70fd85acecb7c48830493224c70f6a428a7
ENV ANNOTSV=/opt/AnnotSV_$ANNOTSV_VERSION

WORKDIR /opt
RUN wget https://github.com/lgmgeo/AnnotSV/archive/${ANNOTSV_COMMIT}.zip && \
  unzip ${ANNOTSV_COMMIT}.zip && \
  mv AnnotSV-${ANNOTSV_COMMIT} ${ANNOTSV} && \
  rm ${ANNOTSV_COMMIT}.zip && \
  cd ${ANNOTSV} && \
  make PREFIX=. install

ENV PATH="${ANNOTSV}/bin:${PATH}"

WORKDIR /

#BCFTOOLS
#Setup ENV variables
#ENV BCFTOOLS_BIN="bcftools-1.3.tar.bz2" \
#BCFTOOLS_PLUGINS="/usr/local/libexec/bcftools" \
#BCFTOOLS_VERSION="1.3"

#Install BCFTools
#RUN curl -fsSL https://github.com/samtools/bcftools/releases/download/$BCFTOOLS_VERSION/$BCFTOOLS_BIN -o /opt/$BCFTOOLS_BIN \
#&& tar xvjf /opt/$BCFTOOLS_BIN -C /opt/ \
#&& cd /opt/bcftools-$BCFTOOLS_VERSION \
#&& make \
#&& make install 
#&& rm -rf /opt/$BCFTOOLS_BIN /opt/bcftools-$BCFTOOLS_VERSION

ENV BCFTOOLS_INSTALL_DIR=/opt/bcftools
ENV BCFTOOLS_VERSION=1.9

WORKDIR /tmp
RUN wget https://github.com/samtools/bcftools/releases/download/$BCFTOOLS_VERSION/bcftools-$BCFTOOLS_VERSION.tar.bz2 && \
  tar --bzip2 -xf bcftools-$BCFTOOLS_VERSION.tar.bz2

WORKDIR /tmp/bcftools-$BCFTOOLS_VERSION
RUN make prefix=$BCFTOOLS_INSTALL_DIR && \
  make prefix=$BCFTOOLS_INSTALL_DIR install

WORKDIR /
RUN ln -s $BCFTOOLS_INSTALL_DIR/bin/bcftools /usr/bin/bcftools && \
  rm -rf /tmp/bcftools-$BCFTOOLS_VERSION

