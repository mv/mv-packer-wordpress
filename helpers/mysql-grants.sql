
-- Enable remote access
CREATE USER 'root'@'%' IDENTIFIED BY 'root';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'  WITH GRANT OPTION;

-- WP databases
CREATE DATABASE wordpress;
CREATE DATABASE wp;

GRANT ALL ON wordpress.*  TO wpadmin@'%' IDENTIFIED BY 'secretwp';
GRANT ALL ON wp.*         TO wpadmin@'%' IDENTIFIED BY 'secretwp';

