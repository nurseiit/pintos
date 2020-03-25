FROM ubuntu:16.04
MAINTAINER Nurseiit A <nurs@unist.ac.kr>

# Install essential toolchain
RUN apt-get update && \
      DEBIAN_FRONTEND=noninterative \
      apt-get install -y --no-install-recommends \
      build-essential \
      libncurses5-dev texinfo gdb \
      gcc-multilib

# Install useful programs
RUN apt-get install -y wget vim

# Prerequisites for bochs
RUN apt-get install -y libx11-dev libxrandr-dev xorg-dev

WORKDIR /tmp

# Fetch & unpack helper scripts
RUN wget https://github.com/nurseiit/pintos/raw/master/helpers.tar.gz \
      && tar -xzf helpers.tar.gz

WORKDIR /tmp/helpers

# Install  & Patch bochs
RUN sh bochs-2.6.2-build.sh /usr/local/

# Install qemu
RUN DEBIAN_FRONTEND=noninterative \
      apt-get install -y qemu libvirt-bin

# Clean up apt-get's files
RUN apt-get clean autoclean && \
      rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/*

# Link qemu executable
RUN ln -s /usr/bin/qemu-system-x86_64 /usr/bin/qemu

# For the qemu simulator to work as intended,
# one needs to do the following to fix an ACPI bug
# as described here under "Troubleshooting":
# http://arpith.xyz/2016/01/getting-started-with-pintos/
#
# $ sed -i '/serial_flush ();/a outw( 0x604, 0x0 | 0x2000 );' /pintos/src/devices/shutdown.c

# Prepare the Pintos directory
WORKDIR /tmp

# Fetch official pintos.tar.gz
RUN wget http://www.stanford.edu/class/cs140/projects/pintos/pintos.tar.gz

# Unpack and move
RUN tar -xzf pintos.tar.gz && \
      mv ./pintos /pintos && \
      rm -rf ./pintos.tar.gz ./pintos

# Add Pintos to PATH
ENV PATH=/pintos/src/utils:$PATH

WORKDIR /pintos

CMD ["bash"]
