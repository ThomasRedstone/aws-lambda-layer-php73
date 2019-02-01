FROM amazonlinux:2.0.20190115
#!/bin/bash

# Update packages and install needed compilation dependencies
RUN yum update -y && yum install autoconf bison gcc gcc-c++ libcurl-devel libxml2-devel tar make -y

RUN yum install make -y gzip gunzip

# Compile OpenSSL v1.0.1 from source, as Amazon Linux uses a newer version than the Lambda Execution Environment, which
# would otherwise produce an incompatible binary.
#RUN curl -sL http://www.openssl.org/source/openssl-1.0.1k.tar.gz | tar -xvz
#RUN cd openssl-1.0.1k && ./config && make && make install

RUN curl -sL https://github.com/openssl/openssl/archive/OpenSSL_1_1_1a.tar.gz | tar -xvz
RUN cd openssl-OpenSSL_1_1_1a && ./config && make && make install
RUN cp -R /usr/local/ssl /opt/ssl
RUN mkdir /build
RUN cp -R /usr/local/include/openssl /opt/ssl/openssl
COPY ./docs/compile_php.sh /build/
ENV PHP_VERSION=7.3.1

WORKDIR /root/
# Download the PHP source
RUN mkdir php-7-bin && \
    curl -sL https://github.com/php/php-src/archive/php-${PHP_VERSION}.tar.gz | tar -xvz

WORKDIR /root/php-src-php-${PHP_VERSION}

# Compile PHP 7.3.0 with OpenSSL 1.0.1 support, and install to /home/ec2-user/php-7-bin
RUN ./buildconf --force

#RUN find /opt -name opensslv.h
#RUN find /usr/local -name opensslv.h
RUN find /opt -name evp.h
RUN find /usr/local -name epv.h


RUN ./configure --prefix=/root/php-7-bin/ --with-openssl=/opt/include/ssl --with-curl --with-zlib
#RUN export LC_ALL=en_US.UTF-8 && make install


#RUN cp /root/php-7-bin/bin/php /build/ && cp -R /opt/ssl /build/ && cp -R /opt/include /build/
