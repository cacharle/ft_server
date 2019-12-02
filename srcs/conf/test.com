server {
	listen 80;
	root /var/www/html;
	index index.php;
	server_name test.com;

	location / {
		try_files $uri $uri/ =404;
	}

	location ~ \.php$ {
		include snippets/fastcgi-php.conf;
		fastcgi_pass
			unix:/var/run/php/php7.2-fpm.sock;
	}

	location ~ /\.ht {
		deny all;
	}
}
