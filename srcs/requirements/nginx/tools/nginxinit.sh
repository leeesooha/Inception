#!/bin/bash

openssl req -newkey rsa:4096 -days 365 -nodes -x509 -subj "/C=KR/ST=Seoul/L=Seoul/O=42Seoul/OU=soohlee/CN=localhost" -keyout localhost.dev.key -out localhost.dev.crt
chmod 600 localhost.dev.*
mv localhost.dev.crt /etc/ssl/certs/
mv localhost.dev.key /etc/ssl/private/

ln -s /etc/nginx/sites-available/myconf.conf /etc/nginx/sites-enabled/myconf.conf
rm -rf /etc/nginx/sites-enabled/default

# nginx -g 'daemon off;'
exec "$@"