FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>

RUN (yum install -y jruby || yum install -y jruby)
RUN gem install rubocop rubocop-rspec jruby-lint
