FROM node_test
MAINTAINER Alexander Braverman Masis <alexbmasis@gmail.com>
ENV LOGSTASH 1.4.2

RUN rpm --rebuilddb && yum install -y gcc gnupg which tar
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=jruby --gems=rubocop,jruby-lint,rspec,bundler

# RUN export PATH=$PATH:/usr/local/rvm/bin/ && rvm jruby do gem install logstash 0v $LOGSTASH

WORKDIR /opt/
RUN curl -O https://download.elasticsearch.org/logstash/logstash/logstash-$LOGSTASH.tar.gz && \
    tar -xzf logstash-$LOGSTASH.tar.gz && rm -rf logstash-$LOGSTASH.tar.gz && \
    mv logstash-$LOGSTASH logstash
WORKDIR /opt/logstash
RUN export PATH=$PATH:/usr/local/rvm/bin/ && rvm jruby do rake test:install-core
