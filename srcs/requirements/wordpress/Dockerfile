FROM debian:bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
ca-certificates \
php8.2-fpm \
php8.2-mysql \
wget \
curl \
&& rm -rf /var/lib/apt/lists/*

COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

EXPOSE 9000
CMD ["/init.sh"]