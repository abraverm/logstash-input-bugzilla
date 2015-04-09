FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <alexbmasis@gmail.com>
ENV LOGSTASH logstash-1.4.2

WORKDIR /opt/
RUN curl -O https://download.elasticsearch.org/logstash/logstash/$LOGSTASH.tar.gz && \
        tar -xzf $LOGSTASH.tar.gz && rm -rf $LOGSTASH.tar.gz && mv $LOGSTASH logstash
WORKDIR /opt/logstash
