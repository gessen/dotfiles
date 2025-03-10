FROM ubuntu:jammy AS base
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get --yes upgrade \
 && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
 && curl -L http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 \
 && echo "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-19 main" >> /etc/apt/sources.list \
 && echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu jammy main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    build-essential \
    capnproto \
    clang-19 \
    git \
    jq \
    libcapnp-dev \
    libglib2.0-dev \
    libssl-dev \
    libseccomp-dev \
    lld-19 \
    openssh-client \
    pkg-config \
    python3 \
    unzip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* \
 && update-alternatives \
    --install /usr/bin/clang   clang   /usr/bin/clang-19 100 \
    --slave   /usr/bin/clang++ clang++ /usr/bin/clang++-19 \
    --slave   /usr/bin/lld     lld     /usr/bin/lld-19 \
    --slave   /usr/bin/ld.lld  ld.lld  /usr/bin/ld.lld-19

FROM base AS akamill
ARG AKAMILL_VERSION=3.1
RUN export EXPORTS_TARBALL=libakamill_exports_${AKAMILL_VERSION}_alsi22.tar.gz \
 && export DOWNLOAD_URL="https://ew-development.edgekey.net/ewdev/alsi22/${EXPORTS_TARBALL}" \
 && export INSTALL_DIR="/opt/akamill" \
 && mkdir -p "${INSTALL_DIR}" \
 && curl -L ${DOWNLOAD_URL} -H "x-ew-dev:5151346410" \
  | tar zxf - -C "${INSTALL_DIR}" \
 && cd ${INSTALL_DIR}/lib \
 && rm libz.so* \
 && ln -sfn /usr/lib/x86_64-linux-gnu/libz.so \
 && ln -sfn /usr/lib/x86_64-linux-gnu/libz.so.1

FROM base AS v8
RUN --mount=type=ssh export GIT_URL=ssh://git@git.source.akamai.com:7999/sources/stormcloud_v8.git \
 && export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" \
 && mkdir -p /v8/ \
 && git archive --remote="${GIT_URL}" --format=tar.gz master v8/include v8-obj-alsi22.tgz \
  | tar zxf - -C /v8/ \
 && mkdir -p /opt/v8/include \
 && mkdir -p /opt/v8/lib \
 && cp -r /v8/v8/include/* /opt/v8/include/ \
 && tar xf /v8/v8-obj-alsi22.tgz --directory=/opt/v8/lib --strip-components=1

FROM base AS gn
ARG GN_VERSION=2023.03
ADD https://github.com/timniederhausen/gn/releases/download/${GN_VERSION}/gn-linux-amd64.tar.gz /gn.tar.gz
RUN mkdir -p /opt/gn \
 && tar xf /gn.tar.gz --directory=/opt/gn --no-anchored gn

FROM base AS ninja
ARG NINJA_VERSION=1.12.1
ADD https://github.com/ninja-build/ninja/releases/download/v${NINJA_VERSION}/ninja-linux.zip /ninja.zip
RUN mkdir -p /opt/ninja \
 && cd /opt/ninja \
 && unzip /ninja.zip

FROM base AS protobuf
ARG PROTOBUF_VERSION=23.4
ADD https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip /protoc.zip
RUN mkdir -p /opt/protobuf \
 && cd /opt/protobuf \
 && unzip /protoc.zip

FROM base AS sccache
ARG SCCACHE_VERSION=0.9.0
ADD https://github.com/mozilla/sccache/releases/download/v${SCCACHE_VERSION}/sccache-v${SCCACHE_VERSION}-x86_64-unknown-linux-musl.tar.gz /sccache.tar.gz
RUN mkdir -p /opt/sccache \
 && tar xf /sccache.tar.gz --directory=/opt/sccache --strip-components=1 --no-anchored sccache

FROM base AS cmake
ARG CMAKE_VERSION=3.31.2
ADD https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz /cmake.tar.gz
RUN mkdir -p /opt/cmake \
 && tar xf /cmake.tar.gz --directory=/opt/cmake --strip-components=1

FROM base AS mold
ARG MOLD_VERSION=2.35.1
ADD https://github.com/rui314/mold/releases/download/v${MOLD_VERSION}/mold-${MOLD_VERSION}-x86_64-linux.tar.gz /mold.tar.gz
RUN mkdir -p /opt/mold \
 && tar xf /mold.tar.gz --directory=/opt/mold --strip-components=1

FROM base
COPY --from=akamill /opt/akamill/ /opt/akamill/
COPY --from=v8 /opt/v8/ /usr/local/
COPY --from=gn /opt/gn/gn /usr/local/bin/
COPY --from=ninja /opt/ninja/ninja /usr/local/bin/
COPY --from=protobuf /opt/protobuf/bin /usr/local/bin/
COPY --from=protobuf /opt/protobuf/include /usr/local/include/
COPY --from=sccache /opt/sccache/sccache /usr/local/bin/
COPY --from=cmake /opt/cmake/bin/ /usr/local/bin/
COPY --from=cmake /opt/cmake/share/ /usr/local/share/
COPY --from=mold /opt/mold /usr/local/
ENV AKAMILL_INSTALL_PATH=/opt/akamill \
    BUILD_OS=alsi22 \
    CARGO_TERM_COLOR=always \
    LD_LIBRARY_PATH=/opt/akamill/lib \
    OPENSSL_DIR=/opt/akamill \
    OPENSSL_INSTALL_PATH=/opt/akamill \
    NINJA_STATUS="[%s/%f/%t] (j%r/%es/%Es/%P) " \
    RUSTC_LINKER=clang \
    RUSTC_WRAPPER=sccache \
    RUSTFLAGS="-C link-arg=-fuse-ld=lld" \
    SCCACHE_DIR=/project/.sccache \
    V8_INCLUDE_PATH=/usr/local/include \
    V8_LIBRARY_PATH=/usr/local/lib
CMD ["/bin/bash"]
