#!/bin/bash
pushd "$WORKSPACE/logstash-input-bugzilla_ci/docker/ELK-deploy"

echo "========================"
echo "Removing old Deployment"
echo "========================"
docker-compose stop
docker-compose rm
echo "========================"
echo "Starting new Deployment"
echo "========================"
docker-compose up -d

echo "================================"
echo "Deploying the Plugin on Logstash"
echo "================================"
lid=$(docker-compose ps -q logstash)
logstash=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $lid)

sshpass -p123456 scp -o StrictHostKeyChecking=no -r "$WORKSPACE/logstash-input-bugzilla_${BUILD_NUMBER}" "root@$logstash:/"
sshpass -p123456 scp -o StrictHostKeyChecking=no logstash.conf "root@$logstash:/"
sshpass -p123456 ssh -o StrictHostKeyChecking=no "root@$logstash" /bin/bash << ENDSSH
export JAVACMD="/bin/java"
export PATH=$PATH:/usr/local/rvm/bin/
set +x
echo "-------------------"
echo "Building Plugin Gem"
echo "-------------------"
pushd /logstash-input-bugzilla*
rvm jruby do gem build logstash-input-bugzilla.gemspec
mv *.gem /
popd

pushd /opt/logstash
export GEM_HOME="/opt/logstash/vendor/bundle/jruby/1.9"
export GEM_PATH=
echo "------------------------"
echo "Installing Ruby Bugzilla"
echo "------------------------"
java -jar /opt/logstash/vendor/jar/jruby-complete-1.7.11.jar -S gem install specific_install
java -jar /opt/logstash/vendor/jar/jruby-complete-1.7.11.jar -S gem specific_install -l https://alexbmasis@bitbucket.org/alexbmasis/ruby-bugzilla.git
ENDSSH

sshpass -p123456 ssh -o StrictHostKeyChecking=no "root@$logstash" /bin/bash << ENDSSH
set +x
echo "-----------------"
echo "Installing Plugin"
echo "-----------------"
pushd /opt/logstash
export GEM_HOME="/opt/logstash/vendor/bundle/jruby/1.9"
export GEM_PATH=
java -jar /opt/logstash/vendor/jar/jruby-complete-1.7.11.jar -S gem install /logstash-input-bugzilla-*.gem
cp -R vendor/bundle/jruby/1.9/gems/logstash-input-bugzilla*/lib/logstash/* lib/logstash/

nohup bin/logstash -f /logstash.conf -l /logstash.log &
ENDSSH

popd
