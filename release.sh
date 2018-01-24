#!/bin/sh

docker build -t handshake/pgbouncer:0.1.5 .
docker push handshake/pgbouncer
