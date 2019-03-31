FROM ubuntu:18.04

RUN apt update \
        && apt install -y \
            build-essential \
            clang-7 \
            clang-format-7 \
            clang-tools-7 \
            cmake \
            curl \
            ninja-build \
            openssh-server \
            python3 \
            python3-pip \
            sudo \
            vim \
            whois \
        && rm -rf /var/lib/apt/lists*

RUN pip3 install -U pynvim
RUN curl -L https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz | tar -zxf - --strip=1 -C /usr/local/

RUN sed -i.bak "s;#PasswordAuthentication yes;PasswordAuthentication yes;g" /etc/ssh/sshd_config
RUN mkdir /var/run/sshd

ARG WORKUSR=dev
RUN useradd -m -p `echo "$WORKUSR" | mkpasswd -s -m sha-512` -s /bin/bash $WORKUSR && gpasswd -a $WORKUSR sudo

#CMD ["/usr/sbin/sshd", "-D"]
#CMD ["/bin/bash", "-c", "'mkdir -p /home/dev/.cache/nvim && mkdir -p /home/dev/.config/ && chown -R dev:dev /home/dev/ && /usr/bin/sshd -D'"]
#CMD ["/bin/bash", "-c", "'mkdir -p /home/dev/.cache/nvim && mkdir -p /home/dev/.config/ && chown -R dev:dev /home/dev/'"]

