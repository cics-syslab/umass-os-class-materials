# syntax=docker/dockerfile:1
FROM ubuntu:latest

# Necessary for pwndbg
ENV LANG en_US.UTF-8
ENV LC_CTYPE C.UTF-8

RUN apt-get update

# Install umass-os requirements
RUN apt-get install -y build-essential gdb-multiarch qemu-system-misc gcc-riscv64-linux-gnu binutils-riscv64-linux-gnu

# Install dev requirements
RUN apt-get install -y tmux git
RUN echo "set auto-load safe-path /" >> /root/.gdbinit

# Install pwndbg
RUN apt-get install -y python3 python3-pip
WORKDIR /opt
RUN git clone https://github.com/pwndbg/pwndbg
WORKDIR /opt/pwndbg
RUN ./setup.sh

# Copy tmux script in
COPY --chown=root docker-entry.sh /docker-entry.sh
RUN chmod u+x /entry-point.sh

WORKDIR /umass-os
ENTRYPOINT [ "/bin/bash", "/entry-point.sh" ]