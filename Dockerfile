FROM ioft/i386-ubuntu:trusty

WORKDIR /root

RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse' >> /etc/apt/sources.list

RUN echo 'APT::Install-Suggests "0";' > /etc/apt/apt.conf.d/no-suggests
RUN echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/no-recommends
RUN apt-get update && apt-get install build-essential gcc g++ wget tar gzip make ca-certificates git nano python2.7 -y

ADD ./docker-scripts/build-coverage-pkg.sh /root/

ADD ./docker-scripts/gcc-cov /usr/bin/gcc-cov

ADD ./docker-scripts/setup-cc /usr/bin/
RUN setup-cc

ADD ./docker-scripts/build-repo.sh /root/
ADD ./docker-scripts/add-repo.bash /root/
ADD ./docker-scripts/build-and-install-coverage-pkg.sh /root/
