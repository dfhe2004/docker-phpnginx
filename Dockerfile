FROM debian:wheezy

MAINTAINER yourself

ENV DEBIAN_FRONTEND noninteractive

# Install php and nginx
RUN apt-get update && apt-get install -y \
    curl \
    php5-dev \
    php5-cli \
    php5-mysql \
    php5-intl \
    php5-curl \
    php5-fpm \
    php-pear \
    php5-xdebug \
    nginx

# According to the Docker way, your container should run only one service.
# That’s the whole purpose of using containers after all.
# So, instead of backgrounding your service, you should leave it running in the foreground.
# You basically run one command, that’s the sole purpose of your container. A very simple-minded container :)
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# Find the line, cgi.fix_pathinfo=1, and change the 1 to 0.
RUN sed "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" -i /etc/php5/fpm/php.ini \
 && sed 's/^error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT/error_reporting = E_ALL /' -i /etc/php5/fpm/php.ini \
 && sed 's/^display_errors = Off/display_errors = On /' -i /etc/php5/fpm/php.ini \
 && sed 's/^display_startup_errors = Off/display_startup_errors = On/' -i /etc/php5/fpm/php.ini \
 && sed 's/^track_errors = Off/track_errors = On/' -i /etc/php5/fpm/php.ini \
 && sed 's/^;date.timezone =/date.timezone =Asia\/Shanghai /' -i /etc/php5/fpm/php.ini 
 
RUN sed -i "s/;listen.allowed_clients = 127.0.0.1/listen.allowed_clients = 0.0.0.0/" /etc/php5/fpm/pool.d/www.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

EXPOSE 80

# Install the server start script
COPY start.sh /root/start.sh
RUN chmod u+x /root/start.sh
