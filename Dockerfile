FROM php:7.3-fpm

LABEL maintainer="charlestide@vip.163.com"

RUN apt-get update && apt-get install -y nginx
# procps vim && alias ll="ls -l"

# nginx配置和运行
COPY ./nginx/default.conf /etc/nginx/sites-available/default
RUN mkdir /var/log/docker

# php-fpm配置
RUN rm /usr/local/etc/php-fpm.d/zz-docker.conf && rm /usr/local/etc/php-fpm.d/www*.conf
ADD ./php/www.conf /usr/local/etc/php-fpm.d/www.conf
ADD ./php/php-fpm.conf /usr/local/etc/php-fpm.conf

# php.ini
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"

# phpinfo
ADD ./php/phpinfo.php /var/www/html

EXPOSE 443 80
STOPSIGNAL SIGQUIT

ENV LOG_PATH /var/log/docker
ENV WEB_ROOT /var/www/html

# ADD ./start.sh /var/www/html/start.sh
# RUN chmod +x /var/www/html/start.sh
ENTRYPOINT nginx && php-fpm


