#!/bin/sh

service mysql start
service php7.3-fpm start
service nginx start
sleep infinity &
wait
