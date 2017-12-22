FROM alpine:3.6

# Base libraries
RUN apk update && \
    apk upgrade && \
    apk --update add automake build-base libevent-dev curl openssl-dev

# Install and compile pgbouncer
RUN curl https://pgbouncer.github.io/downloads/files/1.8.1/pgbouncer-1.8.1.tar.gz | tar xvz
RUN cd pgbouncer-1.8.1 && ./configure --prefix=/usr/local --with-libevent=libevent-prefix && make && make install

# Cleanup 
RUN apk del git build-base automake autoconf libtool m4 && \
    rm -f /var/cache/apk/* && \
    cd .. && rm -Rf pgbouncer-1.8.1

ADD entrypoint.sh ./

ENTRYPOINT ["./entrypoint.sh"]