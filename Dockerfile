FROM debian:buster

RUN apt update && \
	apt install -y nginx \
				   php-fpm \
	               mariadb-server \
				   php-mysql \
				   php-mbstring \
				   curl

RUN mkdir /var/www/wordpress /var/www/phpmyadmin
COPY srcs/wordpress /var/www/wordpress
COPY srcs/phpmyadmin /var/www/phpmyadmin

COPY srcs/nginx_conf /etc/nginx/sites-available/
RUN rm /etc/nginx/sites-enabled/default && \
	ln -fs /etc/nginx/sites-available/ft_server.com /etc/nginx/sites-enabled/ft_server.com

COPY srcs/scripts /root/scripts

RUN service mysql start && \
	mysql -u root < /root/scripts/wordpress_setup.sql && \
	sh /root/scripts/generate_certificates.sh

EXPOSE 80

CMD ["/root/scripts/docker_entrypoint.sh"]
