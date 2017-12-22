# pgbouncer-docker

A docker container running a configurable pgbouncer. Optimized for running Kubernetes on GKE with Cloud SQL Postgres.

Dockerhub: [https://hub.docker.com/r/handshake/pgbouncer/](https://hub.docker.com/r/handshake/pgbouncer/)

## Configuration

### DB_USER

The database username

### DB_PASSWORD

The database password

### DB_HOST

The IP or host of the database. If using cloud sql proxy, this will most likely be `127.0.0.1`.

### DB_PORT

The IP or host of the database. If using cloud sql proxy, this will most likely be `5432`, or the port you pass into the Cloud SQL command args.

## Inspiration

This container takes inspiration from [https://github.com/heroku/heroku-buildpack-pgbouncer](https://github.com/heroku/heroku-buildpack-pgbouncer) and [https://github.com/guizmaii/pgbouncer](https://github.com/guizmaii/pgbouncer). Thanks to both!