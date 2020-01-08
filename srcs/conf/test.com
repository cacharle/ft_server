server {
	listen 80;                   # listen all ip on port 80 (0.0.0.0:80)
	root /var/www;               # where to find files for location blocks
	server_name localhost;       # domain name
	index index.php index.html;  # files for empty uri

	# all uri
	location / {
		try_files $uri $uri/ =404;  # if uri or uri/ not valid, 404 error
	}

	# php files
	location ~ \.php$ {
		include snippets/fastcgi-php.conf;               # include php fpm settings
		fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;  # socket where php fpm is running
	}

	# configuration files, deny access and no logs
	location ~ /\. {
		deny all;
		access_log off;
		log_not_found off;
	}
}
