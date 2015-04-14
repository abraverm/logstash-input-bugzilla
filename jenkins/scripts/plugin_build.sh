#!/bin/bash
echo "====================="
echo "Building a Gem file  "
echo "====================="
rvm jruby do gem build logstash-input-bugzilla.gemspec
cp ./*.gem /
echo "====================="
echo "Installing the plugin"
echo "====================="
echo "----------------------------------------------------"
echo "Stable (1.4) Packaged (NOT source code) Logstash"
echi "----------------------------------------------------"
pushd /opt/logstash
# Installing the plugin using gem will make it download dependecies
# declared in gemspec file but it will also ignore Gemfile.
# Meaning jruby will try to install ruby-bugzilla from rubygems.com
# and endup failing. So we first install ruby-bugzilla from the fork.
#
# specific_install - A Rubygem plugin that allows you to install an
# "edge" gem straight from its github repository, or install one
# from an arbitrary url web
export GEM_HOME="$(pwd)/vendor/bundle/jruby/1.9"
export GEM_PATH=
export JRUBY_JAR="$(pwd)/vendor/jar/jruby-complete-1.7.11.jar"
export RUBY_BUGZILLA_URL='https://alexbmasis@bitbucket.org/alexbmasis/ruby-bugzilla.git'
java -jar "$JRUBY_JAR" -S gem install specific_install
java -jar "$JRUBY_JAR" -S gem specific_install -l $RUBY_BUGZILLA_URL
# Installing the plugin
java -jar "$JRUBY_JAR" -S gem install "/logstash-input-bugzilla-*.gem"
cp -R vendor/bundle/jruby/1.9/gems/logstash-input-bugzilla*/lib/logstash/* lib/logstash/
