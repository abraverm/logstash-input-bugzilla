#!/bin/bash
export PATH=$PATH:/usr/local/rvm/bin/
pushd "$WORKSPACE/logstash-input-bugzilla_${BUILD_NUMBER}"
echo "====================="
echo "Building a Gem file  "
echo "====================="
rvm jruby do gem build logstash-input-bugzilla.gemspec
mv *.gem /
popd
