FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>

RUN (yum install -y rubygems || yum install -y rubygems )
RUN gem install rubocop rubocop-rspec ruby-lint
