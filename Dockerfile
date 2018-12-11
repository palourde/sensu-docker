FROM debian:8.2
MAINTAINER Simon Plourde <simon.plourde@gmail.com>

ARG VERSION

RUN mkdir -p /var/run/sshd

RUN apt-get update &&\
  apt-get install -y --force-yes sudo wget openssh-server redis-server apt-transport-https

RUN wget http://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb && \
  dpkg -i erlang-solutions_1.0_all.deb && \
  rm -f erlang-solutions_1.0_all.deb && \
  apt-get install -y socat erlang-base erlang-nox

RUN wget -qO - https://www.rabbitmq.com/rabbitmq-signing-key-public.asc | apt-key add - && \
  echo "deb https://dl.bintray.com/rabbitmq/debian jessie main" > /etc/apt/sources.list.d/rabbitmq.list && \
  apt-get update && \
  apt-get install -y --force-yes rabbitmq-server && \
  rabbitmq-plugins enable rabbitmq_management

RUN wget -q https://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | sudo apt-key add - &&\
  echo "deb     https://sensu.global.ssl.fastly.net/apt jessie main" | tee /etc/apt/sources.list.d/sensu.list && \
  echo "deb     https://sensu.global.ssl.fastly.net/apt jessie unstable" | tee -a /etc/apt/sources.list.d/sensu.list && \
  apt-get update && \
  apt-get install -y sensu=$VERSION

RUN echo "EMBEDDED_RUBY=true" | tee /etc/default/sensu

ADD files/config.json /etc/sensu/
ADD files/client.json /etc/sensu/conf.d/
ADD files/checks.json /etc/sensu/conf.d/
ADD files/return.rb /etc/sensu/plugins/
ADD files/start.sh /tmp/start.sh

CMD ["/tmp/start.sh"]
