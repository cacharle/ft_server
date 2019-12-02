FROM debian:buster
RUN apt update && \
	apt install -y nginx && \
	apt install -y mariadb-server && \
	apt install -y php-fpm php-mysql
COPY srcs/pages /var/www/html
COPY srcs/conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/test.com /etc/nginx/sites-enabled/
	# service nginx start

EXPOSE 80

# STOPSIGNAL SIGTERM
CMD ["nginx", "-g", "daemon off;"]
