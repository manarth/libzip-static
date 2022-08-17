ARG SRC="https://github.com/nih-at/libzip.git"
ARG VER="v1.9.2"
ARG OWNER=manarth
ARG REPO=libzip-static

FROM alpine:3.16 as build
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

# Package to a minimal release.
FROM scratch as dist
ARG SRC
ARG VER
ARG OWNER
ARG REPO

LABEL libzip.source=${SRC}
LABEL libzip.version=${VER}
LABEL org.opencontainers.image.source https://github.com/${OWNER}/${REPO}

STOPSIGNAL SIGTERM
COPY --from=build //opt/libzip/build/lib/libzip.a /lib/libzip.a
