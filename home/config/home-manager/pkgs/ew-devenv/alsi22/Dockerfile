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
    fish \
    git \
    git-lfs \
    libssl-dev \
    libseccomp-dev \
    lld \
    openssh-client \
    openssh-server \
    pkg-config \
    stow \
    sudo \
    unzip \
    zlib1g-dev \
 && rm -rf /var/lib/apt/lists/*

ARG USER
ARG USER_ID
ARG GROUP_ID

RUN if [ ${USER_ID:-0} -ne 0 ] && [ ${GROUP_ID:-0} -ne 0 ]; then \
    groupadd --gid ${GROUP_ID} ${USER} || true \
 && useradd \
    --no-log-init \
    --create-home \
    --skel /tmp \
    --uid ${USER_ID} \
    --gid ${GROUP_ID} \
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
RUN export export EXPORTS_TARBALL=libakamill_exports_${AKAMILL_VERSION}_alsi22.tar.gz \
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

FROM base AS v8
ARG BUILD_OS=alsi22
RUN --mount=type=ssh export GIT_URL=ssh://git@git.source.akamai.com:7999/sources/stormcloud_v8.git \
 && export GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=accept-new" \
 && export GIT_SSL_NO_VERIFY=1 \
 && mkdir -p /v8 \
 && cd /v8 \
 && git init \
 && git remote add origin "${GIT_URL}" \
 && git archive --remote="${GIT_URL}" master v8-${BUILD_OS}.tar.gz \
  | tar -xO \
  | git lfs smudge v8-${BUILD_OS}.tar.gz \
  | tar -zx \
 && make -C v8-${BUILD_OS} install DESTDIR=/opt/v8/

FROM base
COPY --from=akamill /opt/akamill/ /opt/akamill/
COPY --from=openssl /opt/openssl/ /opt/openssl
COPY --from=v8 /opt/v8/ /opt/v8/

USER ${USER}
RUN mkdir -p "${HOME}/.config/fish/conf.d" \
 && mkdir -p "${HOME}/.config/fish/functions" \
 && mkdir -p "${HOME}/.config/emacs" \
 && mkdir -p "${HOME}/.config/environment.d" \
 && mkdir -p "${HOME}/.config/kitty" \
 && mkdir -p "${HOME}/.local/share/cargo" \
 && mkdir -p "${HOME}/.local/share/emacs" \
 && mkdir -p "${HOME}/.ssh" \
 && git clone https://github.com/gessen/dotfiles.git "${HOME}/.dotfiles" --branch=akamai/docker \
 && stow --dir "${HOME}/.dotfiles/home/config" . --target "${HOME}/.config" -v \
 && stow --dir "${HOME}/.dotfiles/home/local/share" . --target "${HOME}/.local/share" -v \
 && stow --dir "${HOME}/.dotfiles/home/ssh" . --target "${HOME}/.ssh" -v \
 && FISHER_URL=https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish \
 && curl -sL "${FISHER_URL}" > "${HOME}/.config/fish/functions/fisher.fish" \
 && fish --command "source $HOME/.config/fish/functions/fisher.fish && fisher update" \
 && ssh-keyscan github.com >> "${HOME}/.ssh/known_hosts"

RUN --mount=type=ssh,mode=0777 export NIX_INSTALLER_NO_MODIFY_PROFILE=1 \
 && curl -sL https://nixos.org/nix/install | sh -s -- --no-daemon \
 && . "${HOME}/.nix-profile/etc/profile.d/nix.sh" \
 && nix run home-manager/master switch \
 && mkdir -p "${HOME}/.terminfo/x" \
 && cp "${HOME}/.nix-profile/share/terminfo/x/xterm-kitty" "${HOME}/.terminfo/x/" \
 && chmod 664 "${HOME}/.terminfo/x/xterm-kitty"

RUN export CARGO_HOME="${HOME}/.local/share/cargo" \
 && export RUSTUP_HOME="${HOME}/.local/share/rustup" \
 && curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
  | sh -s -- -y --no-modify-path

WORKDIR /home/${USER}
ENV COLORTERM=truecolor \
    SHELL=/usr/bin/fish \
    TERM=xterm-kitty
CMD ["/usr/bin/fish", "--login"]
