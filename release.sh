#!/bin/sh

docker build -t handshake/pgbouncer:0.1.2 .
docker push handshake/pgbouncer