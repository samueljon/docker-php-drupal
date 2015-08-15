FROM php:7-fpm
MAINTAINER Samúel Jón Gunnarsson <samuel.jon.gunnarsson@gmail.com>

ENV CONTAINER_USER runner
ENV CONTAINER_UID 1000

RUN useradd --uid $CONTAINER_UID --groups www-data $CONTAINER_USER
RUN mkdir -p /websites
CMD chown $CONTAINER_USER.$CONTAINER_USER /websites

# PHP config
#ADD ./php.ini /usr/local/etc/php/

# Install modules
RUN apt-get update \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        opcache \
	zip \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install gd

#RUN apt-get update && apt-get install -y php-pear curl zlib1g-dev libncurses5-dev
#http://pecl.php.net/package/memcache/3.0.8
#RUN curl -L http://pecl.php.net/get/memcache-3.0.8.tgz >> /usr/src/php/ext/memcache.tgz && \
#	tar -xf /usr/src/php/ext/memcache.tgz -C /usr/src/php/ext/ && \
#	rm /usr/src/php/ext/memcache.tgz && \
#	docker-php-ext-install memcache-3.0.8

WORKDIR /websites
COPY ./php-fpm.conf /usr/local/etc/

EXPOSE 9000
CMD ["php-fpm"]
