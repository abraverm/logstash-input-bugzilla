FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>

RUN (yum insall -y rubygems || yum insall -y rubygems )
RUN gem install rubocop rubocop-rspec ruby-lint
