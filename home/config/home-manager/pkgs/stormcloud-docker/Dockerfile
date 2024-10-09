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
 && echo "deb http://apt.llvm.org/focal/ llvm-toolchain-focal-19 main" >> /etc/apt/sources.list \
 && apt-get update \
 && apt-get install --yes --no-install-recommends \
    build-essential \
    git \
    libssl-dev \
    openssh-client \
    nano \
    pkg-config \
    sudo \
    xz-utils \
    zlib1g-dev \
    zsh \
 && rm -rf /var/lib/apt/lists/*

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
    --shell /bin/zsh \
    ${USER} \
 && echo "${USER}:123" | chpasswd \
 && mkdir -p /etc/sudoers.d \
 && echo "${USER} ALL=(ALL) ALL" >> /etc/sudoers.d/10-${USER} \
; fi
USER ${USER}
ENV USER=${USER} \
    TERM=xterm-256color

RUN mkdir -p ~/.config \
 && git clone https://github.com/gessen/dotfiles.git ~/.dotfiles --branch=akamai/vm \
 && git clone https://github.com/rbenv/rbenv.git ~/.local/share/rbenv

WORKDIR /home/${USER}
CMD ["/bin/zsh"]
