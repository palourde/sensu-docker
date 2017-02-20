#!/bin/bash
/etc/init.d/redis-server start

/etc/init.d/rabbitmq-server start
rabbitmqctl add_vhost /sensu
rabbitmqctl add_user sensu P@ssw0rd!
rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
rabbitmqctl set_user_tags sensu administrator

/opt/sensu/bin/sensu-service start server &
/opt/sensu/bin/sensu-service start api &
/opt/sensu/bin/sensu-service start client &

/usr/sbin/sshd -D -o UseDNS=no -o UsePAM=no
