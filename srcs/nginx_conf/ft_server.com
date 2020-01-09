server {
	listen 443 ssl;
	listen [::]:443 ssl;

	ssl_certificate     /root/ssl/localhost.pem;
	ssl_certificate_key /root/ssl/localhost-key.pem;

	server_name localhost;
	index index.php;
	root /var/www/wordpress;

	location / {
		try_files $uri $uri/ =404;  # if uri or uri/ not valid, 404 error
	}

	# phpmyadmin path, change root
	location /phpmyadmin {
		root /var/www;
		index index.php;
		location ~ ^/phpmyadmin/(.+\.php)$ {
			include snippets/fastcgi-php.conf;
			fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;
		}
		location ~ ^/phpmyadmin/(.+\.(jpg|jpeg|gif|css|png|js|ico|html|xml|txt))$ {
			root /var/www;
		}
	}

	# php files
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;               # include php fpm settings
		fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;  # socket where php fpm is running
	}
}

server {
	listen 80;
	listen [::]:80;
	server_name localhost;
	return 301 https://$host$request_uri;
}
