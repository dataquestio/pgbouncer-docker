#!/bin/sh

docker build -t handshake/pgbouncer:0.1.3 .
docker push handshake/pgbouncer
