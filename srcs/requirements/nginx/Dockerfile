FROM debian:11.8

RUN apt-get update && apt-get install -y \
    apt-utils \
    nginx \
    dumb-init \
    vim \
    openssl \
    php-fpm \
    systemctl \
	psmisc \
	tree

# RUN mkdir -p /var/www/html/wordpress
# RUN chown -R www-data:www-data /var/www/html/wordpress

COPY ./conf /etc/nginx/sites-available/
COPY ./tools /etc/nginx/scripts/
# COPY ./srcs /var/www/html/

RUN chmod +x /etc/nginx/scripts/nginxinit.sh
# RUN /etc/nginx/scripts/nginxinit.sh

ENTRYPOINT ["/usr/bin/dumb-init","--","/etc/nginx/scripts/nginxinit.sh"]

# CMD ["/etc/nginx/scripts/nginxinit.sh"]
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 443