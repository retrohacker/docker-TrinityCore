# This container is used to build the TrinityCore files
# Maintainer: Will Blankenship <william.jblankenship@gmail.com>
FROM debian:jessie

#Install Dependencies
# *Might* be able to remove: 
#   - openssl
#   - libtool

RUN apt-get update && \
    apt-get install --force-yes -y \
      autoconf \
      build-essential \
      cmake \
      gcc \
      g++ \
      git \
      libtool \
      make \
      libncurses5-dev \
      openssl \
      libssl-dev \
      libmysqlclient15-dev \
      libmysql++-dev \
      libreadline6-dev \
      zlib1g-dev \
      libbz2-dev \
      libboost-dev \
      libboost-thread-dev \
      libboost-system-dev \
      libboost-filesystem-dev \
      libboost-program-options-dev \
      libzmq-dev

# Move TrinityCore into place
ADD TrinityCore TrinityCore

# Setup build script
ADD build/script.sh /bin/build
RUN chmod +x /bin/build

VOLUME /build

CMD ["build"]
