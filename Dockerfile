FROM ioft/i386-ubuntu:trusty

RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse' >> /etc/apt/sources.list

RUN echo 'APT::Install-Suggests "0";' > /etc/apt/apt.conf.d/no-suggests
RUN echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/no-recommends
RUN apt-get update && apt-get install build-essential gcc g++ wget tar gzip make ca-certificates git nano python2.7 -y

RUN apt-get install lcov -y

ADD ./build-coverage-pkg.sh /root/

RUN cd /root && git clone https://github.com/mrash/afl-cov.git

ADD ./gcc-cov /usr/bin/gcc-cov

ADD ./setup-cc /usr/bin/setup-cc
RUN setup-cc

ADD ./build-repo.sh /root/build-repo.sh
ADD ./add-repo.bash /root/add-repo.bash

