CREATE DATABASE IF NOT EXISTS wordpress;
CREATE USER IF NOT EXISTS 'wordpress_user'@'%' IDENTIFIED BY 'wordpress_password_123';
GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress_user'@'%';
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY 'root_password_123';
