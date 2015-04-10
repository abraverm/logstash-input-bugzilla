FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>

RUN (dnf install -y ruby ruby-devel gcc rubygem-nokogiri jruby|| \
dnf install -y ruby ruby-devel gcc rubygem-nokogiri jruby)
RUN gem install rubocop rubocop-rspec jruby-lint
