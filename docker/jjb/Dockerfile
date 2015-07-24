FROM lip_bugzilla_node_test
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>

RUN rpm --rebuilddb && yum install -y python-pip PyYAML
RUN pip install jenkins-job-builder
