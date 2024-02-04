# Debian 11.8 이미지를 기반으로 함
FROM debian:11.8

# MariaDB 설치
RUN apt-get update && apt-get install -y \
    dumb-init \
    vim \
    systemctl \
	psmisc \
	tree \
    mariadb-server && rm -rf /var/lib/apt/lists/*

# MariaDB 실행을 위한 초기화 및 설정
RUN mkdir -p /var/run/mysqld && chown -R mysql:mysql /var/run/mysqld
    # rm -f /etc/mysql/mariadb.conf.d/50-server.cnf

COPY ./tools /etc/mariadb/scripts
COPY ./conf/50-server.cnf /etc/mysql/mariadb.conf.d
RUN chmod +x /etc/mariadb/scripts/mariadbinit.sh


ENTRYPOINT ["/usr/bin/dumb-init","--","/etc/mariadb/scripts/mariadbinit.sh"]

# 컨테이너 실행 시 자동으로 MariaDB 실행
# CMD ["/etc/mariadb/scripts/mariadbinit.sh"]
CMD ["mysqld","--datadir=/var/lib/mysql"]