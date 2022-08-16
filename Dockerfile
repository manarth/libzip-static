ARG SRC="https://github.com/nih-at/libzip.git"
ARG VER="v1.9.2"

FROM alpine:3.16
ARG SRC
ARG VER

RUN apk add autoconf automake bison cmake g++ gcc git libc-dev libtool make mbedtls-static re2c samurai zlib-dev

RUN mkdir /opt/libzip
WORKDIR /opt/libzip

RUN git clone --depth 1 --branch ${VER} ${SRC} /opt/libzip

RUN  cmake -B build -G Ninja \
       -DBUILD_SHARED_LIBS=OFF \
       -DCMAKE_INSTALL_PREFIX=/usr \
       -DCMAKE_INSTALL_LIBDIR=lib \
       -DENABLE_BZIP2=ON \
       -DENABLE_LZMA=ON \
       -DENABLE_OPENSSL=ON \
       -DENABLE_ZSTD=ON \
       -DCMAKE_BUILD_TYPE=MinSizeRel

RUN cmake --build build
