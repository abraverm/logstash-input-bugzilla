FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>

RUN (yum install -y jruby ruby || yum install -y jruby ruby)
RUN gem install rubocop rubocop-rspec jruby-lint
