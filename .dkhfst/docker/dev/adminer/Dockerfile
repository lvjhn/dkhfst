ARG ADMINER_PHP_VERSION

# --- load image
FROM $ADMINER_PHP_VERSION

# --- set working directory
WORKDIR /var/www/html

# --- install system dependencies + mkcert requirements
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip unzip curl git \
    libnss3-tools \
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# --- install mkcert
RUN wget -O /usr/local/bin/mkcert https://github.com/FiloSottile/mkcert/releases/latest/download/mkcert-linux-amd64 \
    && chmod +x /usr/local/bin/mkcert \
    && mkcert -install

# --- install php extensions
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
