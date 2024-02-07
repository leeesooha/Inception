#!/bin/sh

# --datadir=[데이터디렉토리 경로], --auth-root-authentication-method=[루트사용자 인증방법 옵션명시, normal은 root를 비밀번호사용으로 인증하겠다라는 뜻]
# "mysqld --bootstrap" mysqld실행전 데이터베이스에 대한 초기화를 미리해주는 옵션이다. 이 옵션은 server를 전체를 켜지 않고 설정에 필요한 부분만 동작한다.
# 이 명령어가 끝나면 mysqld를 따로 실행하여 서버를 켜줘야 한다는 것이다.
# flush : 캐시 비우고 다시로드하는 명령어이다.
# flush의 옵션 privileges : 권한테이블에서 모든권한을 다시 로드하는 명령이다.
# grant : 계정에 권한 부여 옵션
# grant의 all privileges 옵션 : SELECT, INSERT, UPDATE, DELETE, CREATE, DROP 등 모든 권한부여
# alter : 기존테이블을 수정하는 명령어
if [ ! -d "/var/lib/mysql/$MYSQL_DB" ];
  then
  mysql_install_db --datadir=/var/lib/mysql --auth-root-authentication-method=normal >/dev/null
  mysqld --bootstrap << EOF
    use mysql;
    flush privileges;
    create database $MYSQL_DB;
    create user '$MYSQL_USER'@'%' identified by '$MYSQL_PASSWORD';
    grant all privileges on $MYSQL_DB.* to '$MYSQL_USER'@'%';
    alter user '$MYSQL_ROOT'@'localhost' identified by '$MYSQL_ROOT_PASSWORD';
    flush privileges;
EOF
fi

chmod -R 777 /var/lib/mysql

exec "$@"