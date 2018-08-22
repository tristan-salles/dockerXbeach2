FROM tristansalles/usyd-uos-geos-base:latest


MAINTAINER Tristan Salles

# Install XBEACH model
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    automake \
    autoconf \
    libtool \
    shtool \
    autogen \
    python-mako \
    subversion

RUN cd /usr/local && \
    svn --username tristan.salles.x.1 --password matris --trust-server-cert checkout https://svn.oss.deltares.nl/repos/xbeach/trunk && \
    cd trunk && \
    sh autogen.sh && \
    ./configure --with-netcdf && \
    make && \
    make install
