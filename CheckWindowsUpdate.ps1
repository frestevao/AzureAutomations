sudo apt update && sudo apt upgrade
sudo apt update && sudo apt upgrade
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php

sudo apt update
sudo apt -y install php8.0

sudo update-alternatives --set php /usr/bin/php$(phpVersion)
sudo update-alternatives --set phar /usr/bin/phar$(phpVersion)
sudo update-alternatives --set phpdbg /usr/bin/phpdbg$(phpVersion)
sudo update-alternatives --set php-cgi /usr/bin/php-cgi$(phpVersion)
sudo update-alternatives --set phar.phar /usr/bin/phar.phar$(phpVersion)
php -version
