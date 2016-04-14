FROM php:7-fpm

# Add unzip & git for composer
RUN apt-get update \
    && apt-get install libmcrypt-dev nano bash git unzip zlib1g-dev -y \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-install pdo pdo_mysql mcrypt iconv mbstring zip

WORKDIR /var/www/html

RUN curl -sS https://getcomposer.org/installer | php

RUN mv composer.phar /usr/bin/composer

COPY composer.json  composer.json
COPY composer.lock  composer.lock

RUN composer install --no-dev
