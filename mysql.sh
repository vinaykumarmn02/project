#!/bin/bash
docker run --name mysql -d \
  -e 'DB_USER=maint' -e 'DB_PASS=redhat@99' -e 'DB_NAME=zabbix' \
  -e 'MYSQL_CHARSET=utf8mb4' -e 'MYSQL_COLLATION=utf8_bin' \
 073e38fb022d 
