FROM tristansalles/usyd-uos-geos-base:latest


MAINTAINER Tristan Salles

RUN echo "deb [check-valid-until=no] http://cdn-fastly.deb.debian.org/debian jessie main" > /etc/apt/sources.list.d/jessie.list
RUN echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list
RUN sed -i '/deb http:\/\/deb.debian.org\/debian jessie-updates main/d' /etc/apt/sources.list
RUN apt-get -o Acquire::Check-Valid-Until=false update

# Install XBEACH model
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    automake \
    autoconf \
    libtool \
    shtool \
    autogen \
    python-mako \
    subversion

# Copy local directory to image
COPY Reef3D /workspace/Reef3D
COPY xbeach /workspace/xbeach
COPY coral /workspace/coral
COPY Yanchep /workspace/Yanchep

RUN cd workspace/xbeach && \
    sh autogen.sh && \
    ./configure --with-netcdf && \
    make && \
    make install

# RUN cd /usr/local && \
#     svn --username tristan.salles.x.1 --password matris --trust-server-cert checkout https://svn.oss.deltares.nl/repos/xbeach/tags/2018-11-09-XBeach-v1.23.5527-XBeachX_update && \
#     mv /usr/local/2018-11-09-XBeach-v1.23.5527-XBeachX_update /usr/local/xbeach
# https://svn.oss.deltares.nl/repos/xbeach/trunk && \
# RUN cd /usr/local/xbeach && \
#     chmod -R a+x /usr/local/xbeach && \
#     sh autogen.sh && \
#     ./configure --with-netcdf && \
#     make && \
#     make install


# expose notebook port
EXPOSE 8888

# setup space for working in
VOLUME /workspace/volume

# launch notebook
WORKDIR /workspace
EXPOSE 8888
ENTRYPOINT ["/usr/local/bin/tini", "--"]

ENV LD_LIBRARY_PATH=/usr/local/lib:

CMD jupyter notebook --ip=0.0.0.0 --no-browser --NotebookApp.token=''
