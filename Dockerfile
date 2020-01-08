FROM debian:buster

RUN apt update && \
	apt install -y nginx \
				   php-fpm \
	               mariadb-server \
				   php-mysql
				   # phpmyadmin \
				   # php-mbstring \
				   # php-gettext

COPY srcs/conf /etc/nginx/sites-available/
COPY srcs/wordpress /var/www
# COPY srcs/test /var/www

RUN ln -fs /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/default

EXPOSE 80

RUN service mysql start && \
	echo "CREATE DATABASE testdb;" | mysql -u root && \
	echo "CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY '';" | mysql -u root && \
    echo "GRANT ALL PRIVILEGES ON testdb.* TO 'wordpressuser'@'localhost' IDENTIFIED BY '';" | mysql -u root && \
    echo "FLUSH PRIVILEGES;" | mysql -u root

CMD service php7.3-fpm start && \
	service mysql start && \
	service nginx start && \
	sleep infinity & wait
