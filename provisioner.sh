#!/usr/bin/env bash

log_message() {
    echo "" 
    echo $1
    sleep 2
    echo ""
}

which docker || {log_message "Docker is not installed. Please install it before running script" && exit 1}
log_message "Pulling Consul image"
docker pull consul
log_message "Starting Consul server container"
docker run -d --rm -p 8500:8500 -p 8600:8600/udp --name=cnsl-srv consul agent -server -ui -node=server-1 -bootstrap-expect=1 -client=0.0.0.0
log_message "Starting Consul client container"
addr=$(docker inspect -f '{{range.NetworkSettings.Networks}}{{.IPAddress}}{{end}}' cnsl-srv)
docker run -d --rm --name=cnsl-gnt consul agent -node=client-1 -join=$addr
log_message "Preparing Jenkins env"
cd jenkins
docker network create jenkins
groupId=$(getent group docker | awk -F ":" '{print $3}')
log_message "Building custom Jenkins image"
docker build --build-arg GID=$groupId -t jenkins .
log_message "Starting Jenkins container"
docker run --name jenkins-custom --rm --detach --network jenkins --publish 8888:8080 --publish 50000:50000 --volume /var/run/docker.sock:/var/run/docker.sock --volume jenkins-data:/var/jenkins_home --volume $(pwd)/jobs/:/var/jenkins_home/jobs --volume jenkins-docker-certs:/certs/client:ro jenkins:latest
log_message "The Jenkins is availabe via http://localhost:8888 address. Please access it and run Build/Run jobs"
