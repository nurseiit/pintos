FROM ubuntu:16.04
MAINTAINER Nurseiit A <nurs@unist.ac.kr>

# Install set up tools
RUN apt-get update && \
      DEBIAN_FRONTEND=noninterative \
      apt-get install -y --no-install-recommends \
      wget tar

# Prepare the Pintos directory
WORKDIR /tmp
RUN wget http://www.stanford.edu/class/cs140/projects/pintos/pintos.tar.gz \
      --no-check-certificate
RUN tar -xzf pintos.tar.gz && \
      mv ./pintos /pintos && \
      rm -rf ./pintos.tar.gz ./pintos

# Install useful user programs
RUN apt-get update && \
      DEBIAN_FRONTEND=noninterative \
      apt-get install -y --no-install-recommends \
      coreutils \
      xorg-dev openbox \
      ncurses-dev \
      vim make \
      gcc g++ gdb \
      ddd qemu

# Add older gcc version sources
RUN echo 'deb     http://snapshot.debian.org/archive/debian/20070730T000000Z/ lenny main' >> /etc/apt/sources.list
RUN echo 'deb-src http://snapshot.debian.org/archive/debian/20070730T000000Z/ lenny main' >> /etc/apt/sources.list
RUN echo 'deb     http://snapshot.debian.org/archive/debian-security/20070730T000000Z/ lenny/updates main' >> /etc/apt/sources.list
RUN echo 'deb-src http://snapshot.debian.org/archive/debian-security/20070730T000000Z/ lenny/updates main' >> /etc/apt/sources.list

# Install older gcc/g++ versions for bochs
RUN apt-get update && apt-get install -y --allow-unauthenticated \
      gcc-3.4 g++-3.4 gcc-4.2 \
      && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-3.4 20 \
      && update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.2 10 \
      && update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-3.4 20

# Clean up apt-get's files
RUN apt-get clean autoclean && \
      rm -rf /var/lib/apt/* /var/lib/cache/* /var/lib/log/*

# Link missing objects
RUN ln -s /usr/lib/x86_64-linux-gnu/crt1.o /usr/lib/crt1.o
RUN ln -s /usr/lib/x86_64-linux-gnu/crti.o /usr/lib/crti.o
RUN ln -s /usr/lib/x86_64-linux-gnu/crtn.o /usr/lib/crtn.o
RUN ln -s /lib/x86_64-linux-gnu/libgcc_s.so.1 /usr/lib/libgcc_s.so

# Fetch bochs simulator
RUN wget https://sourceforge.net/projects/bochs/files/bochs/2.2.6/bochs-2.2.6.tar.gz \
      --no-check-certificate

# Patch and Install bochs
RUN env SRCDIR=/tmp PINTOSDIR=/pintos/ DSTDIR=/usr/local/ \
      sh /pintos/src/misc/bochs-2.2.6-build.sh \
      rm bochs-2.2.6.tar.gz

# Link qemu executable
RUN ln -s /usr/bin/qemu-system-i386 /usr/bin/qemu

# For the qemu simulator to work as intended,
# one needs to do the following to fix an ACPI bug
# as described here under "Troubleshooting":
# http://arpith.xyz/2016/01/getting-started-with-pintos/
#
# $ sed -i '/serial_flush ();/a outw( 0x604, 0x0 | 0x2000 );' /pintos/src/devices/shutdown.c

# Add Pintos to PATH
ENV PATH=/pintos/src/utils:$PATH

WORKDIR /pintos

CMD ["bash"]
