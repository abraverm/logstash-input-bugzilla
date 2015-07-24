#!/bin/bash
pushd "$WORKSPACE/logstash-input-bugzilla_ci/docker/ELK"
echo "====================="
echo "Starting Environment"
echo "====================="
docker-compose up -d
popd
