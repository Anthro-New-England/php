ARG PHP_VERSION=fpm-alpine


FROM php:${PHP_VERSION} AS php


FROM php AS build
RUN apk add \
    build-base
COPY deps/imagick/ /usr/src/php/ext/imagick/
COPY deps/phpredis/ /usr/src/php/ext/phpredis/
RUN apk add \
    imagemagick-dev \
    zlib-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libzip-dev \
    icu-dev \
    freetype-dev \
    oniguruma-dev \
    libxml2-dev \
    imap-dev \
    openssl-dev \
    curl-dev
RUN \
    docker-php-ext-configure imap --with-imap-ssl \
    && docker-php-ext-configure gd --with-freetype \
    && docker-php-ext-install \
    mysqli \
    pdo_mysql \
    imagick \
    exif \
    gd \
    zip \
    intl \
    mbstring \
    xml \
    imap \
    curl \
    phpredis


FROM php AS target
RUN apk add \
    imagemagick \
    libgomp \
    libjpeg-turbo \
    libpng \
    icu \
    freetype \
    libzip \
    oniguruma \
    libxml2 \
    c-client
COPY --from=build /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=build /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/
