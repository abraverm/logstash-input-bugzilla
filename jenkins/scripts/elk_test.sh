#!/bin/bash
echo "====================="
echo "Copy built gem"
echo "====================="
mv ./*.gem /tests/
echo "====================="
echo "Testing on Logstash"
echo "====================="
sshpass -p123456 ssh -o StrictHostKeyChecking=no root@logstash /bin/bash << ENDSSH
export JAVACMD="/bin/java"
set -x
pushd /opt/logstash
export GEM_HOME="/opt/logstash/vendor/bundle/jruby/1.9"
export GEM_PATH=
java -jar /opt/logstash/vendor/jar/jruby-complete-1.7.11.jar -S gem install specific_install
java -jar /opt/logstash/vendor/jar/jruby-complete-1.7.11.jar -S gem specific_install -l https://alexbmasis@bitbucket.org/alexbmasis/ruby-bugzilla.git
java -jar /opt/logstash/vendor/jar/jruby-complete-1.7.11.jar -S gem install "/logstash-input-bugzilla-*.gem"
cp -R vendor/bundle/jruby/1.9/gems/logstash-input-bugzilla*/lib/logstash/* lib/logstash/
timeout 120 bin/logstash -e 'input { bugzilla {} } output { elasticsearch { host => elasticsearch } stdout {codec => rubydebug} }'
ENDSSH

