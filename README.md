# Dockerproxy

Dockerproxy is a custom fork of the docker-socket-proxy container from tecnativa.

It has been configured to only use sockets, which allows the container to be operated with 
its network stack disabled, for added security.

Dockerproxy helps in giving out only the bare minimum permissions to containers which need 
to use the docker API for whathever reason.

Unfiltered access to the docker socket could allow a malicious actor to gain root privileges
to the host machine, as well as controlling the entire docker stack.
By filtering the API and allowing only the bare minimum endpoints for the container to work, 
it is possible to significantly reduce the attack surface.

## Configuration

Each docker endpoint allows for 3 types of actions: HEAD, GET and POST.
HEAD and GET are read-only actions, which can only "leak" data in the worst situation, 
while a POST action means to modify settings or content.

By default, this image only allows to read the api version, listen for container events 
such as start, stop, restart, and ping.
All other actions are rejected by default, but can be allowed when creating the container 
by setting the relative environment variable to 1.

| ENV VARIABLE | DESCRIPTION                                                                                                      | DEFAULT |
|--------------|------------------------------------------------------------------------------------------------------------------|---------|
| POST         | Allow issuing command which can change docker components                                                         | 0       |
| VERSION      | Returns the version of Docker that is running and various information about the system that Docker is running on | 1       |
| PING         | Dummy endpoint to test if the api is reachable                                                                   | 1       |
| EVENTS       | Streams events appening in docker real-time, like volume creation, a container stopping...                       | 1       |
| AUTH         | Validate registry credentials and issue registry identity tokens                                                 | 0       |
| SECRETS      | Allows managing secrets                                                                                          | 0       |
| BUILD        | Build a container image from a Dockerfile                                                                        | 0       |
| COMMIT       | Create a new image from an existing container                                                                    | 0       |
| CONFIGS      | Manage configuration files for swarm containers                                                                  | 0       |
| CONTAINERS   | Create and manage containers                                                                                     | 0       |
| DISTRIBUTION | Return image digest and platform information by contacting the registry                                          | 0       |
| EXEC         | Run new commands inside running containers                                                                       | 0       |
| GRPC         | Undocumented endpoint called by "docker buildx"                                                                  | 0       |
| IMAGES       | Manages images on the server                                                                                     | 0       |
| INFO         | Get system information                                                                                           | 0       |
| NETWORKS     | Manage docker networks                                                                                           | 0       |
| NODES        | Manage docker swarm nodes                                                                                        | 0       |
| PLUGINS      | Manage docker plugins                                                                                            | 0       |
| SERVICES     | Manage swarm services                                                                                            | 0       |
| SESSION      | Experimental endpoint that opens an interactive connection to the api for advanced use cases                     | 0       |
| SWARM        | Manage swarm deployments                                                                                         | 0       |
| SYSTEM       | Get disk usage information from the system                                                                       | 0       |
| TASKS        | Manage swarm containers (also known as tasks)                                                                    | 0       |
| VOLUMES      | Manage docker volumes                                                                                            | 0       |

Any other endpoint that is not listed here will be rejected by default to prevent new or unknown endpoint from being accessed without permission.

## Usage

The container must be started with the following parameters:
- cap_drop: ALL
  - Drop all unnecessary capabilities
- cap_add:  CAP_DAC_OVERRIDE
  - Needed to allow creating the proxied socket
- security_opt: ["label=disable"]
  - At least on systems with SELINUX enabled and/or podman hosts, allows actually connecting to the docker/podman socket
- network: none
  - Not really a must, but the fork was built just to disable the networking stack, and that's what this does

Some examples are provided in the ```examples``` folder.

## Logging

You can set the logging level or severity level of the messages to be logged with the
environment variable `LOG_LEVEL`. Defaul value is info. Possible values are: debug,
info, notice, warning, err, crit, alert and emerg.