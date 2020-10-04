FROM php:7.4.2-fpm-buster

RUN apt-get update && apt-get install -y locales \
    && echo "en_US.UTF-8 UTF-8" > /etc/locale.gen \
    && echo "ru_RU.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen

# основные утилиты
RUN apt-get install -y \
    wget \
    curl \
    sudo \
    net-tools \
    libpq-dev \
    libicu-dev \
    apt-utils \
    zip \
    libzip-dev \
    git \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin \
    && mv /usr/bin/composer.phar /usr/bin/composer

RUN docker-php-ext-install pgsql pdo_pgsql \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/include/postgresql/ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install intl \
    && docker-php-ext-configure zip \
    && docker-php-ext-install zip \
    && docker-php-ext-configure sockets \
    && docker-php-ext-install sockets \
    && docker-php-ext-configure pcntl \
    && docker-php-ext-install pcntl

RUN pecl install xdebug && docker-php-ext-enable xdebug
RUN pecl install mongodb && docker-php-ext-enable mongodb

WORKDIR /var/www/xhgui