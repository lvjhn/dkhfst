
ARG ADMINER_PHP_VERSION

# --- load image
FROM $ADMINER_PHP_VERSION

# --- set working directory
WORKDIR /var/www/html

# --- install system dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip unzip curl git \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --- install php extension
RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    pdo_pgsql \
    pgsql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd

# --- expose port
EXPOSE 9000

# --- run php-fpm
CMD ["php-fpm"]
