#!/bin/sh

docker build -t handshake/pgbouncer:0.1.4 .
docker push handshake/pgbouncer
