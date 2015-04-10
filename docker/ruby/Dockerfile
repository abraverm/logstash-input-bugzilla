FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>

RUN (yum install -y jruby ruby ruby-devel gcc || \
yum install -y jruby ruby ruby-devel gcc)
RUN gem install rubocop rubocop-rspec jruby-lint
