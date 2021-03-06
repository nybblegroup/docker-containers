FROM php:7.3.16-apache

ENV APACHE_DOCUMENT_ROOT /var/www/html/docroot

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# update & extensions
RUN apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        nano \
    && docker-php-ext-configure gd \
    && docker-php-ext-install -j$(nproc) pdo_mysql mysqli gd

# drush
RUN curl -OL https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar \
		&& chmod +x drush.phar \
		&& mv drush.phar /usr/local/bin/drush

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

ADD start.sh start.sh
RUN chmod +x start.sh

EXPOSE 22
EXPOSE 80

CMD ["/bin/sh", "start.sh"]