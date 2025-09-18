ARG BACKEND_PHP_VERSION

# --- load image
FROM $BACKEND_PHP_VERSION

# --- set working directory
WORKDIR /var/www/html

# --- nsure we run as root for system installs
USER root

# --- install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip \
    postgresql-client \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --- install PHP extensions
RUN docker-php-ext-install \
    pdo \
    pdo_pgsql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd

# --- install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# --- expose port 8000
EXPOSE 8000

# --- switch to www-data for running PHP-FPM
USER www-data
