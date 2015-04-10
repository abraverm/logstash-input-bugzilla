FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>

RUN (yum install -y jruby ruby ruby-devel gcc rubygem-nokogiri|| \
yum install -y jruby ruby ruby-devel gcc rubygem-nokogiri)
RUN gem install rubocop rubocop-rspec jruby-lint
