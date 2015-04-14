#!/bin/bash
cd "$WORKSPACE/logstash-input-bugzilla_ci/docker/ELK"
mkdir /tests
cp -R "$WORKSPACE/logstash-input-bugzilla_${BUILD_NUMBER}" /tests/logstash-input-bugzilla
echo "====================="
echo "Starting Environment"
echo "====================="
docker-compose up -d
docker ps -a
