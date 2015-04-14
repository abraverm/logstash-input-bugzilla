FROM node_test
MAINTAINER Alexander Braverman Masis <abraverm@redhat.com>

RUN rpm --rebuilddb && yum install -y gcc gnupg which tar
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN curl -sSL https://get.rvm.io | bash -s stable --ruby=jruby --gems=rubocop,jruby-lint
