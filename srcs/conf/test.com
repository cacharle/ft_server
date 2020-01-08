server {
	listen 80;                             # listen all ip on port 80 (0.0.0.0:80)
	root /var/www/html;                    # where to find files for location blocks
	server_name test.com;                  # domain name
	index index.php index.html index.htm;  # files for empty uri

	# all uri
	location / {
		try_files $uri $uri/ =404;  # if uri or uri/ no valid, 404 error
	}

	# php files
	location ~ \.php$ {
		try_files $uri =404;  # try file in uri, if not found fallthrough 404 error

		# php fpm proxy
		fastcgi_pass unix:/var/run/php/php7.3-fpm.sock;                    # socket where php fpm is running
		fastcgi_index index.php                                            # php fpm default index
		fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;  # idk yet
		include snippets/fastcgi-php.conf;                                 # include php fpm settings
	}

	# configuration files
	# deny access and no logs
	location ~ /\. {
		deny all;
		access_log off;
		log_not_found off;
	}
}
