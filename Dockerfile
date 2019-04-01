FROM ubuntu:18.04
ARG LLVM_VERSION=7
RUN apt update \
        && apt install -y \
            build-essential \
            clang-${LLVM_VERSION} \
            clang-format-${LLVM_VERSION} \
            clang-tools-${LLVM_VERSION} \
            llvm-${LLVM_VERSION} \
            lldb-${LLVM_VERSION} \
            cmake \
            curl \
            git \
            ninja-build \
            openssh-server \
            python3 \
            python3-pip \
            sudo \
            vim \
            whois \
        && rm -rf /var/lib/apt/lists/*

RUN pip3 install -U pynvim
RUN curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | tar -zxf - --strip=1 -C /usr/local/

RUN sed -i.bak "s;#PasswordAuthentication yes;PasswordAuthentication yes;g" /etc/ssh/sshd_config

ARG WORKUSR=dev
RUN useradd -m -p `echo "$WORKUSR" | mkpasswd -s -m sha-512` -s /bin/bash $WORKUSR && gpasswd -a $WORKUSR sudo
RUN mkdir -p /var/run/sshd /home/dev/.cache /home/dev/.config
RUN curl -L https://raw.githubusercontent.com/Shougo/dein.vim/master/bin/installer.sh | bash -s -- /home/dev/.cache/dein

