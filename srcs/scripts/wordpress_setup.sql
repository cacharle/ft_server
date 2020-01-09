CREATE DATABASE wordpressdb;
CREATE USER 'wordpressuser'@'localhost' IDENTIFIED BY 'wordpresspass';
GRANT ALL PRIVILEGES ON wordpressdb.* TO 'wordpressuser'@'localhost'
	IDENTIFIED BY 'wordpresspass';
FLUSH PRIVILEGES;
