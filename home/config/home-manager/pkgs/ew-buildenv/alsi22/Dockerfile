FROM ubuntu:jammy AS base
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get --yes upgrade \
 && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
 && gpg --list-keys \
 && curl -L "http://apt.llvm.org/llvm-snapshot.gpg.key" \
  | gpg --dearmor > /etc/apt/keyrings/llvm.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/llvm.gpg] http://apt.llvm.org/jammy/ llvm-toolchain-jammy main" \
  | tee /etc/apt/sources.list.d/llvm.list \
 && gpg --no-default-keyring --keyring /etc/apt/keyrings/fish.gpg \
    --keyserver keyserver.ubuntu.com --recv-keys 73C9FCC9E2BB48DA \
 && echo "deb [signed-by=/etc/apt/keyrings/fish.gpg] https://ppa.launchpadcontent.net/fish-shell/release-4/ubuntu/ jammy main" \
  | tee /etc/apt/sources.list.d/fish.list \
 && curl -L "https://packagecloud.io/github/git-lfs/gpgkey" \
  | gpg --dearmor > /etc/apt/keyrings/git-lfs.gpg \
 && echo "deb [signed-by=/etc/apt/keyrings/git-lfs.gpg] https://packagecloud.io/github/git-lfs/ubuntu/ jammy main" \
  | tee /etc/apt/sources.list.d/git-lfs.list \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    build-essential \
    clang \
    git \
    git-lfs \
    jq \
    libglib2.0-dev \
    libssl-dev \
    libseccomp-dev \
    lld \
    openssh-client \
    pkg-config \
    python3 \
    unzip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

FROM base AS akamill
ARG AKAMILL_VERSION=3.1
RUN export EXPORTS_TARBALL=libakamill_exports_${AKAMILL_VERSION}_alsi22.tar.gz \
 && export DOWNLOAD_URL="https://ew-development.edgekey.net/ewdev/alsi22/${EXPORTS_TARBALL}" \
 && export INSTALL_DIR="/opt/akamill" \
 && mkdir -p "${INSTALL_DIR}" \
 && curl -L ${DOWNLOAD_URL} -H "x-ew-dev:5151346410" \
  | tar zxf - -C "${INSTALL_DIR}"

FROM base AS openssl
ARG OPENSSL_VERSION=openssl-8.3.1.7-dev
RUN --mount=type=ssh export GIT_URL=ssh://git@git.source.akamai.com:7999/syscomm/openssl.git \
 && export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" \
 && export INSTALL_DIR=/opt/openssl \
 && mkdir -p /openssl \
 && cd /openssl \
 && git archive --remote="${GIT_URL}" "${OPENSSL_VERSION}" --format=tar.gz \
  | tar -zxf - \
 && ./config \
    --prefix="${INSTALL_DIR}" \
    --libdir=lib \
    enable-tls1 \
    enable-tls1_1 \
    enable-tls1_2 \
    enable-tls1_3 \
    shared \
 && make -j"$(nproc)" \
 && make install_sw

FROM base AS libcxx
ARG BUILD_OS=alsi22
RUN --mount=type=ssh export GIT_URL=ssh://git@git.source.akamai.com:7999/sources/stormcloud_v8.git \
 && export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" \
 && export GIT_SSL_NO_VERIFY=1 \
 && mkdir -p /libc++ \
 && cd /libc++ \
 && git init \
 && git remote add origin "${GIT_URL}" \
 && git archive --remote="${GIT_URL}" jswierk/libcxx libc++-${BUILD_OS}.tar.gz \
  | tar -xO \
  | git lfs smudge libc++-${BUILD_OS}.tar.gz \
  | tar -zx \
 && make -C libc++-${BUILD_OS} install DESTDIR=/opt/libc++/

FROM base AS v8
ARG BUILD_OS=alsi22
RUN --mount=type=ssh export GIT_URL=ssh://git@git.source.akamai.com:7999/sources/stormcloud_v8.git \
 && export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" \
 && export GIT_SSL_NO_VERIFY=1 \
 && mkdir -p /v8 \
 && cd /v8 \
 && git init \
 && git remote add origin "${GIT_URL}" \
 && git archive --remote="${GIT_URL}" jswierk/libcxx v8-${BUILD_OS}.tar.gz \
  | tar -xO \
  | git lfs smudge v8-${BUILD_OS}.tar.gz \
  | tar -zx \
 && make -C v8-${BUILD_OS} install DESTDIR=/opt/v8/

FROM base AS ninja
ARG NINJA_VERSION=1.13.2
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
ARG SCCACHE_VERSION=0.14.0
ADD https://github.com/mozilla/sccache/releases/download/v${SCCACHE_VERSION}/sccache-v${SCCACHE_VERSION}-x86_64-unknown-linux-musl.tar.gz /sccache.tar.gz
RUN mkdir -p /opt/sccache \
 && tar xf /sccache.tar.gz --directory=/opt/sccache --strip-components=1 --no-anchored sccache

FROM base AS cmake
ARG CMAKE_VERSION=4.2.3
ADD https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-x86_64.tar.gz /cmake.tar.gz
RUN mkdir -p /opt/cmake \
 && tar xf /cmake.tar.gz --directory=/opt/cmake --strip-components=1

FROM base AS mold
ARG MOLD_VERSION=2.40.4
ADD https://github.com/rui314/mold/releases/download/v${MOLD_VERSION}/mold-${MOLD_VERSION}-x86_64-linux.tar.gz /mold.tar.gz
RUN mkdir -p /opt/mold \
 && tar xf /mold.tar.gz --directory=/opt/mold --strip-components=1

FROM base AS capnproto
ARG CAPNPROTO_VERSION=1.0.2
COPY --from=ninja /opt/ninja/ninja /usr/local/bin/
COPY --from=cmake /opt/cmake/bin/ /usr/local/bin/
COPY --from=cmake /opt/cmake/share/ /usr/local/share/
ADD https://capnproto.org/capnproto-c++-${CAPNPROTO_VERSION}.tar.gz /capnproto.tar.gz
RUN mkdir -p /build/capnproto \
 && tar xf /capnproto.tar.gz -C /build/capnproto --strip-components=1 \
 && cd /build/capnproto \
 && cmake -Bbuild -GNinja \
 && DESTDIR=/opt/capnproto ninja -C build install

FROM base
COPY --from=akamill /opt/akamill/ /opt/akamill/
COPY --from=libcxx /opt/libc++/ /opt/libc++/
COPY --from=openssl /opt/openssl/ /opt/openssl/
COPY --from=v8 /opt/v8/ /opt/v8/
COPY --from=ninja /opt/ninja/ninja /usr/local/bin/
COPY --from=protobuf /opt/protobuf/bin /usr/local/bin/
COPY --from=protobuf /opt/protobuf/include /usr/local/include/
COPY --from=capnproto /opt/capnproto/usr/local /usr/local/
COPY --from=sccache /opt/sccache/sccache /usr/local/bin/
COPY --from=cmake /opt/cmake/bin/ /usr/local/bin/
COPY --from=cmake /opt/cmake/share/ /usr/local/share/
COPY --from=mold /opt/mold /usr/local/
ENV BUILD_OS=alsi22 \
    CARGO_TERM_COLOR=always \
    NINJA_STATUS="[%s/%f/%t] (j%r/%es/%Es/%P) " \
    SCCACHE_DIR=/project/.sccache
CMD ["/bin/bash"]
