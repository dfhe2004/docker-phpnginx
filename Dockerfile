FROM debian:wheezy

MAINTAINER ZOL <hello@zol.fr>

ENV DEBIAN_FRONTEND noninteractive

ENV PATH /usr/sbin:/usr/bin:/usr/local/bin:$PATH

# Install php and nginx
RUN apt-get update && apt-get install -y \
    curl \
    git \
    php5-dev \
    php5-cli \
    php5-mysql \
    php5-intl \
    php5-curl \
    php5-fpm \
    nginx

# According to the Docker way, your container should run only one service.
# That’s the whole purpose of using containers after all.
# So, instead of backgrounding your service, you should leave it running in the foreground.
# You basically run one command, that’s the sole purpose of your container. A very simple-minded container :)
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN sed -i "s/;daemonize\s*=\s*yes/daemonize = no/g" /etc/php5/fpm/php-fpm.conf

# Find the line, cgi.fix_pathinfo=1, and change the 1 to 0.
RUN sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5/fpm/php.ini
# Find the line, listen = 127.0.0.1:9000, and change the 127.0.0.1:9000 to /var/run/php5-fpm.sock.
RUN sed -i "s/;listen\s*=.*/listen = \/var\/run\/php5-fpm.sock/" /etc/php5/fpm/pool.d/www.conf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer

# Install the server start script
COPY start.sh /root/start.sh
RUN chmod u+x /root/start.sh
