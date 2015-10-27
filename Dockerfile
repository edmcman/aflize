# you can try replacing "sid" with sid.
FROM 32bit/ubuntu:14.04
#RUN echo 'deb-src http://httpredir.debian.org/debian sid main' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-updates main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-backports main restricted universe multiverse' >> /etc/apt/sources.list
RUN echo 'deb-src http://us.archive.ubuntu.com/ubuntu/ trusty-security main restricted universe multiverse' >> /etc/apt/sources.list

ADD ./aflize /usr/bin/aflize

# If you'd like to specify a list of packages to be built, uncomment the
# following line by removing the # symbol at its beginning:
# ADD ./packages.list /root/

RUN echo 'APT::Install-Suggests "0";' > /etc/apt/apt.conf.d/no-suggests
RUN echo 'APT::Install-Recommends "0";' > /etc/apt/apt.conf.d/no-recommends
RUN apt-get update && apt-get install build-essential gcc g++ wget tar gzip make ca-certificates vim -y
RUN wget 'http://lcamtuf.coredump.cx/afl/releases/afl-latest.tgz' -O- | tar zxvf - && cd afl-* && make PREFIX=/usr install

# Make sure afl-gcc will be run. This forces us to set AFL_CC and AFL_CXX or
# otherwise afl-gcc will be trying to call itself by calling gcc.
ADD ./afl-sh-profile /etc/profile.d/afl-sh-profile
RUN ln -s /etc/profile.d/afl-sh-profile /etc/profile.d/afl-sh-profile.sh

# It looks like /etc/profile.d isn't read for some reason, but .bashrc is.
# Let's include /etc/profile.d/afl-sh-profile from there.
RUN echo '. /etc/profile.d/afl-sh-profile' >> /root/.bashrc && chmod +x /root/.bashrc

RUN chmod +x /etc/profile.d/afl-sh-profile

ADD ./afl-fuzz-parallel /usr/bin/

#ADD ./install-preeny.sh /tmp/
#RUN /tmp/install-preeny.sh

RUN mkdir ~/pkg ~/pkgs ~/logs

# This isn't really necessary, but it'd be a real convenience for me.
#RUN apt-get update && apt-get install apt-file -y && apt-file update

# install "exploitable" GDB script
#RUN apt-get update && apt-get install gdb python -y
#RUN wget -O- 'https://github.com/jfoote/exploitable/archive/master.tar.gz' | tar zxvf - && cd exploitable-master && python setup.py install

RUN mkdir ~/fuzz-results ~/pkgs-coverage
RUN apt-get install lcov -y
ADD ./testcases /root/testcases
ADD ./fuzz-pkg-with-coverage.sh /root/
ADD ./build-coverage-pkg.sh /root/

ADD ./go-cov.bash /root/
ADD ./packages /root/
RUN cd /root && bash ./go-cov.bash

ADD ./setup-afl_cc /usr/bin/setup-afl_cc
RUN setup-afl_cc

ADD ./go-afl.bash /root/
RUN cd /root && bash ./go-afl.bash

RUN cd /root/pkgs && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz && cd /root/pkgs-coverage && dpkg-scanpackages . /dev/null | gzip -9c > Packages.gz