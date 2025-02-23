# FROM kalilinux/kali-rolling
FROM ubuntu:24.04

# Set the non-interactive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Set build arguments for UID and GID
ARG USER_UID=109026
ARG USER_GID=10000425

# Update the package list and install necessary packages
# RUN apt-get install -y --no-install-recommends \
RUN set -e && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    clang \
    clangd \
    build-essential \
    gdb \
    cmake \
    python3 \
    python3-pip \
    openssh-server \
    rsync \
    locales \
    sudo \
    tzdata

# **Install Conan using pip**
RUN pip3 install conan --upgrade --break-system-packages # [[4]]

# Configure timezone and locale
RUN ln -fs /usr/share/zoneinfo/Etc/UTC /etc/localtime && dpkg-reconfigure --frontend noninteractive tzdata
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Create a group and user with the same UID and GID as the host user
RUN groupadd -g ${USER_GID} devuser && \
    useradd -m -u ${USER_UID} -g ${USER_GID} -s /bin/bash devuser && \
    echo 'devuser:password' | chpasswd && \
    usermod -aG sudo devuser

# Set the working directory
WORKDIR /home/devuser

# Expose SSH port
EXPOSE 22

# Configure and start SSH service
RUN mkdir /var/run/sshd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config

# Set entrypoint to start SSH daemon
CMD ["/usr/sbin/sshd", "-D"]
