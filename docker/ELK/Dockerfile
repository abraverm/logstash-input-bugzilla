FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <alexbmasis@gmail.com>
ENV LOGSTASH logstash-1.4.2

RUN rpm --rebuilddb && yum install -y gcc gnupg which tar
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=jruby --gems=rubocop,jruby-lint

WORKDIR /opt/
RUN curl -O https://download.elasticsearch.org/logstash/logstash/$LOGSTASH.tar.gz && \
        tar -xzf $LOGSTASH.tar.gz && rm -rf $LOGSTASH.tar.gz && mv $LOGSTASH logstash
WORKDIR /opt/logstash
