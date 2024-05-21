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
COPY --chown=root entrypoint.sh /entrypoint.sh
RUN chmod u+x /entrypoint.sh

WORKDIR /umass-os

# This is a dockerfile as discussed in class. Currently it launches bash
# when it starts, which means that in order to boot into xv6, we have to
# run a few commands. This is far too much work. We will fix that by 
# replacing the entrypoint below with our own script.
#
# TODO: Set the entry point to bash running entrypoint.sh. This should
# take exactly one line.
#
# BEGIN DELETE BLOCK
ENTRYPOINT [ "/bin/bash", "/entrypoint.sh" ]
# END DELETE BLOCK