#!/bin/bash
pushd "$WORKSPACE/logstash-input-bugzilla_ci/docker/ELK"
docker tag -f abraverm/jenkins:logstash lip_bugzilla_logstash_test
echo "====================="
echo "Starting Environment"
echo "====================="
docker-compose up -d
popd
