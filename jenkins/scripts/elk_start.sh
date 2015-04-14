#!/bin/bash
cd "$WORKSPACE/logstash-input-bugzilla_ci/docker/ELK"
mkdir /tests
echo "====================="
echo "Starting Environment"
echo "====================="
docker-compose up -d
docker ps -a
