# syntax=docker/dockerfile:1
FROM ubuntu:latest

# Necessary for pwndbg
ENV LANG en_US.UTF-8
ENV LC_CTYPE C.UTF-8

RUN apt update

# Install umass-os requirements
RUN apt install -y build-essential gdb-multiarch qemu-system-misc gcc-riscv64-linux-gnu binutils-riscv64-linux-gnu

# Install pwndbg
RUN apt install -y git python3 python3-pip
WORKDIR /opt
RUN git clone https://github.com/pwndbg/pwndbg
WORKDIR /opt/pwndbg
RUN ./setup.sh
RUN echo "add-auto-load-safe-path /umass-os/.gdbinit" >> /root/.gdbinit

# Install dev requirements
RUN apt install -y tmux

WORKDIR /
ENTRYPOINT [ "/bin/bash" ]