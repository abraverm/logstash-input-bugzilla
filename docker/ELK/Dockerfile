FROM node_test
MAINTAINER Alexander Braverman Masis <alexbmasis@gmail.com>
ENV LOGSTASH v1.4.2
ENV JRUBY jruby-1.7.11

RUN rpm --rebuilddb && yum install -y gcc gnupg which tar make
RUN curl -sSL https://rvm.io/mpapis.asc | gpg --import -
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=$JRUBY
ENV PATH $PATH:/usr/local/rvm/bin/
RUN rvm alias create jruby $JRUBY
RUN rvm jruby do gem install rubocop jruby-lint bundler

RUN cd /opt/ && \
git clone -b $LOGSTASH --depth 1 https://github.com/elastic/logstash.git && \
cd logstash && git checkout -b $LOGSTASH
RUN cd /opt/logstash && rvm jruby do bundle install --gemfile=tools/Gemfile --path logstash.gemspec
