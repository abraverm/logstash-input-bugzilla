FROM abraverm/jenkins:node
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>
RUN rpm --rebuilddb && \
yum install -y docker-io libcgroup python-pip dnsmasq sshpass PyYAML python-six
RUN pip install -U docker-compose
RUN echo "user=root" >> /etc/dnsmasq.conf
