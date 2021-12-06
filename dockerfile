# Pull base image.
FROM ubuntu:20.04
LABEL maintainer "Kazuki Isogai <i@kazukiisogai.net>"
# ------------------------------------------------------------------------------
# Install base
RUN apt-get update -y \
  && apt-get install -y tar \
  && apt-get install -y gzip \
  && apt-get install -y git \
  && apt-get install -y curl \
  && apt-get install -y sudo
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
# ------------------------------------------------------------------------------
# Install Go
RUN curl -OL https://golang.org/dl/go1.17.linux-amd64.tar.gz \
  && tar -C /usr/local -xzf ./go1.17.linux-amd64.tar.gz
ENV PATH /usr/local/go/bin:/go/bin:$PATH
# ------------------------------------------------------------------------------
# Install MySQL
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update &&\
  apt install -y mysql-server mysql-client
# ------------------------------------------------------------------------------
# Add users
USER root
RUN useradd -G sudo -m -s /bin/bash ubuntu&&\
  echo "ubuntu ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/ubuntu&&\
  echo 'root:password' | chpasswd
USER ubuntu
# ------------------------------------------------------------------------------
# make workspace
RUN mkdir /home/ubuntu/workspace
# ------------------------------------------------------------------------------
# Expose ports
EXPOSE 1323
# ------------------------------------------------------------------------------
# Add volumes
VOLUME /home/ubuntu/workspace
WORKDIR /home/ubuntu/workspace
# ------------------------------------------------------------------------------
# Setup MySQL
USER root
RUN /etc/init.d/mysql start &&\
  mysql -e "create database ubuntu;" &&\
  mysql -e "create user 'ubuntu'@'localhost';" &&\
  mysql -e "GRANT ALL ON *.* TO 'ubuntu'@'localhost';"
USER ubuntu
RUN sed -i -e '$a sudo /etc/init.d/mysql start && clear' ~/.bashrc


ENTRYPOINT ["/bin/bash"]
