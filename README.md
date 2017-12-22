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

## Usage in GKE

To use with GKE, run this container alongside the `cloudsql-docker/gce-proxy`. Your configuration might look something like below

```
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: pgbouncer-configs
data:
  DB_HOST: "127.0.0.1"
  DB_PORT: "5432"
---
apiVersion: extensions/v1beta1
kind: Deployment
metadata:
  name: pgbouncer
  labels:
    tier: database
spec:
  replicas: 1
  minReadySeconds: 20
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
  template:
    metadata:
      labels:
        tier: database
    spec:
      containers:
        - image: handshake/pgbouncer:0.1.2
          name: pgbouncer
          ports:
            - containerPort: 6432
              protocol: TCP
          envFrom:
            - configMapRef:
                name: pgbouncer-configs
          readinessProbe:
            tcpSocket:
              port: 6432
            initialDelaySeconds: 5
            periodSeconds: 10
          livenessProbe:
            tcpSocket:
              port: 6432
            initialDelaySeconds: 15
            periodSeconds: 20
          resources:
            requests:
              cpu: 100m
              memory: 300m
        - image: gcr.io/cloudsql-docker/gce-proxy:1.11    # Gcloud SQL Proxy
          name: cloudsql-proxy
          command:
            - /cloud_sql_proxy
            - --dir=/cloudsql
            - -instances=$(DATABASE_INSTANCE_NAMES)
            - -credential_file=/secrets/cloudsql_credentials.json
          ports:
            - containerPort: 5432
              protocol: TCP
          volumeMounts:
            - name: cloudsql-credentials
              mountPath: /secrets/cloudsql
              readOnly: true
            - name: cloudsql
              mountPath: /cloudsql
      volumes:
        - name: cloudsql-credentials
          secret:
            secretName: cloudsql-credentials
        - name: cloudsql
          emptyDir:
---
apiVersion: v1
kind: Service
metadata:
  name: pgbouncer-service
spec:
  type: NodePort
  ports:
  - name: pgbouncer-service-port
    protocol: TCP
    port: 6432
    targetPort: 6432
    nodePort: 0
  selector:
    tier: database
```

## Inspiration

This container takes inspiration from [https://github.com/heroku/heroku-buildpack-pgbouncer](https://github.com/heroku/heroku-buildpack-pgbouncer) and [https://github.com/guizmaii/pgbouncer](https://github.com/guizmaii/pgbouncer). Thanks to both!