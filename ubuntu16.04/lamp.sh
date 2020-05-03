#!/bin/bash

# setup apache2, mysql and php on ubuntu16.04

# env
sudo apt-get update -y
sudo apt-get install build-essential -y

# apache2
sudo apt-get install apache2 -y
sudo systemctl restart apache2
sudo ufw allow in "Apache Full"

# mysql
sudo apt-get install mysql-server -y

# php7.2
sudo add-apt-repository -y ppa:ondrej/php
sudo apt-get update -y
sudo apt-get install -y php7.2
sudo apt-get -y install curl php7.2-pgsql php7.2-curl php7.2-json php7.2-mbstring php7.2-gd php7.2-intl php7.2-xml php7.2-imagick php7.2-redis php7.2-zip
sudo apt-get -y install libapache2-mod-php
sudo systemctl restart apache2
sudo echo '<?php phpinfo(); ?>' > /var/www/html/index.php
