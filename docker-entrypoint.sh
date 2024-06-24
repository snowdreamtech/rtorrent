#!/bin/sh
set -e

# set RTORRENT_PORT
if [ -n "${RTORRENT_PORT}" ]; then
    sed -i "s/network\.port_range\.set.*/network\.port_range\.set = ""${RTORRENT_PORT}""-""${RTORRENT_PORT}""/g" /var/lib/rtorrent/config/rtorrent.rc
fi

# PHP
# https://wiki.alpinelinux.org/wiki/Nginx_with_PHP#Nginx_with_PHP

# PHP_FPM ENV
PHP_FPM_USER="nginx"
PHP_FPM_GROUP="nginx"
PHP_FPM_LISTEN_MODE="0660"
PHP_MEMORY_LIMIT="512M"
PHP_MAX_UPLOAD="50M"
PHP_MAX_FILE_UPLOAD="200"
PHP_MAX_POST="100M"
PHP_DISPLAY_ERRORS="On"
PHP_DISPLAY_STARTUP_ERRORS="On"
PHP_ERROR_REPORTING="E_COMPILE_ERROR\|E_RECOVERABLE_ERROR\|E_ERROR\|E_CORE_ERROR"
PHP_CGI_FIX_PATHINFO=0

# Modifying configuration file www.conf
# sed -i "user =|user = ${PHP_FPM_USER}|g" /etc/php82/php-fpm.d/www.conf
# sed -i "group =|group = ${PHP_FPM_GROUP}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${PHP_FPM_USER}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${PHP_FPM_GROUP}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;listen.mode\s*=\s*0660|listen.mode = ${PHP_FPM_LISTEN_MODE}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|user\s*=\s*nobody|user = ${PHP_FPM_USER}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|group\s*=\s*nobody|group = ${PHP_FPM_GROUP}|g" /etc/php82/php-fpm.d/www.conf
sed -i "s|;log_level\s*=\s*notice|log_level = notice|g" /etc/php82/php-fpm.d/www.conf #uncommenting line 

# Modifying configuration file php.ini
sed -i "s|display_errors\s*=\s*Off|display_errors = ${PHP_DISPLAY_ERRORS}|i" /etc/php82/php.ini
sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = ${PHP_DISPLAY_STARTUP_ERRORS}|i" /etc/php82/php.ini
sed -i "s|error_reporting\s*=\s*E_ALL & ~E_DEPRECATED & ~E_STRICT|error_reporting = ${PHP_ERROR_REPORTING}|i" /etc/php82/php.ini
sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEMORY_LIMIT}|i" /etc/php82/php.ini
sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_MAX_UPLOAD}|i" /etc/php82/php.ini
sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOAD}|i" /etc/php82/php.ini
sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_MAX_POST}|i" /etc/php82/php.ini
sed -i "s|;*cgi.fix_pathinfo=.*|cgi.fix_pathinfo= ${PHP_CGI_FIX_PATHINFO}|i" /etc/php82/php.ini

# Rutorrent
sed -i "s|\$pathToExternals = array(|\$pathToExternals = array(\n\t\t\"python\"\t=> \"/usr/bin/python\",\t\t\t// Something like /usr/bin/python. If empty, will be found in PATH.|i" /var/lib/nginx/html/rutorrent/conf/config.php
sed -i "s|\t\t\"php\"\t=>.*|\t\t\"php\"\t=> \"/usr/bin/php82\",\t\t\t// Something like /usr/bin/php. If empty, will be found in PATH.|i" /var/lib/nginx/html/rutorrent/conf/config.php
sed -i "s|\t\t\"curl\"\t=>.*|\t\t\"curl\"\t=> \"/usr/bin/curl\",\t\t\t// Something like /usr/bin/php. If empty, will be found in PATH.|i" /var/lib/nginx/html/rutorrent/conf/config.php
sed -i "s|\t\t\"gzip\"\t=>.*|\t\t\"gzip\"\t=> \"/bin/gzip\",\t\t\t// Something like /usr/bin/php. If empty, will be found in PATH.|i" /var/lib/nginx/html/rutorrent/conf/config.php
sed -i "s|\t\t\"id\"\t=>.*|\t\t\"id\"\t=> \"/usr/bin/id\",\t\t\t// Something like /usr/bin/php. If empty, will be found in PATH.|i" /var/lib/nginx/html/rutorrent/conf/config.php
sed -i "s|\t\t\"stat\"\t=>.*|\t\t\"stat\"\t=> \"/bin/stat\",\t\t\t// Something like /usr/bin/php. If empty, will be found in PATH.|i" /var/lib/nginx/html/rutorrent/conf/config.php


# phpinfo for test
echo "<?php
	phpinfo();
?>"> /var/lib/nginx/html/phpinfo.php

# PHP-fpm
php-fpm82 --fpm-config /etc/php82/php-fpm.conf

# Nginx and ruTorrent
/usr/sbin/nginx -c /etc/nginx/nginx.conf

# rtorrent
# /usr/bin/screen -d -m -fa -S rtorrent /usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc
/usr/bin/rtorrent -n -o import=/var/lib/rtorrent/config/rtorrent.rc

# exec commands
exec "$@"