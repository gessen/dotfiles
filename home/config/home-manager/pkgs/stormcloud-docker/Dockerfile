FROM ubuntu:focal

RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get --yes upgrade \
 && apt-get install --yes --no-install-recommends \
    ca-certificates \
    gnupg \
    wget \
 && wget -O - http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 \
 && echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-16 main" >> /etc/apt/sources.list \
 && echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    build-essential \
    cmake \
    clang \
    capnproto \
    clang \
    curl \
    git \
    libcapnp-dev \
    libglib2.0-dev \
    libssl-dev \
    libseccomp-dev \
    libicu-dev \
    libunwind8-dev \
    openssh-client \
    pkg-config \
    python-yaml \
    unzip \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN export EXPORTS_TARBALL=libakamill2.6_exports-alsi11.tar.gz \
 && export DOWNLOAD_URL="https://ew-development.edgekey.net/ewdev/${EXPORTS_TARBALL}" \
 && export INSTALL_DIR="/opt/stormcloud-akamill" \
 && mkdir -p "${INSTALL_DIR}" \
 && curl -L ${DOWNLOAD_URL} -H "x-ew-dev:5151346410" \
  | tar zxf - -C "${INSTALL_DIR}"

RUN --mount=type=ssh export GIT_URL=ssh://git@git.source.akamai.com:7999/syscomm/openssl.git \
 && export GIT_BRANCH=openssl-8.3.0.8-dev \
 && export AKAMAI_GIT_SSH_KEY="git.source.akamai.com ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+YHpZdF6TFnN9ioUoKjBznsW0pWnlBghp4HJt68RIa3ZkUuN6gO6d5JTbaBgHPy1vpGuxC/egVk70JMGbPVfTHyyfuIDgp/6vlCRSPGXv5XRzANR6o6kSOg+JEY71SLiCPMUgm8SoqxJogBPSkBRyjkq4sAWscJ5QXW4Xgqda7tkjVqWTNYA2/4U7wMFRLl9Hag+qepZu6/ahDRkrabMwxP0BHuBvYHZQ6mQuTwkZkEl2ICzOZgOZYrzU9NAu72iMTCw0SGH2+G5VEgsA2As1k0IWObPiZ+O/8qHV0j4rHC+a9zfH4QI/fbGk1H37sPGmmAvkXs+wBMj4LS9/o14L" \
 && mkdir -p "${HOME}/.ssh" \
 && echo "${AKAMAI_GIT_SSH_KEY}" >> "${HOME}/.ssh/known_hosts" \
 && git clone "${GIT_URL}" --branch="${GIT_BRANCH}" --depth=1 \
 && cd /openssl \
 && ./config --prefix="/opt/stormcloud-openssl" \
    enable-tls1 \
    enable-tls1_1 \
    enable-tls1_2 \
    enable-tls1_3 \
    shared \
 && make install_sw \
 && rm -rf /openssl

RUN --mount=type=ssh export GIT_URL=ssh://git@git.source.akamai.com:7999/sources/stormcloud_v8.git \
 && curl -OLJ https://chrome-infra-packages.appspot.com/dl/gn/gn/linux-amd64/+/git_revision:d565aa3e72dd9e81da9595ee8c9d7b24cb45c48b \
 && unzip -o gn-linux-amd64.zip \
 && mv gn /usr/local/bin/gn \
 && chmod +x /usr/local/bin/gn \
 && rm gn-linux-amd64.zip \
 && curl -OLJ https://github.com/ninja-build/ninja/releases/download/v1.11.1/ninja-linux.zip \
 && unzip ninja-linux.zip \
 && mv ninja /usr/local/bin/ninja \
 && chmod +x /usr/local/bin/ninja \
 && rm ninja-linux.zip \
 && git clone "${GIT_URL}" --depth=1 \
 && cd /stormcloud_v8 \
 && mkdir -p v8/out.gn/x64-release \
 && cp args.gn v8/out.gn/x64-release/args.gn \
 && cd v8 \
 && gn gen out.gn/x64-release \
 && ninja -C out.gn/x64-release/ v8_monolith \
 && cp out.gn/x64-release/obj/libv8_monolith.a /usr/local/lib/libv8_monolith.a \
 && cp -r ./include/* /usr/local/include/ \
 && rm -rf /stormcloud_v8

RUN curl -JL https://github.com/mozilla/sccache/releases/download/v0.7.4/sccache-v0.7.4-x86_64-unknown-linux-musl.tar.gz \
  | tar xzf - -C /usr/local/bin --strip-components 1 \
 && chmod +x /usr/local/bin/sccache \
 && mkdir /sccache \
 && chmod -R 777 /sccache

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path --default-toolchain stable \
 && "${HOME}/.cargo/bin/rustup" default stable \
 && "${HOME}/.cargo/bin/rustup" component add rust-src \
 && "${HOME}/.cargo/bin/rustup" component add rustfmt-preview \
 && echo 'source "${HOME}/.cargo/env"' >> "${HOME}/.bashrc"

RUN curl -OLJ https://github.com/protocolbuffers/protobuf/releases/download/v23.4/protoc-23.4-linux-x86_64.zip \
 && unzip protoc-23.4-linux-x86_64.zip \
 && mv bin/protoc /usr/local/bin/ \
 && mv include/google/* /usr/local/include/google/ \
 && rm protoc-23.4-linux-x86_64.zip readme.txt

ENV AKAMILL_INSTALL_PATH=/opt/stormcloud-akamill \
    BUILD_OS=alsi11 \
    LD_LIBRARY_PATH=/opt/stormcloud-openssl/lib \
    OPENSSL_DIR=/opt/stormcloud-openssl

CMD ["/bin/bash"]
