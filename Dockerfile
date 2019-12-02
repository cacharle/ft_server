FROM debian:buster
RUN apt update && \
	apt install -y nginx mariadb-server php-fpm php-mysql
COPY srcs/pages /var/www/html
COPY srcs/conf /etc/nginx/sites-available/
RUN ln -fs /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/default

EXPOSE 80

CMD service nginx start && \
	service mysql start && \
	service php7.3-fpm start && \
	sleep infinity & wait
