FROM debian:buster

RUN apt update && \
    apt upgrade && \
	apt install -y nginx \
				   php-fpm \
	               mariadb-server \
				   php-mysql \
				   php-mbstring \
				   curl \
                   unzip

RUN mkdir /var/www/wordpress /var/www/phpmyadmin && \
    curl https://wordpress.org/latest.tar.gz > wordpress.tar.gz && \
    curl https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.zip > phpmyadmin.zip && \
    tar xf wordpress.tar.gz && \
    unzip phpmyadmin.zip && \
    mv phpMyAdmin-5.0.2-all-languages phpmyadmin && \
    mv wordpress /var/www && \
    mv phpmyadmin /var/www

COPY srcs/wp-config.php /var/www/wordpress

COPY srcs/nginx_conf /etc/nginx/sites-available/
RUN rm /etc/nginx/sites-enabled/default && \
	ln -fs /etc/nginx/sites-available/ft_server.com /etc/nginx/sites-enabled/ft_server.com

COPY srcs/scripts /root/scripts

RUN service mysql start && \
	mysql -u root < /root/scripts/wordpress_setup.sql && \
	sh /root/scripts/generate_certificates.sh

EXPOSE 80

CMD ["/root/scripts/docker_entrypoint.sh"]
