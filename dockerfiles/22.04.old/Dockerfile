FROM ubuntu:22.04
WORKDIR /root

RUN dpkg --add-architecture i386
RUN apt update
RUN apt install software-properties-common -y
RUN apt install libc6:i386 libncurses5:i386 libstdc++6:i386 -y
RUN apt install build-essential netcat unzip pkg-config wget git curl fish locales -y
RUN apt install python3 python3-pip -y
RUN apt install zlib1g-dev libssl-dev -y
RUN add-apt-repository ppa:neovim-ppa/stable
RUN apt update
RUN apt install neovim -y

# Locales
RUN locale-gen en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LANG en_US.UTF-8

RUN git clone https://github.com/rbenv/rbenv.git /root/.rbenv
ENV PATH=/root/.rbenv/bin:$PATH
RUN wget -q https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer -O- | bash
RUN echo "status --is-interactive; and rbenv init - fish | source" >> /etc/fish/config.fish

RUN rbenv install 3.1.3
RUN rbenv global 3.1.3
RUN /root/.rbenv/shims/gem install one_gadget pwntools

RUN python3 -m pip install --upgrade pip
RUN python3 -m pip install --upgrade pwntools
RUN python3 -m pip install --upgrade r2pipe

RUN apt install gdb -y
RUN git clone https://github.com/pwndbg/pwndbg
WORKDIR /root/pwndbg
RUN ./setup.sh

WORKDIR /root
RUN git clone https://github.com/radare/radare2 && radare2/sys/install.sh
RUN r2pm init
RUN r2pm -ci r2ghidra
RUN r2pm -ci r2dec

# Just for fish...
WORKDIR /hacks
RUN chsh -s /usr/bin/fish
ENV SHELL "/usr/bin/fish"

VOLUME /hacks
ENTRYPOINT [ "/usr/bin/fish" ]
