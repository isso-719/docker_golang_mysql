FROM amazonlinux:latest
LABEL maintainer "Kazuki Isogai <i@kazukiisogai.net>"

# set environments
ENV GOPATH /go
ENV PATH /usr/local/go/bin:/go/bin:$PATH

# go install
RUN yum update -y \
    && yum install -y tar \
    && yum install -y gzip \
    && curl -OL https://golang.org/dl/go1.17.linux-amd64.tar.gz \
    && tar -C /usr/local -xzf ./go1.17.linux-amd64.tar.gz

# git install for go get command
RUN yum install -y git

# mysql install
RUN yum remove -y mariadb-libs \
    &&yum localinstall -y https://dev.mysql.com/get/mysql80-community-release-el7-2.noarch.rpm \
    && yum install -y mysql-server

# initialize workspace
RUN mkdir /home/workspace
VOLUME /home/workspace
WORKDIR /home/workspace

# go libraries
# RUN go mod init example.com/m/v2
# RUN go mod tidy

# expose port
EXPOSE 1323

RUN cp /etc/skel/.bash* ~ \
    && sed -i -e '$a /etc/init.d/mysqld start && clear' ~/.bashrc

# set entrypoint
ENTRYPOINT ["/bin/bash"]