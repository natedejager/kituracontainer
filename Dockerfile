# Dockerfile to build a Docker image for running a Swift Kitura Starter App
# inside an IBM Container on Bluemix.

MAINTAINER Nate de Jager
LABEL Description="Image to run a sample Swift Kitura inside an IBM Container on Bluemix."
FROM ubuntu:wily

# Grab and Build Swift dependencies
RUN apt-get update \
    && apt-get install -q -y git wget clang dh-autoreconf pkg-config libkqueue0 libkqueue-dev libbsd-dev libblocksruntime-dev libicu-dev build-essential libhttp-parser-dev libcurl4-openssl-dev libhiredis-dev \
    && rm -rf /var/lib/apt/lists/*

# Grab and Build Swift
RUN wget https://swift.org/builds/development/ubuntu1510/swift-DEVELOPMENT-SNAPSHOT-2016-02-25-a/swift-DEVELOPMENT-SNAPSHOT-2016-02-25-a-ubuntu15.10.tar.gz

RUN tar zxf swift-DEVELOPMENT-SNAPSHOT-2016-02-25-a-ubuntu15.10.tar.gz

RUN mkdir -p /opt/swift

RUN mv swift-DEVELOPMENT-SNAPSHOT-2016-02-25-a-ubuntu15.10/usr/ /opt/swift/

ENV PATH /opt/swift/usr/bin:$PATH

# Grab and Build GCD
RUN git clone -b opaque-pointer git://github.com/seabaylea/swift-corelibs-libdispatch && \
	cd swift-corelibs-libdispatch && \
	sh ./autogen.sh && \
	./configure && \
	make && \
	make install 

# Grab and Build Kitura
#RUN wget https://github.com/IBM-Swift/Kitura/raw/master/Sources/Modulemaps/module.modulemap -O /usr/local/include/#dispatch/module.modulemap

# Grab and Build Swift Starter App
RUN wget http://ftp.exim.org/pub/pcre/pcre2-10.20.tar.gz && \
	tar zxf pcre2-10.20.tar.gz

RUN ./pcre2-10.20/configure && \
	make && \ 
	make install

EXPOSE 9080

# Add build files to image
ADD startup.sh /root

USER root
CMD ["/root/startup.sh"]