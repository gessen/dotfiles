FROM ubuntu:focal AS base
RUN export DEBIAN_FRONTEND=noninteractive \
 && apt-get update \
 && apt-get --yes upgrade \
 && apt-get install --yes --no-install-recommends \
    ca-certificates \
    curl \
    gnupg \
 && curl -L http://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys A1715D88E1DF1F24 \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 73C9FCC9E2BB48DA \
 && echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-19 main" >> /etc/apt/sources.list \
 && echo "deb http://ppa.launchpad.net/git-core/ppa/ubuntu focal main" >> /etc/apt/sources.list \
 && echo "deb https://ppa.launchpadcontent.net/fish-shell/release-3/ubuntu/ focal main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    build-essential \
    clang-19 \
    fish \
    g++-10 \
    git \
    libcapnp-dev \
    libssl-dev \
    libseccomp-dev \
    lld-19 \
    openssh-client \
    openssh-server \
    pkg-config \
    sudo \
    unzip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/* \
 && update-alternatives \
    --install /usr/bin/clang   clang   /usr/bin/clang-19 100 \
    --slave   /usr/bin/clang++ clang++ /usr/bin/clang++-19 \
    --slave   /usr/bin/lld     lld     /usr/bin/lld-19 \
    --slave   /usr/bin/ld.lld  ld.lld  /usr/bin/ld.lld-19 \
 && update-alternatives \
    --install /usr/bin/gcc gcc /usr/bin/gcc-10 100 \
    --slave   /usr/bin/g++ g++ /usr/bin/g++-10

ARG USER
ARG USER_ID
ARG GROUP_ID

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    groupadd --gid ${GROUP_ID} ${USER} \
 && useradd \
    --no-log-init \
    --create-home \
    --skel /tmp \
    --uid ${USER_ID} \
    --gid ${USER} \
    --shell /usr/bin/fish \
    ${USER} \
 && echo "${USER}:123" | chpasswd \
 && mkdir -p /etc/sudoers.d \
 && echo "${USER} ALL=(ALL) ALL" >> /etc/sudoers.d/10-${USER} \
 && mkdir /nix \
 && chown ${USER} /nix \
; fi

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

FROM base AS protobuf
ARG PROTOBUF_VERSION=23.4
ADD https://github.com/protocolbuffers/protobuf/releases/download/v${PROTOBUF_VERSION}/protoc-${PROTOBUF_VERSION}-linux-x86_64.zip /protoc.zip
RUN mkdir -p /opt/protobuf \
 && cd /opt/protobuf \
 && unzip /protoc.zip

FROM base
COPY --from=akamill /opt/akamill/ /opt/akamill/
COPY --from=v8 /opt/v8/ /usr/local/
COPY --from=gn /opt/gn/gn /usr/local/bin/
COPY --from=protobuf /opt/protobuf/bin /usr/local/bin/
COPY --from=protobuf /opt/protobuf/include /usr/local/include/

USER ${USER}
ENV COLORTERM=truecolor \
    USER=${USER} \
    SHELL=/usr/bin/fish \
    TERM=xterm-256color

RUN mkdir -p ~/.config \
 && mkdir -p ~/.config/fish/functions \
 && mkdir -p ~/.ssh \
 && ssh-keyscan github.com >> ~/.ssh/known_hosts \
 && git clone https://github.com/gessen/dotfiles.git ~/.dotfiles --branch=akamai/docker \
 && FISHER_URL=https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
 && curl -sL $FISHER_URL > ~/.config/fish/functions/fisher.fish

RUN --mount=type=ssh,mode=0777 export NIX_INSTALLER_NO_MODIFY_PROFILE=1 \
 && curl -sL https://nixos.org/nix/install | sh -s -- --no-daemon \
 && ln -sfn ~/.dotfiles/home/config/home-manager ${HOME}/.config/home-manager \
 && ln -sfn ~/.dotfiles/home/config/nix ${HOME}/.config/nix \
 && . ~/.nix-profile/etc/profile.d/nix.sh \
 && nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager \
 && nix-channel --update \
 && nix-shell '<home-manager>' -A install \
 && mkdir -p ~/.terminfo/x \
 && cp ~/.nix-profile/share/terminfo/x/xterm-kitty ~/.terminfo/x/ \
 && chmod 664 ~/.terminfo/x/xterm-kitty

RUN export CARGO_HOME=${HOME}/.local/share/cargo \
 && export RUSTUP_HOME=${HOME}/.local/share/rustup \
 && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --no-modify-path

WORKDIR /home/${USER}
ENV AKAMILL_INSTALL_PATH=/opt/akamill \
    BUILD_OS=alsi22 \
    LD_LIBRARY_PATH=/opt/akamill/lib \
    OPENSSL_DIR=/opt/akamill \
    OPENSSL_INSTALL_PATH=/opt/akamill \
    V8_INCLUDE_PATH=/usr/local/include \
    V8_LIBRARY_PATH=/usr/local/lib
CMD ["/usr/bin/fish", "-l"]
