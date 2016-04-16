#!/bin/bash
WEBSERVER_HOME='/var/www/html'
MYSQL_HOST=localhost
MYSQL_PORT=3306
MYSQL_JEEDOM_USER=jeedom
MYSQL_JEEDOM_DBNAME=jeedom
bdd_root_password=Mjeedom96
echo "mysql-server mysql-server/root_password password ${bdd_root_password}" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password ${bdd_root_password}" | debconf-set-selections
apt-get -y install mysql-client mysql-common mysql-server
echo "DROP USER '${MYSQL_JEEDOM_USER}'@'%';" | mysql -uroot -p${bdd_root_password}
echo "CREATE USER '${MYSQL_JEEDOM_USER}'@'%' IDENTIFIED BY '${bdd_root_password}';" | mysql -uroot -p${bdd_root_password}
echo "DROP DATABASE IF EXISTS ${MYSQL_JEEDOM_DBNAME};" | mysql -uroot -p${bdd_root_password}
echo "CREATE DATABASE ${MYSQL_JEEDOM_DBNAME};" | mysql -uroot -p${bdd_root_password}
echo "GRANT ALL PRIVILEGES ON ${MYSQL_JEEDOM_DBNAME}.* TO '${MYSQL_JEEDOM_USER}'@'%';" | mysql -uroot -p${bdd_root_password}

mkdir -p /var/www/html/log
apt-get -y install ntp ca-certificates unzip curl sudo
apt-get -y install apache2 php5 libapache2-mod-php5
apt-get -y install php5-cli php5-common php5-curl php5-fpm php5-json php5-mysql php5-gd php5-ssh2
wget https://raw.githubusercontent.com/jeedom/core/stable/install/apache_security -O /etc/apache2/conf-available/security.conf
systemctl restart apache2
rm /var/www/html/index.html
echo "* * * * * su --shell=/bin/bash - www-data -c '/usr/bin/php /var/www/html/core/php/jeeCron.php' >> /dev/null" | crontab -
echo 'www-data ALL=(ALL) NOPASSWD: ALL' | (EDITOR='tee -a' visudo)
mkdir -p /var/www/html
rm -rf /root/core-*
wget https://github.com/jeedom/core/archive/stable.zip -O /tmp/jeedom.zip
unzip -q /tmp/jeedom.zip -d /root/
cp -R /root/core-*/* ${WEBSERVER_HOME}
cp -R /root/core-*/.htaccess ${WEBSERVER_HOME}
rm -rf /root/core-*
cd ${WEBSERVER_HOME}
cp ${WEBSERVER_HOME}/core/config/common.config.sample.php ${WEBSERVER_HOME}/core/config/common.config.php
sed -i "s/#PASSWORD#/${bdd_root_password}/g" ${WEBSERVER_HOME}/core/config/common.config.php
sed -i "s/#DBNAME#/${MYSQL_JEEDOM_DBNAME}/g" ${WEBSERVER_HOME}/core/config/common.config.php
sed -i "s/#USERNAME#/${MYSQL_JEEDOM_USER}/g" ${WEBSERVER_HOME}/core/config/common.config.php
sed -i "s/#PORT#/${MYSQL_PORT}/g" ${WEBSERVER_HOME}/core/config/common.config.php
sed -i "s/#HOST#/${MYSQL_HOST}/g" ${WEBSERVER_HOME}/core/config/common.config.php

chmod 775 -R ${WEBSERVER_HOME}
chown -R www-data:www-data ${WEBSERVER_HOME}

php ${WEBSERVER_HOME}/install/install.php mode=force

rm -f /tmp/jeedom.zip
rm -f /jeedom
wget http://gamers-city.eu/jeedom/webapp
chmod +x webapp
