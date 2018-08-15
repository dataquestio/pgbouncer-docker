FROM alpine:3.6

# Base libraries
RUN apk update && \
    apk upgrade && \
    apk --update add automake build-base libevent-dev curl openssl-dev postgresql-client

# Install and compile pgbouncer
RUN curl https://pgbouncer.github.io/downloads/files/1.9.0/pgbouncer-1.9.0.tar.gz | tar xvz
RUN cd pgbouncer-1.9.0 && ./configure --prefix=/usr/local --with-libevent=libevent-prefix && make && make install

# Cleanup
RUN apk del git build-base automake autoconf libtool m4 && \
    rm -f /var/cache/apk/* && \
    cd .. && rm -Rf pgbouncer-1.9.0

ADD VERSION .
ADD entrypoint.sh ./

ENTRYPOINT ["./entrypoint.sh"]
