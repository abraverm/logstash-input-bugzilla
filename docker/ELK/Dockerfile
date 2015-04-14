FROM node_test
MAINTAINER Alexander Braverman Masis <alexbmasis@gmail.com>
ENV LOGSTASH 1.4.2

RUN rpm --rebuilddb && yum install -y gcc gnupg which tar
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=jruby-1.7.17 --gems=rubocop,jruby-lint,bundler
ENV PATH $PATH:/usr/local/rvm/bin/

RUN cd /opt/ && git clone -b $LOGSTASH --depth 1 https://github.com/elastic/logstash.git
WORKDIR /opt/logstash
RUN rvm jruby do bundle install
RUN rvm jruby do rake test:install-core
RUN rvm jruby do rake test
