CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'kkilitci'@'%' IDENTIFIED BY 'kkilitcips';
GRANT ALL PRIVILEGES ON wordpress.* TO 'kkilitci'@'%';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'rootkkilitci';
