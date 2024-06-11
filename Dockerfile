FROM docker.io/library/haproxy:3.0.1-alpine

# Switch to the root user and DO NOT CHANGE BACK! THE ORIGINAL SOCKET CAN BE ACCESSED ONLY IF THE USER RUNNING HAPROXY IS ROOT!!!
USER root

# Create folders where to put the sockets
RUN mkdir -p "/docker"

RUN mkdir -p "/proxied"

# Allow only minimal permissions by default
ENV ALLOW_RESTARTS=0 \
    AUTH=0 \
    BUILD=0 \
    COMMIT=0 \
    CONFIGS=0 \
    CONTAINERS=0 \
    DISTRIBUTION=0 \
    DOCKER_SOCKET_PATH="/docker/docker.sock" \
    EVENTS=1 \
    EXEC=0 \
    GRPC=0 \
    IMAGES=0 \
    INFO=0 \
    LOG_LEVEL=info \
    NETWORKS=0 \
    NODES=0 \
    PING=1 \
    PLUGINS=0 \
    POST=0 \
    PROXIED_SOCKET_PATH="/proxied/docker.sock" \
    SECRETS=0 \
    SERVICES=0 \
    SESSION=0 \
    SWARM=0 \
    SYSTEM=0 \
    TASKS=0 \
    VERSION=1 \
    VOLUMES=0

COPY haproxy/haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg