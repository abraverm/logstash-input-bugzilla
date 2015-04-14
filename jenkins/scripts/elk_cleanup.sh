#!/bin/bash
cd "$WORKSPACE/logstash-input-bugzilla_ci/docker/ELK"
echo "====================="
echo "Removing Environment"
echo "====================="
docker-compose stop
docker-compose rm --force
