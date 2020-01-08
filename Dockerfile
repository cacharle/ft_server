FROM debian:buster

RUN apt update && \
	apt install -y nginx \
	               mariadb-server \
				   php-fpm \
				   php-mysql \
				   phpmyadmin \
				   php-mbstring \
				   php-gettext

COPY srcs/wordpress /var/www/html
COPY srcs/conf /etc/nginx/sites-available/

RUN ln -fs /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/default

EXPOSE 80

RUN service nginx start && \
    service mysql start && \
    service php7.3-fpm start

CMD sleep infinity & wait
