#운영체제 버전에 따라서 apt-get으로 설치되는 application들의 버전이 다르게 설치될 수 있으므로
#debian:buster라고 적는것보다 debian:11.8처럼 버전을 명시적으로 적어주는 것이 좋아보임.
#debian:11.8에서는 php-fpm이 7.4으로 설치되고, debian:buster에서는 php-fpm7.3으로 설치됬던 경험이 있다.
#또한 [apt-get install php7.3-fpm]처럼 application마다 정확한 버전을 설치하는 것도 방법이 될 것 같다.
FROM debian:11.8

RUN apt-get update && apt-get install -y \
	php7.4 \
	php-fpm \
	php-mysql \
	curl \
	dumb-init \
	vim \
	mariadb-client \
	wget \
	psmisc \
	systemctl \
	tree
	# php-mbstring
	# php-cli \
	# php-xml
# 컨테이너 설정 shell script 복사
COPY ./tools /myscript
# nginx구성파일 복사
COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d
#host의 파일이 container로 복사될때 파일권한도 그대로 복사된다.
#실행권한이 없을수도 있기 때문에 무조건 실행을 보장할 수 있도록 실행권한을 부여하는 것이 좋아보인다.
RUN chmod +x /myscript/initwordpress.sh
#php-fpm이 실행될 폴더위치를 직접 만들어줘야함.
RUN mkdir -p /run/php
#wp-cli 설치
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
	chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
#wp 설치
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.tar.gz && \
    tar -xvf latest.tar.gz && \
    rm latest.tar.gz && \
    chown -R www-data:www-data /var/www/html/wordpress
COPY ./conf/wp-config.php /var/www/html/wordpress

ENTRYPOINT ["/usr/bin/dumb-init","--","/myscript/initwordpress.sh"]

# CMD ["/myscript/initwordpress.sh"]
CMD ["/usr/sbin/php-fpm7.4","-F"]